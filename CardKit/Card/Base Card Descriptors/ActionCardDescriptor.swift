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

// MARK: ActionCardDescriptor

public struct ActionCardDescriptor: CardDescriptor, AcceptsInputs, AcceptsTokens, ProducesYields, Satisfiable, Codable {
    public let cardType: CardType = .action
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public let inputSlots: [InputSlot]
    public let tokenSlots: [TokenSlot]
    
    public var producesYields: Bool {
        return yields.count > 0
    }
    public let yields: [Yield]
    public let yieldDescription: String
    
    public let ends: Bool
    public let endDescription: String
    
    public init(name: String, subpath: String?, inputs: [InputSlot]?, tokens: [TokenSlot]?, yields: [Yield]?, yieldDescription: String?, ends: Bool, endsDescription: String?, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Action/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Action")
        }
        self.assetCatalog = assetCatalog
        
        self.inputSlots = inputs ?? []
        self.tokenSlots = tokens ?? []
        self.yields = yields ?? []
        self.yieldDescription = yieldDescription ?? ""
        self.ends = ends
        self.endDescription = endsDescription ?? ""
    }
    
    /// Return a new ActionCard instance using our descriptor
    public func makeCard() -> ActionCard {
        return ActionCard(with: self)
    }
}

// MARK: Equatable

extension ActionCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same.
    /// All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension ActionCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension ActionCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}
