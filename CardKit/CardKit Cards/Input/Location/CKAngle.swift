//
//  CKAngle.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKAngle Descriptor

extension CKDescriptors.Input.Location {
    /// Descriptor for Angle card
    public static let Angle = InputCardDescriptor(
        name: "Angle",
        subpath: "Location",
        description: "Angle (in degrees)",
        assetCatalog: CardAssetCatalog(),
        inputType: .SwiftDouble,
        inputDescription: "Angle (in degrees)",
        version: 0)
}

//MARK: CKAngle Implementation

/// Implementation of the Angle card
public class CKAngle: InputCard {
    init() {
        super.init(with: CKDescriptors.Input.Location.Angle)
    }
    
    func setAngle(inDegrees degrees: Double) {
        self.bindYieldData(degrees)
    }
    
    func setAngle(inRadians radians: Double) {
        let degrees = radians * (Double.pi / 180)
        self.bindYieldData(degrees)
    }
}
