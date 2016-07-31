//
//  AcceptsInputs.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: InputCardSlot

/// Input slots are identified by a string. These strings should be defined in a String enum by the card implementations that need inputs.
/// For example, a `CKTimer` card may define `enum CKTimerInputSlot: String { case Duration }`.
/// This way, we do away with having "magic" string keys and can use type-checking to make sure we are correctly binding an Input card to the right slot.
public typealias InputSlotIdentifier = String

/// Represents the metadata of an input to a card. Input is bound to a specified slot in the card. Inputs may be optional.
public struct InputCardSlot {
    public let identifier: InputSlotIdentifier
    public let descriptor: InputCardDescriptor
    public let isOptional: Bool
    
    init(identifier: InputSlotIdentifier, descriptor: InputCardDescriptor, isOptional: Bool) {
        self.identifier = identifier
        self.descriptor = descriptor
        self.isOptional = isOptional
    }
}

extension InputCardSlot: Equatable {}

public func == (lhs: InputCardSlot, rhs: InputCardSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.descriptor == rhs.descriptor
    equal = equal && lhs.isOptional == rhs.isOptional
    return equal
}

extension InputCardSlot: Hashable {
    public var hashValue: Int {
        let a: Int = identifier.hashValue
        let b: Int = descriptor.hashValue
        let c: Int = isOptional.hashValue
        return a &+ (b &* 3) &+ (c &* 5)
    }
}

extension InputCardSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.descriptor = try json.decode("descriptor", type: InputCardDescriptor.self)
        self.isOptional = try json.bool("isOptional")
    }
}

extension InputCardSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}

//MARK: AcceptsInputs

/// Applied to card descriptors that accept inputs
protocol AcceptsInputs {
    var inputs: [InputCardSlot] { get }
}

/// Applied to card instances that accept inputs
protocol ImplementsAcceptsInputs {
    var inputBindings: [InputCardSlot : InputCard] { get }
    func bind(card: InputCard, to slot: InputCardSlot)
    func unbind(slot: InputCardSlot)
    func valueForInput(slot: InputCardSlot) -> YieldBinding?
}
