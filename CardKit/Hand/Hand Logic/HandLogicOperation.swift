//
//  HandLogicOperation.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: HandLogicOperation.swift

public enum HandLogicOperation: String {
    case indeterminate
    case booleanAnd
    case booleanOr
    case booleanNot
}

// MARK: JSONEncodable

extension HandLogicOperation: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .indeterminate:
            return .string("indeterminate")
        case .booleanAnd:
            return .string("booleanAnd")
        case .booleanOr:
            return .string("booleanOr")
        case .booleanNot:
            return .string("booleanNot")
        }
    }
}

// MARK: JSONDecodable

extension HandLogicOperation: JSONDecodable {
    public init(json: JSON) throws {
        let operation = try json.getString()
        guard let operationEnum = HandLogicOperation(rawValue: operation) else {
            throw JSON.Error.valueNotConvertible(value: json, to: HandLogicOperation.self)
        }
        self = operationEnum
    }
}
