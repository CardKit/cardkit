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

/// Represents the type of an Input
public enum InputType: String {
    // swift primitives
    case swiftInt
    case swiftDouble
    case swiftString
    case swiftData
    case swiftDate
    
    // coordinates
    case coordinate2D
    case coordinate2DPath
    case coordinate3D
    case coordinate3DPath
    
    // direction
    case cardinalDirection
}

// MARK: JSONEncodable

extension InputType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .swiftInt:
            return .string("swiftInt")
        case .swiftDouble:
            return .string("swiftDouble")
        case .swiftString:
            return .string("swiftString")
        case .swiftData:
            return .string("swiftData")
        case .swiftDate:
            return .string("swiftDate")
        case .coordinate2D:
            return .string("coordinate2D")
        case .coordinate2DPath:
            return .string("coordinate2DPath")
        case .coordinate3D:
            return .string("coordinate3D")
        case .coordinate3DPath:
            return .string("coordinate3DPath")
        case .cardinalDirection:
            return .string("cardinalDirection")
        }
    }
}

// MARK: JSONDecodable

extension InputType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString()
        guard let typeEnum = InputType(rawValue: type) else {
            throw JSON.Error.valueNotConvertible(value: json, to: InputType.self)
        }
        self = typeEnum
    }
}


// MARK: - InputDataBinding

/// Represents a binding of a value to an Input
public enum InputDataBinding {
    case unbound
    case swiftInt(Int)
    case swiftDouble(Double)
    case swiftString(String)
    case swiftData(Data)
    case swiftDate(Date)
    case coordinate2D(CKCoordinate2D)
    case coordinate2DPath([CKCoordinate2D])
    case coordinate3D(CKCoordinate3D)
    case coordinate3DPath([CKCoordinate3D])
    case cardinalDirection(CKCardinalDirection)
}

// MARK: CustomStringConvertable

extension InputDataBinding: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .unbound:
                return "unbound"
            case .swiftInt(let val):
                return "\(val) [int]"
            case .swiftDouble(let val):
                return "\(val) [double]"
            case .swiftString(let val):
                return "\(val) [string]"
            case .swiftData(let val):
                return "\(val.count) bytes [data]"
            case .swiftDate(let val):
                return "\(val) [date]"
            case .coordinate2D(let val):
                return "\(val) [coord2d]"
            case .coordinate2DPath(let val):
                return "\(val) [coord2dpath]"
            case .coordinate3D(let val):
                return "\(val) [coord3d]"
            case .coordinate3DPath(let val):
                return "\(val) [coord3dpath]"
            case .cardinalDirection(let val):
                return "\(val) [cardinal direction]"
            }
        }
    }
}

// MARK: JSONEncodable

extension InputDataBinding: JSONEncodable {
    // swiftlint:disable:next function_body_length
    public func toJSON() -> JSON {
        switch self {
        case .unbound:
            return .dictionary([
            "type": "unbound"])
        case .swiftInt(let val):
            return .dictionary([
                "type": "swiftInt",
                "value": val.toJSON()])
        case .swiftDouble(let val):
            return .dictionary([
                "type": "swiftDouble",
                "value": val.toJSON()])
        case .swiftString(let val):
            return .dictionary([
                "type": "swiftString",
                "value": val.toJSON()])
        case .swiftData(let val):
            let options = Data.Base64EncodingOptions(rawValue: 0)
            let base64 = val.base64EncodedString(options: options)
            return .dictionary([
                "type": "swiftData",
                "value": base64.toJSON()])
        case .swiftDate(let val):
            return .dictionary([
                "type": "swiftDate",
                "value": val.gmtTimeString.toJSON()])
        case .coordinate2D(let val):
            return .dictionary([
                "type": "coordinate2D",
                "value": val.toJSON()])
        case .coordinate2DPath(let val):
            return .dictionary([
                "type": "coordinate2DPath",
                "value": val.toJSON()])
        case .coordinate3D(let val):
            return .dictionary([
                "type": "coordinate3D",
                "value": val.toJSON()])
        case .coordinate3DPath(let val):
            return .dictionary([
                "type": "coordinate3DPath",
                "value": val.toJSON()])
        case .cardinalDirection(let val):
            return .dictionary([
                "type": "cardinalDirection",
                "value": val.toJSON()])
        }
    }
}

// MARK: JSONDecodable

extension InputDataBinding: JSONDecodable {
    //swiftlint:disable:next function_body_length
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        if type == "Unbound" {
            self = .unbound
            return
        }
        
        guard let typeEnum = InputType(rawValue: type) else {
            throw JSON.Error.valueNotConvertible(value: json, to: InputDataBinding.self)
        }
        
        switch typeEnum {
        case .swiftInt:
            let value = try json.getInt(at: "value")
            self = .swiftInt(value)
        case .swiftDouble:
            let value = try json.getDouble(at: "value")
            self = .swiftDouble(value)
        case .swiftString:
            let value = try json.getString(at: "value")
            self = .swiftString(value)
        case .swiftData:
            let value = try json.getString(at: "value")
            if let data = Data(base64Encoded: value, options: NSData.Base64DecodingOptions(rawValue: 0)) {
                self = .swiftData(data)
            } else {
                throw JSON.Error.valueNotConvertible(value: json, to: InputDataBinding.self)
            }
        case .swiftDate:
            let value = try json.getString(at: "value")
            if let date = Date.date(fromTimezoneFormattedString: value) {
                self = .swiftDate(date)
            } else {
                throw JSON.Error.valueNotConvertible(value: json, to: InputDataBinding.self)
            }
        case .coordinate2D:
            let value = try json.decode(at: "value", type: CKCoordinate2D.self)
            self = .coordinate2D(value)
        case .coordinate2DPath:
            let value = try json.decodedArray(at: "value", type: CKCoordinate2D.self)
            self = .coordinate2DPath(value)
        case .coordinate3D:
            let value = try json.decode(at: "value", type: CKCoordinate3D.self)
            self = .coordinate3D(value)
        case .coordinate3DPath:
            let value = try json.decodedArray(at: "value", type: CKCoordinate3D.self)
            self = .coordinate3DPath(value)
        case .cardinalDirection:
            let value = try json.decode(at: "value", type: CKCardinalDirection.self)
            self = .cardinalDirection(value)
        }
    }
}
