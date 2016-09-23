//
//  InputType.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: InputType

public typealias InputType = (JSONEncodable & JSONDecodable).Type


// MARK: - InputDataBinding

/// Represents a binding of a value to an Input
public enum InputDataBinding {
    case unbound
    case bound(JSON)
}

// MARK: CustomStringConvertable

extension InputDataBinding: CustomStringConvertible {
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

extension InputDataBinding: JSONEncodable {
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

extension InputDataBinding: JSONDecodable {
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
