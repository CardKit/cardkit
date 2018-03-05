//
//  TokenSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

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
