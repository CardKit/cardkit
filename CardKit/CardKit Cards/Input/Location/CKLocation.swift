//
//  CKLocation.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKLocation Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Location card
    public static let Location = InputCardDescriptor(
        name: "Location",
        subpath: "Location",
        description: "Location (3D coordinate)",
        assetCatalog: CardAssetCatalog(),
        inputType: .Coordinate3D,
        inputDescription: "Coordinate (3D)",
        version: 0)
}

//MARK: CKLocation Implementation

/// Implementation of the CKLocation card
public class CKLocation: InputCard {
    
}
