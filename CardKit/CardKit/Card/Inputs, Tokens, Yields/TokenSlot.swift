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
