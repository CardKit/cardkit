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

// MARK: InputSlot

/// Represents the metadata of an input to a card. Input is bound to a specified slot in the card. Inputs may be optional.
public struct InputSlot: Codable {
    /// The name of an InputSlot is a human-understandable name, such as "Duration" or
    /// "Location". This is NOT a UUID-based identifier as used for Cards, Yields, etc.
    public let name: String
    public let descriptor: InputCardDescriptor
    public let isOptional: Bool
    
    public init(name: String, descriptor: InputCardDescriptor, isOptional: Bool) {
        self.name = name
        self.descriptor = descriptor
        self.isOptional = isOptional
    }
}

// MARK: Equatable

extension InputSlot: Equatable {
    static public func == (lhs: InputSlot, rhs: InputSlot) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.descriptor == rhs.descriptor
        equal = equal && lhs.isOptional == rhs.isOptional
        return equal
    }
}

// MARK: Hashable

extension InputSlot: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (descriptor.hashValue &* 3) &+ (isOptional.hashValue &* 5)
    }
}

// MARK: [InputSlot]

extension Array where Element == InputSlot {
    public func slot(named name: String) -> InputSlot? {
        for slot in self {
            if slot.name == name {
                return slot
            }
        }
        return nil
    }
}

// MARK: - InputSlotBinding

/// An InputSlot may either be bound to an InputCard or an ActionCard that produces a yield.
/// In the case of an InputCard, we store the entire instance of the InputCard in the slot, 
/// because the InputCard is considered a "child" that is "bound" to the slot. In the case 
/// of a yielding ActionCard, that ActionCard belongs to an (earlier) Hand, so we just store
/// it's identifier here.
public enum InputSlotBinding {
    case unbound
    case boundToInputCard(InputCard)
    case boundToYieldingActionCard(CardIdentifier, Yield)
}

// MARK: CustomStringConvertable

extension InputSlotBinding: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unbound:
            return "[unbound]"
        case .boundToInputCard(let card):
            return "[bound to InputCard \(card.identifier)]"
        case .boundToYieldingActionCard(let identifier, let yield):
            return "[bound to ActionCard \(identifier) Yield \(yield)]"
        }
    }
}

// MARK: Codable

extension InputSlotBinding: Codable {
    enum CodingError: Error {
        case unknownBindingStatus(String)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case inputCard
        case cardIdentifier
        case yield
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let status = try values.decode(String.self, forKey: .status)
        switch status {
        case "unbound":
            self = .unbound
        case "boundToInputCard":
            let inputCard = try values.decode(InputCard.self, forKey: .inputCard)
            self = .boundToInputCard(inputCard)
        case "boundToYieldingActionCard":
            let identifier = try values.decode(CardIdentifier.self, forKey: .cardIdentifier)
            let yield = try values.decode(Yield.self, forKey: .yield)
            self = .boundToYieldingActionCard(identifier, yield)
        default:
            throw CodingError.unknownBindingStatus(status)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .unbound:
            try container.encode("unbound", forKey: .status)
        case .boundToInputCard(let inputCard):
            try container.encode("boundToInputCard", forKey: .status)
            try container.encode(inputCard, forKey: .inputCard)
        case .boundToYieldingActionCard(let identifier, let yield):
            try container.encode("boundToYieldingActionCard", forKey: .status)
            try container.encode(identifier, forKey: .cardIdentifier)
            try container.encode(yield, forKey: .yield)
        }
    }
}
