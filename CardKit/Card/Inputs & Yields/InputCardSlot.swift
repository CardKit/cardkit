//
//  InputCardSlot.swift
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

//MARK: Equatable

extension InputCardSlot: Equatable {}

public func == (lhs: InputCardSlot, rhs: InputCardSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.descriptor == rhs.descriptor
    equal = equal && lhs.isOptional == rhs.isOptional
    return equal
}

//MARK: Hashable

extension InputCardSlot: Hashable {
    public var hashValue: Int {
        let a: Int = identifier.hashValue
        let b: Int = descriptor.hashValue
        let c: Int = isOptional.hashValue
        return a &+ (b &* 3) &+ (c &* 5)
    }
}

//MARK: JSONDecodable

extension InputCardSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.descriptor = try json.decode("descriptor", type: InputCardDescriptor.self)
        self.isOptional = try json.bool("isOptional")
    }
}

//MARK: JSONEncodable

extension InputCardSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "isOptional": self.isOptional.toJSON()
            ])
    }
}
