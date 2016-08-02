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
    
}

//MARK: CKAngle Implementation

/// Implementation of the Angle card
public class CKAngle: InputCard {
    init() {
        super.init(with: CKDescriptors.Input.Location.Angle)
    }
    
    func setAngle(inDegrees degrees: Double) {
        do {
            try self.bindYieldData(degrees)
        } catch {
        }
    }
    
    func setAngle(inRadians radians: Double) {
        let degrees = radians * (180.0 / M_PI)
        
        do {
            try self.bindYieldData(degrees)
        } catch {
        }
    }
}
