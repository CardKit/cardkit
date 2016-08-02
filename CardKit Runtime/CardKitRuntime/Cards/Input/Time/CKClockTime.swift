//
//  CKClockTime.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKClockTime Descriptor

extension CKDescriptors.Input.Time {
    
}

//MARK: CKClockTime Implementation

/// Implementation of the ClockTime card
public class CKClockTime: InputCard {
    init() {
        super.init(with: CKDescriptors.Input.Time.ClockTime)
    }
    
    func setClockTime(date: NSDate) {
        do {
            try super.bindYieldData(date)
        } catch {
        }
    }
}
