//
//  InputSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: InputSlot

/// Input slots are named with Strings.
public typealias InputSlotName = String

/// Represents the metadata of an input to a card. Input is bound to a specified slot in the card. Inputs may be optional.
public struct InputSlot {
    /// The name of an InputSlot is a human-understandable name, such as "Duration" or
    /// "Location". This is NOT a UUID-based identifier as used for Cards, Yields, etc.
    public let name: InputSlotName
    public let inputType: InputType
    public let isOptional: Bool
    
    public init(name: InputSlotName, type: InputType, isOptional: Bool) {
        self.name = name
        self.inputType = type
        self.isOptional = isOptional
    }
}

//MARK: Equatable

extension InputSlot: Equatable {}

public func == (lhs: InputSlot, rhs: InputSlot) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.inputType == rhs.inputType
    equal = equal && lhs.isOptional == rhs.isOptional
    return equal
}

//MARK: Hashable

extension InputSlot: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (inputType.hashValue &* 3) &+ (isOptional.hashValue &* 5)
    }
}

//MARK: JSONDecodable

extension InputSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.string("name")
        self.inputType = try json.decode("inputType", type: InputType.self)
        self.isOptional = try json.bool("isOptional")
    }
}

//MARK: JSONEncodable

extension InputSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "name": self.name.toJSON(),
            "inputType": self.inputType.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}

//MARK: [InputSlot]

extension SequenceType where Generator.Element == InputSlot {
    public func slot(named name: String) -> InputSlot? {
        for slot in self {
            if slot.name == name {
                return slot
            }
        }
        return nil
    }
}

//MARK:- InputSlotBinding

/// An InputSlot may either be bound to an InputCard or an ActionCard that produces a yield.
/// In the case of an InputCard, we store the entire instance of the InputCard in the slot, 
/// because the InputCard is considered a "child" that is "bound" to the slot. In the case 
/// of a yielding ActionCard, that ActionCard belongs to an (earlier) Hand, so we just store
/// it's identifier here.
public enum InputSlotBinding {
    case Unbound
    case BoundToInputCard(InputCard)
    case BoundToYieldingActionCard(CardIdentifier, Yield)
}

//MARK: CustomStringConvertable

extension InputSlotBinding: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .Unbound:
                return "[unbound]"
            case .BoundToInputCard(let card):
                return "[bound to InputCard \(card.identifier)]"
            case .BoundToYieldingActionCard(let cardIdentifier, let yield):
                return "[bound to ActionCard \(cardIdentifier) Yield \(yield)]"
            }
        }
    }
}

//MARK: JSONEncodable

extension InputSlotBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Unbound:
            return .Dictionary([
                "type": "Unbound"])
        case .BoundToInputCard(let card):
            return .Dictionary([
                "type": "BoundToInputCard",
                "target": card.toJSON()])
        case .BoundToYieldingActionCard(let cardIdentifier, let yield):
            return .Dictionary([
                "type": "BoundToYieldingActionCard",
                "identifier": cardIdentifier.toJSON(),
                "yield": yield.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension InputSlotBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        
        switch type {
        case "Unbound":
            self = .Unbound
        case "BoundToInputCard":
            let target = try json.decode("target", type: InputCard.self)
            self = .BoundToInputCard(target)
        case "BoundToYieldingActionCard":
            let identifier = try json.string("identifier")
            let cardIdentifier = CardIdentifier(with: identifier)
            let yield = try json.decode("yield", type: Yield.self)
            self = .BoundToYieldingActionCard(cardIdentifier, yield)
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: InputSlotBinding.self)
        }
    }
}
