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
    //TODO need to fill this in
}

//MARK: JSONEncodable

extension CardAssetCatalog: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([:])
    }
}

//MARK: JSONDecodable

extension CardAssetCatalog: JSONDecodable {
    public init(json: JSON) throws {
        
    }
}
