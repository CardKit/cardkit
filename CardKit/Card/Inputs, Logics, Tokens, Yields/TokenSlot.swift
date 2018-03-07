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

// MARK: TokenSlot

/// Represents the metadata of a token.
public struct TokenSlot: Codable {
    public let name: String
    public let descriptor: TokenCardDescriptor
    
    public init(name: String, descriptor: TokenCardDescriptor) {
        self.name = name
        self.descriptor = descriptor
    }
}

// MARK: Equatable

extension TokenSlot: Equatable {
    static public func == (lhs: TokenSlot, rhs: TokenSlot) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.descriptor == rhs.descriptor
        return equal
    }
}

// MARK: Hashable

extension TokenSlot: Hashable {
    public var hashValue: Int {
        let a: Int = name.hashValue
        let b: Int = descriptor.hashValue
        return a &+ (b &* 3)
    }
}

// MARK: [TokenSlot]

extension Array where Element == TokenSlot {
    public func slot(named name: String) -> TokenSlot? {
        for slot in self {
            if slot.name == name {
                return slot
            }
        }
        return nil
    }
}

// MARK: - TokenSlotBinding

/// A TokenSlot may only be bound to a TokenCard.
public enum TokenSlotBinding {
    case unbound
    case boundToTokenCard(CardIdentifier)
}

// MARK: CustomStringConvertable

extension TokenSlotBinding: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unbound:
            return "[unbound]"
        case .boundToTokenCard(let identifier):
            return "[bound to TokenCard \(identifier)]"
        }
    }
}

// MARK: Codable

extension TokenSlotBinding: Codable {
    enum CodingError: Error {
        case unknownBindingStatus(String)
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case cardIdentifier
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let status = try values.decode(String.self, forKey: .status)
        switch status {
        case "unbound":
            self = .unbound
        case "boundToTokenCard":
            let identifier = try values.decode(CardIdentifier.self, forKey: .cardIdentifier)
            self = .boundToTokenCard(identifier)
        default:
            throw CodingError.unknownBindingStatus(status)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .unbound:
            try container.encode("unbound", forKey: .status)
        case .boundToTokenCard(let identifier):
            try container.encode("boundToTokenCard", forKey: .status)
            try container.encode(identifier, forKey: .cardIdentifier)
        }
    }
}
