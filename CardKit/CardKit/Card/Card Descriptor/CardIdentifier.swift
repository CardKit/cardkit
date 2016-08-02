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
    public let name: String
    public let path: CardPath
    public let version: Int
    
    public init(name: String, path: String, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: path)
        self.version = version
    }
    
    public init(name: String, path: CardPath, version: Int = 0) {
        self.name = name
        self.path = path
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

public func == (lhs: CardIdentifier, rhs: CardIdentifier) -> Bool {
    return lhs.name == rhs.name && lhs.path == rhs.path && lhs.version == rhs.version
}

public func != (lhs: CardIdentifier, rhs: CardIdentifier) -> Bool {
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
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
    }
}
