//
//  CardIdentifier.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct CardIdentifier {
    public let path: CardPath
    public let name: String
    public let version: Int
    
    public init(path: String, name: String, version: Int = 0) {
        self.path = CardPath(withPath: path)
        self.name = name
        self.version = version
    }
    
    public init(path: CardPath, name: String, version: Int = 0) {
        self.path = path
        self.name = name
        self.version = version
    }
}

//MARK: Hashable

extension CardIdentifier: Hashable {
    public var hashValue: Int {
        get {
            let pathH: Int = path.hashValue
            let nameH: Int = name.hashValue
            let versionH: Int = version.hashValue
            return pathH &+ (nameH &* 3) &+ (versionH &* 5)
        }
    }
}

//MARK: Equatable

extension CardIdentifier: Equatable {}

public func ==(lhs: CardIdentifier, rhs: CardIdentifier) -> Bool {
    return lhs.name == rhs.name && lhs.path == rhs.path && lhs.version == rhs.version
}

public func !=(lhs: CardIdentifier, rhs: CardIdentifier) -> Bool {
//    return !(lhs.name == rhs.name)
    return !(lhs == rhs)
}

//MARK: JSONEncodable

extension CardIdentifier: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "path": path.toJSON(),
            "name": .String(name),
            "version": .Int(version)
            ])
    }
}

//MARK: JSONDecodable

extension CardIdentifier: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.decode("path", type: CardPath.self)
        self.name = try json.string("name")
        self.version = try json.int("version")
    }
}




//MARK:- DictionaryConvertible

//extension CardIdentifier: DictionaryConvertible {
//    public init?(from dictionary: [String : AnyObject]) {
//        guard let path = dictionary["path"] as? String else { return nil }
//        guard let name = dictionary["name"] as? String else { return nil }
//        guard let version = dictionary["version"] as? Int else { return nil }
//        
//        self.path = CardPath(withPath: path)
//        self.name = name
//        self.version = version
//    }
//    
//    public func toDictionary() -> [String : AnyObject] {
//        var dict: [String : AnyObject] = [:]
//        dict["name"] = name
//        dict["path"] = path.toDictionary()
//        dict["version"] = version
//        return dict
//    }
//}
