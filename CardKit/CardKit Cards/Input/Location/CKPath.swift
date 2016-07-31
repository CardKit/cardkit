//
//  CKPath.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKPath Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Path card
    public static let Path = InputCardDescriptor(
        name: "Path",
        subpath: "Location",
        description: "Path (2D)",
        assetCatalog: CardAssetCatalog(),
        provides: [.Coordinate2DPath],
        version: 0)
}

//MARK: CKPath Implementation

/// Implementation of the CKPath card
public class CKPath: InputCard {
    
}
