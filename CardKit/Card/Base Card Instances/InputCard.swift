//
//  InputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class InputCard {
    public let descriptor: InputCardDescriptor
    
    // ImplementsProducesInput
    var inputValue: YieldBinding? = nil
    
    init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: Card

extension InputCard: Card {
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
}

//MARK: ImplementsProducesInput

extension InputCard: ImplementsProducesInput {}
