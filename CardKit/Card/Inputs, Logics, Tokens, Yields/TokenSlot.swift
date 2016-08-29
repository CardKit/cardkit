//
//  TokenSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: TokenSlot

/// Token slots are identified by a String.
public typealias TokenIdentifier = String

/// Represents the metadata of a token.
public struct TokenSlot {
    public let identifier: TokenIdentifier
    public let descriptor: TokenCardDescriptor
}

//MARK: Equatable

extension TokenSlot: Equatable {}

public func == (lhs: TokenSlot, rhs: TokenSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.descriptor == rhs.descriptor
    return equal
}

//MARK: Hashable

extension TokenSlot: Hashable {
    public var hashValue: Int {
        let a: Int = identifier.hashValue
        let b: Int = descriptor.hashValue
        return a &+ (b &* 3)
    }
}

//MARK: JSONDecodable

extension TokenSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.descriptor = try json.decode("descriptor", type: TokenCardDescriptor.self)
    }
}

//MARK: JSONEncodable

extension TokenSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

//MARK: [TokenSlot]

extension SequenceType where Generator.Element == TokenSlot {
    public func slot(with identifier: String) -> TokenSlot? {
        for slot in self {
            if slot.identifier == identifier {
                return slot
            }
        }
        return nil
    }
}

//MARK:- TokenSlotBinding

/// A TokenSlot may only be bound to a TokenCard.
public enum TokenSlotBinding {
    case Unbound
    case BoundToTokenCard(CardIdentifier)
}

//MARK: CustomStringConvertable

extension TokenSlotBinding: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .Unbound:
                return "[unbound]"
            case .BoundToTokenCard(let identifier):
                return "[bound to TokenCard \(identifier)]"
            }
        }
    }
}

//MARK: JSONEncodable

extension TokenSlotBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Unbound:
            return .Dictionary([
                "type": "Unbound"])
        case .BoundToTokenCard(let identifier):
            return .Dictionary([
                "type": "BoundToTokenCard",
                "target": identifier.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension TokenSlotBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        
        switch type {
        case "Unbound":
            self = .Unbound
        case "BoundToTokenCard":
            let target = try json.decode("target", type: CardIdentifier.self)
            self = .BoundToTokenCard(target)
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: TokenSlotBinding.self)
        }
    }
}
