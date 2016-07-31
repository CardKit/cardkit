//
//  CKTimer.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: CKTimer Descriptor

extension CKDescriptors.Action.Trigger.Time {
    /// Descriptor for Timer card
    public static let Timer = ActionCardDescriptor(
        name: "Timer",
        subpath: "Trigger/Time",
        description: "Set a timer",
        assetCatalog: CardAssetCatalog(),
        inputs: [CKTimer.Input.Duration],
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
    
    //MARK: Inputs
    public struct Input {
        private init() {}
        public static let Duration = InputCardSlot(
            identifier: "Duration",
            descriptor: CKDescriptors.Input.Time.Duration,
            isOptional: false)
    }
    
    //MARK: Executable
    
    override func setup() {
        print("CKTimer: setup")
    }
    
    override func execute() {
        print("CKTImer: execute")
    }
    
    override func interrupt() {
        print("CKTimer: interrupt")
    }
    
    override func teardown() {
        print("CKTimer: teardown")
    }
}
