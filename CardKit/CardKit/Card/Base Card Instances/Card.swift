//
//  Card.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public protocol Card {
    var identifier: CardIdentifier { get }
    var description: String { get }
    var assetCatalog: CardAssetCatalog { get }
    var cardType: CardType { get }
}
