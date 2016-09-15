//
//  Yield.swift
//  CardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: YieldType
public typealias YieldType = InputType

// MARK: YieldIdentifier
public typealias YieldIdentifier = UUID

// MARK: - Yield

public struct Yield {
    public var identifier: YieldIdentifier
    
    // in the future, this should be Any.Type. however, right now there is no way
    // to take a String and figure out the Swift struct type that corresponds to
    // that String (e.g. "Dictionary<Int, Int>" -> Dictionary<Int, Int>), which
    // means that we need to box & unbox the type
    public var type: YieldType
    
    init(type: YieldType) {
        self.identifier = UUID()
        self.type = type
    }
}

// MARK: Equatable

extension Yield: Equatable {}

public func == (lhs: Yield, rhs: Yield) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    equal = equal && lhs.type == rhs.type
    return equal
}

// MARK: Hashable

extension Yield: Hashable {
    public var hashValue: Int {
        return "\(self.identifier).\(self.type)".hashValue
    }
}

// MARK: CustomStringConvertible

extension Yield: CustomStringConvertible {
    public var description: String {
        return "\(self.identifier) [\(self.type)]"
    }
}

// MARK: JSONEncodable

extension Yield: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.uuidString.toJSON(),
            "type": String(describing: self.type).toJSON()])
    }
}

// MARK: JSONDecodable

extension Yield: JSONDecodable {
    public init(json: JSON) throws {
        let uuidStr = try json.getString(at: "identifier")
        guard let uuid = UUID(uuidString: uuidStr) else {
            throw JSON.Error.valueNotConvertible(value: json, to: Yield.self)
        }
        self.identifier = uuid
        self.type = try json.decode(at: "type", type: YieldType.self)
    }
}
