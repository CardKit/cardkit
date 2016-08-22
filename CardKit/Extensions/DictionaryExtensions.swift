//
//  DictionaryExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

extension Dictionary where Key: StringLiteralConvertible {
    func withDecodedKeysAndValues<KeyType: JSONDecodable, ValueType: JSONDecodable>() throws -> [KeyType : ValueType] {
        var dict: [KeyType : ValueType] = [:]
        for (k, v) in self {
            if let jsonKey = k as? JSON, let jsonVal = v as? JSON {
                let objKey = try KeyType(json: jsonKey)
                let objVal = try ValueType(json: jsonVal)
                dict[objKey] = objVal
            }
        }
        return dict
    }
    
    func withDecodedValues<T where T: JSONDecodable>() throws -> [String : T] {
        var dict: [String : T] = [:]
        for (k, v) in self {
            if let stringKey = k as? String, let jsonVal = v as? JSON {
                let obj = try T(json: jsonVal)
                dict[stringKey] = obj
            }
        }
        return dict
    }
}
