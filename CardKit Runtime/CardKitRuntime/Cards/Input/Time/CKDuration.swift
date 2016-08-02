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
    
}

//MARK: CKDuration Implementation

/// Implementation of the Duration card
public class CKDuration: InputCard {
    init() {
        super.init(with: CKDescriptors.Input.Time.Duration)
    }
    
    func setDuration(duration: NSTimeInterval) {
        do {
            try super.bindYieldData(duration)
        } catch {
        }
    }
}
