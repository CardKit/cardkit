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
    /// Descriptor for ClockTime card
    public static let ClockTime = InputCardDescriptor(
        name: "Clock Time",
        subpath: "Time",
        description: "Time (date & time)",
        assetCatalog: CardAssetCatalog(),
        inputType: .SwiftDate,
        inputDescription: "Date & time string",
        version: 0)
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
