//
//  CardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public protocol CardDescriptor {
    var identifier: CardIdentifier { get }
    var description: String { get }
    var cardType: CardType { get }
    var assetCatalog: CardAssetCatalog { get }
}

/*
    init(identifier: CardIdentifier, _ description: String, _ cardType: CardType, _ assetCatalog: CardAssetCatalog) {
        self.identifier = identifier
        self.description = description
        self.cardType = cardType
        self.assetCatalog = assetCatalog
    }
    
    init(path: String, name: String, version: Int = 0, description: String, cardType: CardType, assetCatalog: CardAssetCatalog) {
        self.identifier = CardIdentifier(path: path, name: name, version: version)
        self.description = description
        self.cardType = cardType
        self.assetCatalog = assetCatalog
    }
}

//MARK: JSONEncodable

extension CardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": .String(description),
            "cardType": .String(cardType.description),
            "assetCatalog": assetCatalog.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension CardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        let cardType = try json.string("cardType")
        guard let cardTypeEnum = CardType(rawValue: cardType) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: CardDescriptor.self)
        }
        self.cardType = cardTypeEnum
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
    }
}
*/


//extension CardDescriptor: DictionaryConvertible {
//    init?(from dictionary: [String : AnyObject]) {
//        guard let identifierDict = dictionary["identifier"] as? [String : AnyObject] else { return nil }
//        guard let identifier = CardIdentifier(from: identifierDict) else { return nil }
//        guard let description = dictionary["description"] as? String else { return nil }
//        guard let cardTypeStr = dictionary["cardType"] as? String else { return nil }
//        guard let cardType = CardType(rawValue: cardTypeStr) else { return nil }
//        guard let assetCatalogDict = dictionary["assetCatalog"] as? [String : AnyObject] else { return nil }
//        guard let assetCatalog = CardAssetCatalog(from: assetCatalogDict) else { return nil }
//        
//        self.identifier = identifier
//        self.description = description
//        self.cardType = cardType
//        self.assetCatalog = assetCatalog
//    }
//    
//    func toDictionary() -> [String : AnyObject] {
//        var dict: [String : AnyObject] = [:]
//        dict["identifier"] = identifier.toDictionary()
//        dict["description"] = description
//        dict["cardType"] = cardType.description
//        dict["assetCatalog"] = assetCatalog.toDictionary()
//        return dict
//    }
//}
