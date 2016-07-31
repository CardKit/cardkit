//
//  CKTimer.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKTimer Inputs

public enum CKTimerInput: String {
    case Duration
}

//MARK: CKTimer Descriptor

extension CKDescriptors.Action.Trigger.Time {
    /// Descriptor for Timer card
    public static let _timerSlot = InputCardSlot(identifier: CKTimerInput.Duration.rawValue, descriptor: CKDescriptors.Input.Time.Duration, isOptional: false)
    
    public static let Timer = ActionCardDescriptor(
        name: "Timer",
        subpath: "Trigger/Time",
        description: "Set a timer",
        assetCatalog: CardAssetCatalog(),
        inputs: [_timerSlot],
        tokens: nil,
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends after the specified duration",
        version: 0)
}

//MARK: CKTimer

/// Implementation of the CKTimer card
public class CKTimer: ActionCard {
    init() {
        super.init(with: CKDescriptors.Action.Trigger.Time.Timer)
    }
}
