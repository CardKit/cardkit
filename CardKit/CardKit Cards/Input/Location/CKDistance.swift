//
//  CKDistance.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKDistance Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Distance card
    public static let Distance = InputCardDescriptor(
        name: "Distance",
        subpath: "Location",
        description: "Distance (meters)",
        assetCatalog: CardAssetCatalog(),
        provides: [.SwiftDouble],
        version: 0)
}

//MARK: CKDistance Implementation

/// Implementation of the CKDistance card
public class CKDistance: InputCard {
    
}
