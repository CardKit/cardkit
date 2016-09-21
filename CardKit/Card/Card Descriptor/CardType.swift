//
//  CardType.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public enum CardType: String {
    case action
    case deck
    case hand
    case input
    case token
}

// MARK: JSONEncodable

extension CardType: JSONEncodable {
    public func toJSON() -> JSON {
        return rawValue.toJSON()
    }
}

// MARK: JSONDecodable

extension CardType: JSONDecodable {
    public init(json: JSON) throws {
        let string = try json.decode(type: String.self)
        guard let value = CardType(rawValue: string) else {
            throw JSON.Error.valueNotConvertible(value: json, to: CardType.self)
        }
        self = value
    }
}
