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
        description: "No action performed.",
        assetCatalog: CardAssetCatalog(),
        inputs: nil,
        tokens: nil,
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends instantly.",
        version: 0)
}

/// Implementation of the NoAction card. Does nothing.
public class CKNoAction: ActionCard {
    init() {
        super.init(with: CKDescriptors.Action.NoAction)
    }
    
    //MARK: Executable
    
    override func setup() {
        print("CKNoAction: setup")
    }
    
    override func execute() {
        print("CKNoAction: execute")
    }
    
    override func interrupt() {
        print("CKNoAction: interrupt")
    }
    
    override func teardown() {
        print("CKNoAction: teardown")
    }
}
