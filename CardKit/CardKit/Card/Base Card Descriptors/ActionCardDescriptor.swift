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
    public let identifier: CardIdentifier
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
        let p = "Action/\(subpath)" ?? "Action"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
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

public func == (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    // TODO: need to test other fields here?
    return equal
}

//MARK: Hashable

extension ActionCardDescriptor: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONEncodable

extension ActionCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "inputSlots": inputSlots.toJSON(),
            "tokenSlots": tokenSlots.toJSON(),
            "yields": yields.toJSON(),
            "yieldDescription": yieldDescription.toJSON(),
            "ends": ends.toJSON(),
            "endDescription": endDescription.toJSON(),
            "cardType": cardType.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension ActionCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
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
