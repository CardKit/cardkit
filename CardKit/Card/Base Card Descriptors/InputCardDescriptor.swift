//
//  InputCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: InputCardDescriptor

public struct InputCardDescriptor: CardDescriptor, ProducesInput, Codable {
    public let cardType: CardType = .input
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    // inputType is represented as a String here because swift4 cannot produce a
    // Type from a String. so we try to enforce some semblance of "type safety" by
    // requiring init() to take an InputType, but when we deserialize from JSON we
    // only get a String of the type name and must keep it as a string. this means
    // at runtime, it's theoretically possible to have a DataBinding of a 
    // mismatching type from what the descriptor expects.
    public let inputType: String
    public let inputDescription: String
    
    public init(name: String, subpath: String?, inputType: InputType, inputDescription: String, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Input/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Input")
        }
        self.assetCatalog = assetCatalog
        
        // remove the ".Type" suffix
        let type = String(describing: Swift.type(of: inputType))
        if type.hasSuffix(".Type") {
            let index = type.index(type.endIndex, offsetBy: -5)
            self.inputType = String(type[..<index])
        } else {
            self.inputType = type
        }
        
        self.inputDescription = inputDescription
    }
    
    /// Return a new InputCard instance using our descriptor
    public func makeCard() -> InputCard {
        return InputCard(with: self)
    }
}

// MARK: Equatable

extension InputCardDescriptor: Equatable {
    /// Card descriptors are equal when their names & paths are the same.
    /// All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: InputCardDescriptor, rhs: InputCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension InputCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension InputCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}
