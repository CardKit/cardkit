//
//  CKBoundingBox.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKBoundingBox Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Bounding Box card
    public static let BoundingBox = InputCardDescriptor(
        name: "Bounding Box",
        subpath: "Location",
        description: "Bounding Box (2D)",
        assetCatalog: CardAssetCatalog(),
        inputType: .Coordinate2DPath,
        inputDescription: "Set of 2D coordinates",
        version: 0)
}

//MARK: CKBoundingBox Implementation

/// Implementation of the Bounding Box card
public class CKBoundingBox: InputCard {
    
}
