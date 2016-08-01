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
    
    public let inputs: [InputCardSlot]
    public let tokens: [TokenCardSlot]
    
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
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, inputs: [InputCardSlot]?, tokens: [TokenCardSlot]?, yields: [Yield]?, yieldDescription: String?, ends: Bool, endsDescription: String, version: Int = 0) {
        let p = "Action/\(subpath)" ?? "Action"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        self.inputs = inputs ?? []
        self.tokens = tokens ?? []
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
            "inputs": inputs.toJSON(),
            "tokens": tokens.toJSON(),
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
        self.inputs = try json.arrayOf("inputs", type: InputCardSlot.self)
        self.tokens = try json.arrayOf("tokens", type: TokenCardSlot.self)
        self.yields = try json.arrayOf("yields", type: Yield.self)
        self.yieldDescription = try json.string("yieldDescription")
        self.ends = try json.bool("ends")
        self.endDescription = try json.string("endDescription")
    }
}


//MARK: Dictionary
/*
extension Dictionary where Key: StringLiteralConvertible {
    func withDecodedValues<T where T: JSONDecodable>() throws -> [String : T] {
        var dict: [String : T] = [:]
        for (k, v) in self {
            //swiftlint:disable:next conditional_binding_cascade
            if let stringKey = k as? String, let jsonVal = v as? JSON {
                let obj = try T(json: jsonVal)
                dict[stringKey] = obj
            }
        }
        return dict
    }
}
*/