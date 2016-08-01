//
//  AcceptsTokens.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: TokenCardSlot

public typealias TokenIdentifier = String

/// Represents the metadata of a token.
public struct TokenCardSlot {
    public let identifier: TokenIdentifier
    public let descriptor: TokenCardDescriptor
}

extension TokenCardSlot: Equatable {}

public func == (lhs: TokenCardSlot, rhs: TokenCardSlot) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.descriptor == rhs.descriptor
    return equal
}

extension TokenCardSlot: Hashable {
    public var hashValue: Int {
        let a: Int = identifier.hashValue
        let b: Int = descriptor.hashValue
        return a &+ (b &* 3)
    }
}

extension TokenCardSlot: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string("identifier")
        self.descriptor = try json.decode("descriptor", type: TokenCardDescriptor.self)
    }
}

extension TokenCardSlot: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

//MARK: AcceptsTokens

/// Applied to card descriptors that accept tokens
protocol AcceptsTokens {
    var tokens: [TokenCardSlot] { get }
}

/// Appled to card instances that accept tokens
protocol ImplementsAcceptsTokens {
    var tokenBindings: [TokenCardSlot : TokenCard] { get }
    func bind(card: TokenCard, to slot: TokenCardSlot)
    func unbind(slot: TokenCardSlot)
    func isBound(slot: TokenCardSlot) -> Bool
}
