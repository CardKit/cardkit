//
//  CardAssetCatalog.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct CardAssetCatalog {
    public var textualDescription: String
    
    init() {
        self.textualDescription = ""
    }
    
    init(description: String) {
        self.textualDescription = description
    }
}

//MARK: JSONEncodable

extension CardAssetCatalog: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "textualDescription": self.textualDescription.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension CardAssetCatalog: JSONDecodable {
    public init(json: JSON) throws {
        self.textualDescription = try json.string("textualDescription")
    }
}
