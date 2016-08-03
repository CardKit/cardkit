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
    public let inputType: InputType
    public let isOptional: Bool
    
    init(identifier: InputSlotIdentifier, type: InputType, isOptional: Bool) {
        self.identifier = identifier
        self.inputType = type
        self.isOptional = isOptional
    }
}

//MARK: Equatable

extension InputSlot: Equatable {}

public func == (lhs: InputSlot, rhs: InputSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.inputType == rhs.inputType
    equal = equal && lhs.isOptional == rhs.isOptional
    return equal
}

//MARK: Hashable

extension InputSlot: Hashable {
    public var hashValue: Int {
        return identifier.hashValue &+ (inputType.hashValue &* 3) &+ (isOptional.hashValue &* 5)
    }
}

//MARK: JSONDecodable

extension InputSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.inputType = try json.decode("inputType", type: InputType.self)
        self.isOptional = try json.bool("isOptional")
    }
}

//MARK: JSONEncodable

extension InputSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "inputType": self.inputType.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}
