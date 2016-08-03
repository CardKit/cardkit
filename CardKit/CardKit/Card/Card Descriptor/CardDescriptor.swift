//
//  CardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Defines all the metadata for a card.
public protocol CardDescriptor {
    var type: CardType { get }
    var name: String { get }
    var path: CardPath { get }
    var version: Int { get }
    var description: String { get }
    var assetCatalog: CardAssetCatalog { get }
}
