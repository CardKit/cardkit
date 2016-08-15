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
    case Action
    case Deck
    case Hand
    case Input
    case Token
}

//MARK: JSONEncodable

extension CardType: JSONEncodable {
    public func toJSON() -> JSON {
        return rawValue.toJSON()
    }
}

//MARK: JSONDecodable

extension CardType: JSONDecodable {
    public init(json: JSON) throws {
        let string = try json.decode(type: String.self)
        guard let value = CardType(rawValue: string) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: CardType.self)
        }
        self = value
    }
}
