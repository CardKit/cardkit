//
//  CardPath.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct CardPath {
    private let pathComponents: [String]
    
    /// Create a CardPath from a path string. Path strings are of the form
    /// "a/b/c" (e.g. "Input/Location").
    init(withPath path: String) {
        self.pathComponents = path.characters.split("/").map(String.init)
    }
}

//MARK: Equatable

extension CardPath: Equatable {}

public func ==(lhs: CardPath, rhs: CardPath) -> Bool {
    if lhs.pathComponents.count != rhs.pathComponents.count { return false }
    for i in 0..<lhs.pathComponents.count {
        if lhs.pathComponents[i] != rhs.pathComponents[i] {
            return false
        }
    }
    return true
}

//MARK: Hashable

extension CardPath: Hashable {
    public var hashValue: Int {
        get {
            // sum up the hash values of all the components
            return self.pathComponents.reduce(0, combine: { $0 &+ $1.hashValue })
        }
    }
}

//MARK: CustomStringConvertible

extension CardPath: CustomStringConvertible {
    public var description: String {
        get {
            return self.pathComponents.joinWithSeparator("/")
        }
    }
}

//MARK: JSONEncodable

extension CardPath: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "path": self.pathComponents.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension CardPath: JSONDecodable {
    public init(json: JSON) throws {
        self.pathComponents = try json.arrayOf("path", type: String.self)
    }
}




//MARK:- DictionaryConvertible

//extension CardPath: DictionaryConvertible {
//    init?(from dictionary: [String : AnyObject]) {
//        guard let path = dictionary["path"] as? String else { return nil }
//        self.init(withPath: path)
//    }
//    
//    public func toDictionary() -> [String : AnyObject] {
//        var dict: [String : AnyObject] = [:]
//        dict["path"] = self.description
//        return dict
//    }
//}

/*
public class CardPath : JsonSerializable, CustomStringConvertible, Hashable, Equatable  {
    private let parent  : CardPath?
    private let label    : String
    
    public static let Root :  CardPath = CardPath(label: "")
    
    private init (label: String) {
        parent = nil
        self.label = label
    }
    
    public init (parent: CardPath, label: String) {
        self.parent = parent
        self.label = label
    }
    
    public var hashValue: Int {
        get {
            return label.hashValue &+ (parent == nil ? 0 : parent!.hashValue)
        }
    }
    
    public var description : String {
        get {
            var string : String = label
            
            var element : CardPath? = parent
            while let uwElement = element  {
                string = uwElement.label + "/" + string
                element = uwElement.parent
            }
            
            return string
        }
    }
    
    public func toSerializable() -> AnyObject {
        var pathList = [String]()
        
        pathList.append(label)
        
        var element : CardPath? = parent
        while let uwElement = element  {
            if !uwElement.label.isEmpty {
                pathList.insert(uwElement.label, atIndex: 0)
            }
            
            element = uwElement.parent
        }
        
        return pathList
    }
}


public func == (left : CardPath, right : CardPath) -> Bool {
    if left.label != right.label {
        return false
    }
    
    if left.parent === right.parent {
        return true
    }
    
    if (left.parent == nil) != (right.parent == nil) {
        return false
    }
    
    return left.parent! == right.parent!
}

public func != (left : CardPath, right : CardPath) -> Bool {
    return !(left == right)
}
*/
