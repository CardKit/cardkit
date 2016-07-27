//
//  InputParameter.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public enum InputParameter {
    case SwiftInt(Int)
    case SwiftDouble(Double)
    case SwiftString(String)
    case Coordinate2D(CKCoordinate2D)
    case Coordinate2DPath([CKCoordinate2D])
    case Coordinate3D(CKCoordinate3D)
    case Coordinate3DPath([CKCoordinate3D])
}

//MARK: CustomStringConvertable

extension InputParameter: CustomStringConvertible {
    public var description: String {
        get {
            return "\(self)"
        }
    }
}

//MARK: JSONEncodable

extension InputParameter: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .SwiftInt(let val):
            return .Dictionary([
                "type": "Int",
                "value": val.toJSON()])
        case .SwiftDouble(let val):
            return .Dictionary([
                "type": "Double",
                "value": val.toJSON()])
        case .SwiftString(let val):
            return .Dictionary([
                "type": "String",
                "value": val.toJSON()])
        case .Coordinate2D(let val):
            return .Dictionary([
                "type": "CKCoordinate2D",
                "value": val.toJSON()])
        case .Coordinate2DPath(let val):
            return .Dictionary([
                "type": "CKCoordinate2DPath",
                "value": val.toJSON()])
        case .Coordinate3D(let val):
            return .Dictionary([
                "type": "CKCoordinate3D",
                "value": val.toJSON()])
        case .Coordinate3DPath(let val):
            return .Dictionary([
                "type": "CKCoordinate3DPath",
                "value": val.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension InputParameter: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        switch type {
        case "Int":
            let value = try json.int("value")
            self = .SwiftInt(value)
        case "Double":
            let value = try json.double("value")
            self = .SwiftDouble(value)
        case "String":
            let value = try json.string("value")
            self = .SwiftString(value)
        case "CKCoordinate2D":
            let value = try json.decode("value", type: CKCoordinate2D.self)
            self = .Coordinate2D(value)
        case "CKCoordinate2DPath":
            let value = try json.arrayOf("value", type: CKCoordinate2D.self)
            self = .Coordinate2DPath(value)
        case "CKCoordinate3D":
            let value = try json.decode("value", type: CKCoordinate3D.self)
            self = .Coordinate3D(value)
        case "CKCoordinate3DPath":
            let value = try json.arrayOf("value", type: CKCoordinate3D.self)
            self = .Coordinate3DPath(value)
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: InputParameter.self)
        }
    }
}
