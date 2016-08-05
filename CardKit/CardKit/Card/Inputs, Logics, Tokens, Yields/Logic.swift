//
//  Logic.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


//MARK: LogicType

public enum LogicType: String {
    /// Branch to another hand.
    case Branch
    
    /// Repeat executing the hand.
    case Repeat
    
    /// Perform a boolean AND to determine whether this card is satisfied.
    case BooleanLogicAnd
    
    /// Perform a boolean OR to determine whether this card is satisfied.
    case BooleanLogicOr
    
    /// Perform a boolean NOT to determine whether this card is satisfied.
    case BooleanLogicNot
}

//MARK: CustomStringConvertable

extension LogicType: CustomStringConvertible {
    public var description: String {
        return "\(self)"
    }
}

//MARK: JSONEncodable

extension LogicType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Branch:
            return .String("Branch")
        case .Repeat:
            return .String("Repeat")
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

extension LogicType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = LogicType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: LogicType.self)
        }
        self = typeEnum
    }
}
