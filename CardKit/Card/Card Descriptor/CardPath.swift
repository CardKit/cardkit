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
    
    /// Create a CardPath from a path string. Path strings are of the form "a/b/c" (e.g. "Input/Location").
    init(withPath path: String) {
        self.pathComponents = path.characters.split("/").map(String.init)
    }
}

//MARK: Equatable

extension CardPath: Equatable {}

public func == (lhs: CardPath, rhs: CardPath) -> Bool {
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
        return self.pathComponents.toJSON()
    }
}

//MARK: JSONDecodable

extension CardPath: JSONDecodable {
    public init(json: JSON) throws {
        self.pathComponents = try json.arrayOf(type: String.self)
    }
}
