//
//  Yield.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: YieldIdentifier
public typealias YieldIdentifier = NSUUID

//MARK:- Yield

public struct Yield {
    public var identifier: YieldIdentifier
    
    // in the future, this should be Any.Type. however, right now there is no way
    // to take a String and figure out the Swift struct type that corresponds to
    // that String (e.g. "Dictionary<Int, Int>" -> Dictionary<Int, Int>), which
    // means that we need to box & unbox the type
    public var type: YieldType
    
    init(type: YieldType) {
        self.identifier = NSUUID()
        self.type = type
    }
}

//MARK: Equatable

extension Yield: Equatable {}

public func == (lhs: Yield, rhs: Yield) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.type == rhs.type
    return equal
}

//MARK: Hashable

extension Yield: Hashable {
    public var hashValue: Int {
        return "\(self.identifier).\(self.type)".hashValue
    }
}

//MARK: JSONEncodable

extension Yield: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.UUIDString.toJSON(),
            "type": String(self.type).toJSON()])
    }
}

//MARK: JSONDecodable

extension Yield: JSONDecodable {
    public init(json: JSON) throws {
        let uuidStr = try json.string("identifier")
        guard let uuid = NSUUID(UUIDString: uuidStr) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: Yield.self)
        }
        self.identifier = uuid
        self.type = try json.decode("type", type: YieldType.self)
    }
}

//MARK:- YieldType

/// Represents the type of a Yield
public enum YieldType: String {
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

extension YieldType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = YieldType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
        }
        self = typeEnum
    }
}


//MARK:- YieldBinding

/// Represents a binding of a value to a Yield
public enum YieldBinding {
    case SwiftInt(Int)
    case SwiftDouble(Double)
    case SwiftString(String)
    case SwiftData(NSData)
    case SwiftDate(NSDate)
    case Coordinate2D(YieldCoordinate2D)
    case Coordinate2DPath([YieldCoordinate2D])
    case Coordinate3D(YieldCoordinate3D)
    case Coordinate3DPath([YieldCoordinate3D])
    case CardinalDirection(YieldCardinalDirection)
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

extension YieldBinding: JSONEncodable {
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
            let base64 = val.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            return .Dictionary([
                "type": "SwiftData",
                "value": base64.toJSON()])
        case .SwiftDate(let val):
            return .Dictionary([
                "type": "SwiftDate",
                "value": val.gmtTimeString.toJSON()])
        case .Coordinate2D(let val):
            return .Dictionary([
                "type": "YieldCoordinate2D",
                "value": val.toJSON()])
        case .Coordinate2DPath(let val):
            return .Dictionary([
                "type": "YieldCoordinate2DPath",
                "value": val.toJSON()])
        case .Coordinate3D(let val):
            return .Dictionary([
                "type": "YieldCoordinate3D",
                "value": val.toJSON()])
        case .Coordinate3DPath(let val):
            return .Dictionary([
                "type": "YieldCoordinate3DPath",
                "value": val.toJSON()])
        case .CardinalDirection(let val):
            return .Dictionary([
                "type": "YieldCardinalDirection",
                "value": val.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension YieldBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        guard let typeEnum = YieldType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
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
                throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
            }
        case .SwiftDate:
            let value = try json.string("value")
            if let date = NSDate.date(fromTimezoneFormattedString: value) {
                self = .SwiftDate(date)
            } else {
                throw JSON.Error.ValueNotConvertible(value: json, to: YieldBinding.self)
            }
        case .Coordinate2D:
            let value = try json.decode("value", type: YieldCoordinate2D.self)
            self = .Coordinate2D(value)
        case .Coordinate2DPath:
            let value = try json.arrayOf("value", type: YieldCoordinate2D.self)
            self = .Coordinate2DPath(value)
        case .Coordinate3D:
            let value = try json.decode("value", type: YieldCoordinate3D.self)
            self = .Coordinate3D(value)
        case .Coordinate3DPath:
            let value = try json.arrayOf("value", type: YieldCoordinate3D.self)
            self = .Coordinate3DPath(value)
        case .CardinalDirection:
            let value = try json.decode("value", type: YieldCardinalDirection.self)
            self = .CardinalDirection(value)
        }
    }
}

