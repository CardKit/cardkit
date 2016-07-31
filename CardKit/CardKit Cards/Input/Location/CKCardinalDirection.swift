//
//  CKCardinalDirection.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKCardinalDirection Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Cardinal Direction card
    public static let CardinalDirection = InputCardDescriptor(
        name: "Cardinal Direction",
        subpath: "Location",
        description: "Cardinal Direction (N, S, E, W)",
        assetCatalog: CardAssetCatalog(),
        inputType: .CardinalDirection,
        inputDescription: "Cardinal Direction",
        version: 0)
}

//MARK: CKCardinalDirection Implementation

/// Implementation of the CKCardinalDirection card
public class CKCardinalDirection: InputCard {
    
}
