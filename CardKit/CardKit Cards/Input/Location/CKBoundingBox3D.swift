//
//  CKBoundingBox3D.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKBoundingBox3D Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Bounding Box 3D card
    public static let BoundingBox3D = InputCardDescriptor(
        name: "Bounding Box 3D",
        subpath: "Location",
        description: "Bounding Box (3D)",
        assetCatalog: CardAssetCatalog(),
        provides: [.Coordinate3DPath],
        version: 0)
}

//MARK: CKBoundingBox3D Implementation

/// Implementation of the Bounding Box 3D card
public class CKBoundingBox3D: InputCard {
    
}
