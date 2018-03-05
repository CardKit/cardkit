//
//  CardAssetCatalog.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public struct CardAssetCatalog: Codable {
    public var textualDescription: String
    
    public init() {
        self.textualDescription = ""
    }
    
    public init(description: String) {
        self.textualDescription = description
    }
}
