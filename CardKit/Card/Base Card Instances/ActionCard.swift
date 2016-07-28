//
//  ActionCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class ActionCard: Card, Executable {
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
    
    public let descriptor: ActionCardDescriptor
    
    public var executionFinished: Bool = false
    
    init(with descriptor: ActionCardDescriptor) {
        self.descriptor = descriptor
    }
    
    //MARK: Executable
    
    func setup() {
        fatalError("cannot setup() an ActionCard")
    }
    
    func execute() {
        fatalError("cannot execute() an ActionCard")
    }
    
    func interrupt() {
        fatalError("cannot interrupt() an ActionCard")
    }
    
    func teardown() {
        fatalError("cannot teardown() an ActionCard")
    }
}
