//
//  CKNoActionCard.swift
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
