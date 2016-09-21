//
//  HandCardType
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: HandCardType

public enum HandCardType: String {
    /// Branch to another hand.
    case branch
    
    /// Repeat executing the hand.
    case repeatHand
    
    /// Conclude the hand when ALL conditions are satisfied
    case endWhenAllSatisfied
    
    /// Conclude the hand when ANY condition is satisfied
    case endWhenAnySatisfied
    
    /// Perform a boolean AND to determine whether this card is satisfied.
    case booleanLogicAnd
    
    /// Perform a boolean OR to determine whether this card is satisfied.
    case booleanLogicOr
    
    /// Perform a boolean NOT to determine whether this card is satisfied.
    case booleanLogicNot
}

// MARK: JSONEncodable

extension HandCardType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .branch:
            return .string("branch")
        case .repeatHand:
            return .string("repeatHand")
        case .endWhenAllSatisfied:
            return .string("endWHenAllSatisfied")
        case .endWhenAnySatisfied:
            return .string("endWhenAnySatisfied")
        case .booleanLogicAnd:
            return .string("booleanLogicAnd")
        case .booleanLogicOr:
            return .string("booleanLogicOr")
        case .booleanLogicNot:
            return .string("booleanLogicNot")
        }
    }
}

// MARK: JSONDecodable

extension HandCardType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString()
        guard let typeEnum = HandCardType(rawValue: type) else {
            throw JSON.Error.valueNotConvertible(value: json, to: HandCardType.self)
        }
        self = typeEnum
    }
}
