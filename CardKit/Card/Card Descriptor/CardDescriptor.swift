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
    /// The type of the card (Action, Deck, Hand, Input, Token)
    var cardType: CardType { get }
    
    /// The name of the card (e.g. "Location", "Turn On", "Fly To")
    var name: String { get }
    
    /// The path of the card. Card paths are always prefixed by their type. For example, a card path for an Input card specifying a distance might be "Input/Location/Distance".
    var path: CardPath { get }
    
    /// Information about the card asset (image & text resources)
    var assetCatalog: CardAssetCatalog { get }
}
