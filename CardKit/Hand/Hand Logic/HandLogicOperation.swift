//
//  HandLogicOperation.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: HandLogicOperation.swift

public enum HandLogicOperation: String {
    case Indeterminate
    case BooleanAnd
    case BooleanOr
    case BooleanNot
}

//MARK: JSONEncodable

extension HandLogicOperation: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Indeterminate:
            return .String("Indeterminate")
        case .BooleanAnd:
            return .String("BooleanAnd")
        case .BooleanOr:
            return .String("BooleanOr")
        case .BooleanNot:
            return .String("BooleanNot")
        }
    }
}

//MARK: JSONDecodable

extension HandLogicOperation: JSONDecodable {
    public init(json: JSON) throws {
        let operation = try json.string()
        guard let operationEnum = HandLogicOperation(rawValue: operation) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: HandLogicOperation.self)
        }
        self = operationEnum
    }
}
