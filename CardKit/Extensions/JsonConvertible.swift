//
//  JsonConvertible.swift
//  MonitorTwo
//
//  Created by Justin Weisz on 6/30/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//public protocol JsonConvertible {
//    func toJson() -> NSData
//    func fromJson(data: NSData) -> [String : AnyObject]?
//}
//
//extension DictionaryConvertible {
//    func toJson() -> NSData? {
//        let dict = self.toDictionary()
//        do {
//            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
//            return jsonData
//        } catch let error as NSError {
//            print("error: could not serialize data to JSON: \(error), \(error.userInfo)")
//        }
//        return nil
//    }
//    
//    func fromJson(data: NSData) -> [String : AnyObject]? {
//        do {
//            let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0))
//            return dict as? [String : AnyObject]
//        } catch let error as NSError {
//            print("error: could not deserialize from JSON data: \(error), \(error.userInfo)")
//        }
//        return nil
//    }
//}


/*
public func serializeBestEffort(value : Any) -> AnyObject {
    return value is JsonSerializable ? (value as! JsonSerializable).toSerializable() : String(value)
}

public func serializeBestEffortArray<T>(array : [T]) -> [AnyObject] {
    var list = [AnyObject]()
    
    for element in array {
        if element is JsonSerializable {
            list.append((element as! JsonSerializable).toSerializable())
        }
        else {
            list.append(String(element))
        }
    }
    
    return list
}

public func deserializeBestEffort(type: Any.Type, serialized: AnyObject) -> Any {
    let parsable = type as? JsonParsable.Type
    return parsable == nil ? serialized : parsable!.fromSerializable(serialized)
}

*/