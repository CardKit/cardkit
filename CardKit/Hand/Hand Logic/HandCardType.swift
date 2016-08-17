//
//  HandCardType
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: HandCardType

public enum HandCardType: String {
    /// Branch to another hand.
    case Branch
    
    /// Repeat executing the hand.
    case Repeat
    
    /// Conclude the hand when ALL conditions are satisfied
    case EndWhenAllSatisfied
    
    /// Conclude the hand when ANY condition is satisfied
    case EndWhenAnySatisfied
    
    /// Perform a boolean AND to determine whether this card is satisfied.
    case BooleanLogicAnd
    
    /// Perform a boolean OR to determine whether this card is satisfied.
    case BooleanLogicOr
    
    /// Perform a boolean NOT to determine whether this card is satisfied.
    case BooleanLogicNot
}

//MARK: JSONEncodable

extension HandCardType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Branch:
            return .String("Branch")
        case .Repeat:
            return .String("Repeat")
        case .EndWhenAllSatisfied:
            return .String("EndWHenAllSatisfied")
        case .EndWhenAnySatisfied:
            return .String("EndWhenAnySatisfied")
        case .BooleanLogicAnd:
            return .String("BooleanLogicAnd")
        case .BooleanLogicOr:
            return .String("BooleanLogicOr")
        case .BooleanLogicNot:
            return .String("BooleanLogicNot")
        }
    }
}

//MARK: JSONDecodable

extension HandCardType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = HandCardType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: HandCardType.self)
        }
        self = typeEnum
    }
}
