//
//  DataBinding.swift
//  CardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import Freddy

/// Represents a binding of a value to an Input or a Yield. This is functionally
/// the same as just using the optional type `JSON?`. However, for future
/// exensibility (in case we want to dump JSON in favor of something else), we keep
/// this as an explicit type.
public enum DataBinding {
    case unbound
    case bound(JSON)
}

// MARK: CustomStringConvertable

extension DataBinding: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unbound:
            return "unbound"
        case .bound(_):
            return "bound"
        }
    }
}

// MARK: JSONEncodable

extension DataBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .unbound:
            return .dictionary([
                "type": "unbound"
                ])
        case .bound(let val):
            return .dictionary([
                "type": "bound",
                "value": val])
        }
    }
}

// MARK: JSONDecodable

extension DataBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "unbound":
            self = .unbound
        case "bound":
            if let value = json["value"] {
                self = .bound(value)
            } else {
                self = .unbound
            }
        default:
            self = .unbound
        }
    }
}
