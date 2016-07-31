//
//  CKWaitUntilTime.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKWaitUntilTime Descriptor

extension CKDescriptors.Action.Trigger.Time {
    /// Descriptor for WaitUntilTime card
    public static let WaitUntilTime = ActionCardDescriptor(
        name: "Wait Until Time",
        subpath: "Trigger/Time",
        description: "Wait until the specified time",
        assetCatalog: CardAssetCatalog(),
        mandatoryInputs: ["time": CKDescriptors.Input.Time.ClockTime],
        optionalInputs: nil,
        tokens: nil,
        producesYields: false,
        yieldDescription: nil,
        yields: nil,
        ends: true,
        endsDescription: "Ends when the specified time is reached",
        version: 0)
}

//MARK: CKWaitUntilTime Implementation

/// Implementation of the CKWaitUntilTime card
public class CKWaitUntilTime: ActionCard {
    
}
