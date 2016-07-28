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
    
    public let mandatoryInputs: CardInputs
    public let optionalInputs: CardInputs
    
    public let tokens: CardTokens
    
    public let producesYields: Bool
    public let yieldDescription: String
    public let yields: [YieldType]
    
    public let ends: Bool
    public let endDescription: String
    
    public var cardType: CardType {
        get {
            return .Action
        }
    }
    
    //swiftlint:disable:next function_parameter_count
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, mandatoryInputs: CardInputs?, optionalInputs: CardInputs?, tokens: CardTokens?, producesYields: Bool, yieldDescription: String?, yields: [YieldType]?, ends: Bool, endsDescription: String, version: Int = 0) {
        let p = "Action/\(subpath)" ?? "Action"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        self.mandatoryInputs = mandatoryInputs ?? [:]
        self.optionalInputs = optionalInputs ?? [:]
        self.tokens = tokens ?? [:]
        self.producesYields = producesYields
        self.yieldDescription = yieldDescription ?? ""
        self.yields = yields ?? []
        self.ends = ends
        self.endDescription = endsDescription
    }
}

//MARK: JSONEncodable

extension ActionCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "mandatoryInputs": mandatoryInputs.toJSON(),
            "optionalInputs": optionalInputs.toJSON(),
            "tokens": tokens.toJSON(),
            "producesYields": producesYields.toJSON(),
            "yieldDescription": yieldDescription.toJSON(),
            "yields": yields.toJSON(),
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
        self.mandatoryInputs = try json.dictionary("mandatoryInputs").withDecodedValues()
        self.optionalInputs = try json.dictionary("optionalInputs").withDecodedValues()
        self.tokens = try json.dictionary("tokens").withDecodedValues()
        self.producesYields = try json.bool("producesYields")
        self.yieldDescription = try json.string("yieldDescription")
        self.yields = try json.arrayOf("yields", type: YieldType.self)
        self.ends = try json.bool("ends")
        self.endDescription = try json.string("endDescription")
    }
}


//MARK: Dictionary

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
