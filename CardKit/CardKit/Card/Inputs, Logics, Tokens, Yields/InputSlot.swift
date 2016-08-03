//
//  InputSlot.swift
//  CardKit
//
//  Created by Justin Weisz on 8/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

/// Input slots are identified by a String.
public typealias InputSlotIdentifier = String

/// Represents the metadata of an input to a card. Input is bound to a specified slot in the card. Inputs may be optional.
public struct InputSlot {
    public let identifier: InputSlotIdentifier
    public let type: InputType
    public let isOptional: Bool
    
    init(identifier: InputSlotIdentifier, type: InputType, isOptional: Bool) {
        self.identifier = identifier
        self.type = type
        self.isOptional = isOptional
    }
}

//MARK: Equatable

extension InputSlot: Equatable {}

public func == (lhs: InputSlot, rhs: InputSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.type == rhs.type
    equal = equal && lhs.isOptional == rhs.isOptional
    return equal
}

//MARK: Hashable

extension InputSlot: Hashable {
    public var hashValue: Int {
        let a: Int = identifier.hashValue
        let b: Int = type.hashValue
        let c: Int = isOptional.hashValue
        return a &+ (b &* 3) &+ (c &* 5)
    }
}

//MARK: JSONDecodable

extension InputSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.type = try json.decode("type", type: InputType.self)
        self.isOptional = try json.bool("isOptional")
    }
}

//MARK: JSONEncodable

extension InputSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "type": self.type.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}
