//
//  CKDuration.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKDuration Descriptor

extension CKDescriptors.Input.Time {
    /// Descriptor for Duration card
    public static let Duration = InputCardDescriptor(
        name: "Duration",
        subpath: "Time",
        description: "Duration (seconds)",
        assetCatalog: CardAssetCatalog(),
        provides: [.SwiftInt],
        version: 0)
}

//MARK: CKDuration Implementation

/// Implementation of the Duration card
public class CKDuration: InputCard {
    
}
