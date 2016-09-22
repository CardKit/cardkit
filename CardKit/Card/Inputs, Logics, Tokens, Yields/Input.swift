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
    
    // used for anything that is not a swift primitive
    // (e.g. a struct or a class that implements JSONEncodable)
    case jsonObject
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
        case .jsonObject:
            return .string("jsonObject")
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
    case jsonObject(JSON)
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
            case .jsonObject(let val):
                return "\(val) [jsonObject]"
            }
        }
    }
}

// MARK: JSONEncodable

extension InputDataBinding: JSONEncodable {
    // swiftlint:disable:next function_body_length
    public func toJSON() -> JSON {
        let unbound: JSON = .dictionary(["type": InputDataBinding.unbound.description.toJSON()])
        
        switch self {
        case .unbound:
            return unbound
        case .swiftInt(let val):
            return .dictionary([
                "type": InputType.swiftInt.rawValue.toJSON(),
                "value": val.toJSON()])
        case .swiftDouble(let val):
            return .dictionary([
                "type": InputType.swiftDouble.rawValue.toJSON(),
                "value": val.toJSON()])
        case .swiftString(let val):
            return .dictionary([
                "type": InputType.swiftString.rawValue.toJSON(),
                "value": val.toJSON()])
        case .swiftData(let val):
            let base64 = val.base64EncodedString()
            return .dictionary([
                "type": InputType.swiftData.rawValue.toJSON(),
                "value": base64.toJSON()])
        case .swiftDate(let val):
            return .dictionary([
                "type": InputType.swiftDate.rawValue.toJSON(),
                "value": val.gmtTimeString.toJSON()])
        case .jsonObject(let val):
            return .dictionary([
                "type": InputType.jsonObject.rawValue.toJSON(),
                "value": val])
        }
    }
}

// MARK: JSONDecodable

extension InputDataBinding: JSONDecodable {
    //swiftlint:disable:next function_body_length
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        if type == InputDataBinding.unbound.description {
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
            if let data = Data(base64Encoded: value) {
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
        case .jsonObject:
            self = .jsonObject(json)
        }
    }
}
