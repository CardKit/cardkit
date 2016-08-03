//
//  ActionCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct ActionCardDescriptor: CardDescriptor, AcceptsInputs, AcceptsTokens, ProducesYields, Satisfiable {
    public let type: CardType = .Action
    public let name: String
    public let path: CardPath
    public let version: Int
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let inputSlots: [InputSlot]
    public let tokenSlots: [TokenSlot]
    
    public var producesYields: Bool {
        get {
            return yields.count > 0
        }
    }
    public let yields: [Yield]
    public let yieldDescription: String
    
    public let ends: Bool
    public let endDescription: String
    
    public let cardType: CardType = .Action
    
    //swiftlint:disable:next function_parameter_count
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, inputs: [InputSlot]?, tokens: [TokenSlot]?, yields: [Yield]?, yieldDescription: String?, ends: Bool, endsDescription: String, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: "Action/\(subpath)" ?? "Action")
        self.version = version
        self.description = description
        self.assetCatalog = assetCatalog
        
        self.inputSlots = inputs ?? []
        self.tokenSlots = tokens ?? []
        self.yields = yields ?? []
        self.yieldDescription = yieldDescription ?? ""
        self.ends = ends
        self.endDescription = endsDescription
    }
}

//MARK: Equatable

extension ActionCardDescriptor: Equatable {}

/// Card descriptors are equal when their names, paths, and versions are the same. All the other metadata should be the same when two descriptors have the same name, path, & version.
public func == (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.path == rhs.path
    equal = equal && lhs.version == rhs.version
    return equal
}

//MARK: Hashable

extension ActionCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3) &+ (version.hashValue &* 5)
    }
}

//MARK: JSONEncodable

extension ActionCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "type": type.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "version": version.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "inputSlots": inputSlots.toJSON(),
            "tokenSlots": tokenSlots.toJSON(),
            "yields": yields.toJSON(),
            "yieldDescription": yieldDescription.toJSON(),
            "ends": ends.toJSON(),
            "endDescription": endDescription.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension ActionCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.inputSlots = try json.arrayOf("inputSlots", type: InputSlot.self)
        self.tokenSlots = try json.arrayOf("tokenSlots", type: TokenSlot.self)
        self.yields = try json.arrayOf("yields", type: Yield.self)
        self.yieldDescription = try json.string("yieldDescription")
        self.ends = try json.bool("ends")
        self.endDescription = try json.string("endDescription")
    }
}
