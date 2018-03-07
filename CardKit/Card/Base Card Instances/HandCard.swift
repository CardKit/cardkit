/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

// MARK: HandCard

public class HandCard: Card, Codable {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // fileprivate because this class should not be instantiated directly; rather,
    // one of its subclasses should be instantiated (LogicHandCard, BranchHandCard, etc.)
    fileprivate init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

// MARK: Equatable

extension HandCard: Equatable {
    static public func == (lhs: HandCard, rhs: HandCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension HandCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}


// MARK: - BranchHandCard

public class BranchHandCard: HandCard {
    public var cardTreeIdentifier: CardTreeIdentifier?
    public var targetHandIdentifier: HandIdentifier?
    
    enum CodingKeys: String, CodingKey {
        case cardTreeIdentifier
        case targetHandIdentifier
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        var cardTreeIdentifier: CardTreeIdentifier? = nil
        do {
            cardTreeIdentifier = try values.decode(CardTreeIdentifier.self, forKey: .cardTreeIdentifier)
        } catch {}
        
        var targetHandIdentifier: HandIdentifier? = nil
        do {
            targetHandIdentifier = try values.decode(HandIdentifier.self, forKey: .targetHandIdentifier)
        } catch {}
        
        self.cardTreeIdentifier = cardTreeIdentifier
        self.targetHandIdentifier = targetHandIdentifier
        
        try super.init(from: decoder)
    }
}


// MARK: - RepeatHandCard

public class RepeatHandCard: HandCard {
    public var repeatCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case repeatCount
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.repeatCount = try values.decode(Int.self, forKey: .repeatCount)
        try super.init(from: decoder)
    }
}

// MARK: - EndRuleHandCard

public class EndRuleHandCard: HandCard {
    public var endRule: HandEndRule {
        switch self.descriptor.handCardType {
        case .endWhenAnySatisfied:
            return .endWhenAnySatisfied
        case .endWhenAllSatisfied:
            return .endWhenAllSatisfied
        default:
            return .indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// MARK: - LogicHandCard

public class LogicHandCard: HandCard {
    public var operation: HandLogicOperation {
        switch self.descriptor.handCardType {
        case .booleanLogicAnd:
            return .booleanAnd
        case .booleanLogicOr:
            return .booleanOr
        case .booleanLogicNot:
            return .booleanNot
        default:
            return .indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func asCardTreeNode() -> CardTreeNode? {
        switch self.operation {
        case .booleanAnd, .booleanOr:
            return .binaryLogic(self, nil, nil)
        case .booleanNot:
            return .unaryLogic(self, nil)
        default:
            return nil
        }
    }
    
    func asCardTree() -> CardTree? {
        let tree = CardTree()
        tree.root = self.asCardTreeNode()
        return tree
    }
}
