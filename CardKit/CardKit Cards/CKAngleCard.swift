//
//  CKAngleCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension CKDescriptors.Input.Location {
    /// Descriptor for Angle card
    public static let Angle = InputCardDescriptor(
        name: "Angle",
        subpath: nil,
        description: "Angle (in degrees)",
        assetCatalog: CardAssetCatalog(),
        provides: [.SwiftDouble],
        version: 0)
}

/// Implementation of the Angle card
public class CKAngleCard: Card {
    
}
