//
//  HandEndRule.swift
//  CardKit
//
//  Created by Justin Weisz on 8/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: HandEndRule

public enum HandEndRule: String {
    case indeterminate
    case endWhenAllSatisfied
    case endWhenAnySatisfied
}

// MARK: JSONEncodable

extension HandEndRule: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .indeterminate:
            return .string("indeterminate")
        case .endWhenAllSatisfied:
            return .string("endWhenAllSatisfied")
        case .endWhenAnySatisfied:
            return .string("endWhenAnySatisfied")
        }
    }
}

// MARK: JSONDecodable

extension HandEndRule: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString()
        guard let typeEnum = HandEndRule(rawValue: type) else {
            throw JSON.Error.valueNotConvertible(value: json, to: HandEndRule.self)
        }
        self = typeEnum
    }
}
