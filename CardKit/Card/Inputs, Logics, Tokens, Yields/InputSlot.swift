//
//  InputSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: InputSlot

/// Input slots are named with Strings.
public typealias InputSlotName = String

/// Represents the metadata of an input to a card. Input is bound to a specified slot in the card. Inputs may be optional.
public struct InputSlot {
    /// The name of an InputSlot is a human-understandable name, such as "Duration" or
    /// "Location". This is NOT a UUID-based identifier as used for Cards, Yields, etc.
    public let name: InputSlotName
    public let descriptor: InputCardDescriptor
    public let isOptional: Bool
    
    public init(name: InputSlotName, descriptor: InputCardDescriptor, isOptional: Bool) {
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

// MARK: JSONDecodable

extension InputSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.descriptor = try json.decode(at: "descriptor", type: InputCardDescriptor.self)
        self.isOptional = try json.getBool(at: "isOptional")
    }
}

// MARK: JSONEncodable

extension InputSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "name": self.name.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}

// MARK: [InputSlot]

extension Sequence where Iterator.Element == InputSlot {
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
        case .boundToYieldingActionCard(let cardIdentifier, let yield):
            return "[bound to ActionCard \(cardIdentifier) Yield \(yield)]"
        }
    }
}

// MARK: JSONEncodable

extension InputSlotBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .unbound:
            return .dictionary([
                "type": "unbound"])
        case .boundToInputCard(let card):
            return .dictionary([
                "type": "boundToInputCard",
                "target": card.toJSON()])
        case .boundToYieldingActionCard(let cardIdentifier, let yield):
            return .dictionary([
                "type": "boundToYieldingActionCard",
                "identifier": cardIdentifier.toJSON(),
                "yield": yield.toJSON()])
        }
    }
}

// MARK: JSONDecodable

extension InputSlotBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "unbound":
            self = .unbound
        case "boundToInputCard":
            let target = try json.decode(at: "target", type: InputCard.self)
            self = .boundToInputCard(target)
        case "boundToYieldingActionCard":
            let identifier = try json.getString(at: "identifier")
            let cardIdentifier = CardIdentifier(with: identifier)
            let yield = try json.decode(at: "yield", type: Yield.self)
            self = .boundToYieldingActionCard(cardIdentifier, yield)
        default:
            throw JSON.Error.valueNotConvertible(value: json, to: InputSlotBinding.self)
        }
    }
}
