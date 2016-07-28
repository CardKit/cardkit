//
//  CKNoAction.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension CKDescriptors.Action {
    public static let NoAction = ActionCardDescriptor(
        name: "No Action",
        subpath: nil,
        description: "No action performed. Used as a placeholder.",
        assetCatalog: CardAssetCatalog(),
        mandatoryInputs: nil,
        optionalInputs: nil,
        tokens: nil,
        producesYields: false,
        yieldDescription: nil,
        yields: nil,
        ends: true,
        endsDescription: "Ends instantly",
        version: 0)
}

/// Implementation of the NoAction card. Does nothing.
public class CKNoAction: ActionCard {
    init() {
        super.init(with: CKDescriptors.Action.NoAction)
    }
    
    //MARK: Execution
    
    override func setup() {
        print("NoAction: setup")
    }
    
    override func execute() {
        print("NoAction: execute")
    }
    
    override func interrupt() {
        print("NoAction: interrupt")
    }
    
    override func teardown() {
        print("NoAction: teardown")
    }
}
