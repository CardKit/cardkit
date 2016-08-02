//
//  HandIdentifier.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

/// Hand identifiers are used to uniquely identify hands for branching purposes.
public struct HandIdentifier {
    public let identifier: String
    
    init() {
        identifier = NSUUID().UUIDString
    }
    
    init(with identifier: String) {
        self.identifier = identifier
    }
}

//MARK: JSONDecodable

extension HandIdentifier: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.string()
    }
}

//MARK: JSONEncodable

extension HandIdentifier: JSONEncodable {
    public func toJSON() -> JSON {
        return self.identifier.toJSON()
    }
}
