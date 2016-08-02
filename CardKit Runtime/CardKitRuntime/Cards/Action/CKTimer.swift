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
