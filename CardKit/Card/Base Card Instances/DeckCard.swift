//
//  DeckCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class DeckCard {
    public let descriptor: DeckCardDescriptor
    
    init(with descriptor: DeckCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: Card

extension DeckCard: Card {
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
}
