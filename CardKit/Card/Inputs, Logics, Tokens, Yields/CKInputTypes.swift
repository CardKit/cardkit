//
//  CKInputTypes.swift
//  CardKit
//
//  Created by ismails on 3/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Freddy

public enum CKBool: String, InputProtocol, EnumerableEnum, CustomStringConvertible, JSONEncodable, JSONDecodable {
    case ckTrue = "True"
    case ckFalse = "False"
    
    //static vars
    public static var defaultUnit: String? {
        return nil
    }
    
    public static var inputDetails: [InputDetails] {
        return [.choices(self.allValues.map { $0.rawValue })]
    }
    
    public static var allValues: [CKBool] {
        return [.ckTrue, .ckFalse]
    }
    
    //instances vars
    public var description: String {
        return self.rawValue
    }
    
    public var boolValue: Bool {
        switch self {
        case .ckTrue:
            return true
        case .ckFalse:
            return false
        }
    }
}

//public struct CKData: InputProtocol, JSONEncodable, JSONDecodable {
//    public var data: Data
//    
//    public init(json: JSON) throws {
//        self.data = try Data(json: json)
//    }
//    
//    public func toJSON() -> JSON {
//        return data.toJSON()
//    }
//
//    public static var defaultUnit: String? {
//        return nil
//    }
//
//    public static var inputType: InputSetting {
//        return .complex
//    }
//}
//
//public struct CKInt: InputProtocol, JSONEncodable, JSONDecodable {
//    public var value: Int
//    
//    public init(json: JSON) throws {
//        self.value = try Int(json: json)
//    }
//    
//    public func toJSON() -> JSON {
//        return value.toJSON()
//    }
//    
//    public static var defaultUnit: String? {
//        return nil
//    }
//    
//    public static var inputType: InputSetting {
//        return .simple
//    }
//}
//
//public struct CKDouble: InputProtocol, JSONEncodable, JSONDecodable {
//    public var value: Double
//    
//    public init(json: JSON) throws {
//        self.value = try Double(json: json)
//    }
//    
//    public func toJSON() -> JSON {
//        return value.toJSON()
//    }
//    
//    public static var defaultUnit: String? {
//        return nil
//    }
//    
//    public static var inputType: InputSetting {
//        return .simple
//    }
//}
//
//public struct CKString: InputProtocol, JSONEncodable, JSONDecodable {
//    public var value: String
//    
//    public init(json: JSON) throws {
//        self.value = try String(json: json)
//    }
//    
//    public func toJSON() -> JSON {
//        return value.toJSON()
//    }
//    
//    public static var defaultUnit: String? {
//        return nil
//    }
//    
//    public static var inputType: InputSetting {
//        return .simple
//    }
//}
