//
//  HandEndRule.swift
//  CardKit
//
//  Created by Justin Weisz on 8/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: HandEndRule

public enum HandEndRule: String {
    case Indeterminate
    case EndWhenAllSatisfied
    case EndWhenAnySatisfied
}

//MARK: JSONEncodable

extension HandEndRule: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Indeterminate:
            return .String("Indeterminate")
        case .EndWhenAllSatisfied:
            return .String("EndWhenAllSatisfied")
        case .EndWhenAnySatisfied:
            return .String("EndWhenAnySatisfied")
        }
    }
}

//MARK: JSONDecodable

extension HandEndRule: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = HandEndRule(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: HandEndRule.self)
        }
        self = typeEnum
    }
}
