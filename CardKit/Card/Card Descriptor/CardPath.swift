//
//  CardPath.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public struct CardPath: Codable {
    fileprivate let pathComponents: [String]
    
    /// Create a CardPath from a path string. Path strings are of the form "a/b/c" (e.g. "Input/Location").
    init(withPath path: String) {
        self.pathComponents = path.split(separator: "/").map(String.init)
    }
}

// MARK: Equatable

extension CardPath: Equatable {
    static public func == (lhs: CardPath, rhs: CardPath) -> Bool {
        if lhs.pathComponents.count != rhs.pathComponents.count { return false }
        for i in 0..<lhs.pathComponents.count {
            if lhs.pathComponents[i] != rhs.pathComponents[i] {
                return false
            }
        }
        return true
    }
}

// MARK: Hashable

extension CardPath: Hashable {
    public var hashValue: Int {
        // sum up the hash values of all the components
        return self.pathComponents.reduce(0, { $0 &+ $1.hashValue })
    }
}

// MARK: CustomStringConvertible

extension CardPath: CustomStringConvertible {
    public var description: String {
        return self.pathComponents.joined(separator: "/")
    }
}
