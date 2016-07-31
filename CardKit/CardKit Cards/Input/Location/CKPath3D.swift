//
//  CKPath3D.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKPath3D Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Path 3D card
    public static let Path3D = InputCardDescriptor(
        name: "Path 3D",
        subpath: "Location",
        description: "Path (3D)",
        assetCatalog: CardAssetCatalog(),
        provides: [.Coordinate3DPath],
        version: 0)
}

//MARK: CKPath3D Implementation

/// Implementation of the CKPath3D card
public class CKPath3D: InputCard {
    
}
