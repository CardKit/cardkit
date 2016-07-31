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
        inputs: [CKWaitUntilTime.Input.ClockTime],
        tokens: nil,
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the specified time is reached",
        version: 0)
}

//MARK: CKWaitUntilTime Implementation

/// Implementation of the CKWaitUntilTime card
public class CKWaitUntilTime: ActionCard {
    init() {
        super.init(with: CKDescriptors.Action.Trigger.Time.WaitUntilTime)
    }
    
    // MARK: Input slots
    public struct Input {
        private init() {}
        public static let ClockTime = InputCardSlot(
            identifier: "ClockTime",
            descriptor: CKDescriptors.Input.Time.ClockTime,
            isOptional: false)
    }
    
    //MARK: Executable
    
    override func setup() {
        print("CKWaitUntilTime: setup")
    }
    
    override func execute() {
        print("CKWaitUntilTime: execute")
    }
    
    override func interrupt() {
        print("CKWaitUntilTime: interrupt")
    }
    
    override func teardown() {
        print("CKWaitUntilTime: teardown")
    }
}
