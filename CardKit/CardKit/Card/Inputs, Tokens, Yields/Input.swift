//
//  InputType.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: InputType

/// Represents the type of an Input
public enum InputType: String {
    // swift primitives
    case SwiftInt
    case SwiftDouble
    case SwiftString
    case SwiftData
    case SwiftDate
    
    // coordinates
    case Coordinate2D
    case Coordinate2DPath
    case Coordinate3D
    case Coordinate3DPath
    
    // direction
    case CardinalDirection
}

//MARK: CustomStringConvertable

extension InputType: CustomStringConvertible {
    public var description: String {
        get {
            return "\(self)"
        }
    }
}

//MARK: JSONEncodable

extension InputType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .SwiftInt:
            return .String("SwiftInt")
        case .SwiftDouble:
            return .String("SwiftDouble")
        case .SwiftString:
            return .String("SwiftString")
        case .SwiftData:
            return .String("SwiftData")
        case .SwiftDate:
            return .String("SwiftDate")
        case .Coordinate2D:
            return .String("Coordinate2D")
        case .Coordinate2DPath:
            return .String("Coordinate2DPath")
        case .Coordinate3D:
            return .String("Coordinate3D")
        case .Coordinate3DPath:
            return .String("Coordinate3DPath")
        case .CardinalDirection:
            return .String("CardinalDirection")
        }
    }
}

//MARK: JSONDecodable

extension InputType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = InputType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: InputType.self)
        }
        self = typeEnum
    }
}


//MARK:- InputBinding

/// Represents a binding of a value to an Input
public enum InputBinding {
    case SwiftInt(Int)
    case SwiftDouble(Double)
    case SwiftString(String)
    case SwiftData(NSData)
    case SwiftDate(NSDate)
    case Coordinate2D(InputCoordinate2D)
    case Coordinate2DPath([InputCoordinate2D])
    case Coordinate3D(InputCoordinate3D)
    case Coordinate3DPath([InputCoordinate3D])
    case CardinalDirection(InputCardinalDirection)
}

//MARK: CustomStringConvertable

extension InputBinding: CustomStringConvertible {
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
            case .SwiftDate(let val):
                return "\(val) [date]"
            case .Coordinate2D(let val):
                return "\(val) [coord2d]"
            case .Coordinate2DPath(let val):
                return "\(val) [coord2dpath]"
            case .Coordinate3D(let val):
                return "\(val) [coord3d]"
            case .Coordinate3DPath(let val):
                return "\(val) [coord3dpath]"
            case .CardinalDirection(let val):
                return "\(val) [cardinal direction]"
            }
        }
    }
}

//MARK: JSONEncodable

extension InputBinding: JSONEncodable {
    // swiftlint:disable:next function_body_length
    public func toJSON() -> JSON {
        switch self {
        case .SwiftInt(let val):
            return .Dictionary([
                "type": "SwiftInt",
                "value": val.toJSON()])
        case .SwiftDouble(let val):
            return .Dictionary([
                "type": "SwiftDouble",
                "value": val.toJSON()])
        case .SwiftString(let val):
            return .Dictionary([
                "type": "SwiftString",
                "value": val.toJSON()])
        case .SwiftData(let val):
            let options = NSDataBase64EncodingOptions(rawValue: 0)
            let base64 = val.base64EncodedStringWithOptions(options)
            return .Dictionary([
                "type": "SwiftData",
                "value": base64.toJSON()])
        case .SwiftDate(let val):
            return .Dictionary([
                "type": "SwiftDate",
                "value": val.gmtTimeString.toJSON()])
        case .Coordinate2D(let val):
            return .Dictionary([
                "type": "InputCoordinate2D",
                "value": val.toJSON()])
        case .Coordinate2DPath(let val):
            return .Dictionary([
                "type": "InputCoordinate2DPath",
                "value": val.toJSON()])
        case .Coordinate3D(let val):
            return .Dictionary([
                "type": "InputCoordinate3D",
                "value": val.toJSON()])
        case .Coordinate3DPath(let val):
            return .Dictionary([
                "type": "InputCoordinate3DPath",
                "value": val.toJSON()])
        case .CardinalDirection(let val):
            return .Dictionary([
                "type": "InputCardinalDirection",
                "value": val.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension InputBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        guard let typeEnum = InputType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: InputBinding.self)
        }
        
        switch typeEnum {
        case .SwiftInt:
            let value = try json.int("value")
            self = .SwiftInt(value)
        case .SwiftDouble:
            let value = try json.double("value")
            self = .SwiftDouble(value)
        case .SwiftString:
            let value = try json.string("value")
            self = .SwiftString(value)
        case .SwiftData:
            let value = try json.string("value")
            if let data = NSData(base64EncodedString: value, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                self = .SwiftData(data)
            } else {
                throw JSON.Error.ValueNotConvertible(value: json, to: InputBinding.self)
            }
        case .SwiftDate:
            let value = try json.string("value")
            if let date = NSDate.date(fromTimezoneFormattedString: value) {
                self = .SwiftDate(date)
            } else {
                throw JSON.Error.ValueNotConvertible(value: json, to: InputBinding.self)
            }
        case .Coordinate2D:
            let value = try json.decode("value", type: InputCoordinate2D.self)
            self = .Coordinate2D(value)
        case .Coordinate2DPath:
            let value = try json.arrayOf("value", type: InputCoordinate2D.self)
            self = .Coordinate2DPath(value)
        case .Coordinate3D:
            let value = try json.decode("value", type: InputCoordinate3D.self)
            self = .Coordinate3D(value)
        case .Coordinate3DPath:
            let value = try json.arrayOf("value", type: InputCoordinate3D.self)
            self = .Coordinate3DPath(value)
        case .CardinalDirection:
            let value = try json.decode("value", type: InputCardinalDirection.self)
            self = .CardinalDirection(value)
        }
    }
}
