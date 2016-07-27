//
//  ActionCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct ActionCardDescriptor: CardDescriptor, AcceptsInputs, AcceptsTokens, Yields, Satisfiable {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let mandatoryInputs: CardInputs
    public let optionalInputs: CardInputs
    
    public let tokens: CardTokens
    
    public let yields: Bool
    public let yieldDescription: String
    
    public let ends: Bool
    public let endDescription: String
    
    public var cardType: CardType {
        get {
            return .Action
        }
    }
    
    public init(name: String, subpath: String, description: String, assetCatalog: CardAssetCatalog, mandatoryInputs: CardInputs?, optionalInputs: CardInputs?, tokens: CardTokens?, yields: Bool, yieldDescription: String?, ends: Bool, endsDescription: String, version: Int = 0) {
        let p = (subpath == "") ? "Action" : "Action/\(subpath)"
        self.identifier = CardIdentifier(path: p, name: name, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        
        if let mi = mandatoryInputs {
            self.mandatoryInputs = mi
        } else {
            self.mandatoryInputs = [:]
        }
        
        if let oi = self.optionalInputs {
            self.optionalInputs = oi
        } else {
            self.optionalInputs = [:]
        }
        
        if let t = self.tokens {
            self.tokens = t
        } else {
            self.tokens = [:]
        }
        
        self.yields = yields
        self.yieldDescription = yieldDescription
        
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
        
        let mandatoryInputs = try json.dictionary("mandatoryInputs")
        for (k,v) in mandatoryInputs {
            self.mandatoryInputs[k] = try InputCardDescriptor(json: v)
        }
        
        let optionalInputs = try json.dictionary("optionalInputs")
        for (k,v) in optionalInputs {
            self.optionalInputs[k] = try InputCardDescriptor(json: v)
        }
        
        let tokens = try json.dictionary("tokens")
        for (k,v) in tokens {
            self.tokens[k] = try TokenCardDescriptor(json: v)
        }
        
        self.yieldDescription = try json.string("yieldDescription")
        self.ends = try json.bool("ends")
        self.endDescription = try json.string("endDescription")
    }
}
