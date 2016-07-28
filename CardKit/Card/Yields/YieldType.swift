//
//  InputParameter.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: YieldType

/// Represents the type of an InputParameter
public enum YieldType: String {
    case SwiftInt
    case SwiftDouble
    case SwiftString
    case SwiftData
    case Coordinate2D
    case Coordinate2DPath
    case Coordinate3D
    case Coordinate3DPath
}

//MARK: CustomStringConvertable

extension YieldType: CustomStringConvertible {
    public var description: String {
        get {
            return "\(self)"
        }
    }
}

//MARK: JSONEncodable

extension YieldType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .SwiftInt:
            return .String("Int")
        case .SwiftDouble:
            return .String("Double")
        case .SwiftString:
            return .String("String")
        case .SwiftData:
            return .String("Data")
        case .Coordinate2D:
            return .String("Coordinate2D")
        case .Coordinate2DPath:
            return .String("Coordinate2DPath")
        case .Coordinate3D:
            return .String("Coordinate3D")
        case .Coordinate3DPath:
            return .String("Coordinate3DPath")
        }
    }
}

//MARK: JSONDecodable

extension YieldType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        switch type {
        case "Int":
            self = .SwiftInt
        case "Double":
            self = .SwiftDouble
        case "String":
            self = .SwiftString
        case "Data":
            self = .SwiftData
        case "CKCoordinate2D":
            self = .Coordinate2D
        case "CKCoordinate2DPath":
            self = .Coordinate2DPath
        case "CKCoordinate3D":
            self = .Coordinate3D
        case "CKCoordinate3DPath":
            self = .Coordinate3DPath
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: YieldType.self)
        }
    }
}


//MARK:- YieldBinding

/// Represents a binding of a value to a Yield
public enum YieldBinding {
    case SwiftInt(Int)
    case SwiftDouble(Double)
    case SwiftString(String)
    case SwiftData(NSData)
    case Coordinate2D(CKCoordinate2D)
    case Coordinate2DPath([CKCoordinate2D])
    case Coordinate3D(CKCoordinate3D)
    case Coordinate3DPath([CKCoordinate3D])
}

//MARK: CustomStringConvertable

extension YieldBinding: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .SwiftInt(let val):
                return "\(val) [int]"
            case .SwiftDouble(let val):
                return "\(val) [double]"
            case .SwiftString(let val):
                return "\(val) [string]"
            case .SwiftData(let val):
                return "\(val.length) bytes [data]"
            case .Coordinate2D(let val):
                return "\(val) [coord2d]"
            case .Coordinate2DPath(let val):
                return "\(val) [coord2dpath]"
            case .Coordinate3D(let val):
                return "\(val) [coord3d]"
            case .Coordinate3DPath(let val):
                return "\(val) [coord3dpath]"
            }
        }
    }
}

//MARK: JSONEncodable

extension YieldBinding: JSONEncodable {
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
        case .SwiftData(let val):
            let base64 = val.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            return .Dictionary([
                "type": "Data",
                "value": base64.toJSON()])
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

extension YieldBinding: JSONDecodable {
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
        case "Data":
            let value = try json.string("value")
            if let data = NSData(base64EncodedString: value, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                self = .SwiftData(data)
            } else {
                throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
            }
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
            throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
        }
    }
}
