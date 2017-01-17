//
//  TokenSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: TokenSlot

/// Token slots are named with Strings.
public typealias TokenSlotName = String

/// Represents the metadata of a token.
public struct TokenSlot {
    public let name: TokenSlotName
    public let descriptor: TokenCardDescriptor
    
    public init(name: TokenSlotName, descriptor: TokenCardDescriptor) {
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

// MARK: JSONDecodable

extension TokenSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.descriptor = try json.decode(at: "descriptor", type: TokenCardDescriptor.self)
    }
}

// MARK: JSONEncodable

extension TokenSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "name": self.name.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

// MARK: [TokenSlot]

extension Sequence where Iterator.Element == TokenSlot {
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

// MARK: JSONEncodable

extension TokenSlotBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .unbound:
            return .dictionary([
                "type": "unbound"])
        case .boundToTokenCard(let identifier):
            return .dictionary([
                "type": "boundToTokenCard",
                "target": identifier.toJSON()])
        }
    }
}

// MARK: JSONDecodable

extension TokenSlotBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "unbound":
            self = .unbound
        case "boundToTokenCard":
            let target = try json.decode(at: "target", type: CardIdentifier.self)
            self = .boundToTokenCard(target)
        default:
            throw JSON.Error.valueNotConvertible(value: json, to: TokenSlotBinding.self)
        }
    }
}
