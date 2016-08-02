//
//  CKNoAction.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension CKDescriptors.Action {
    
}

/// Implementation of the NoAction card. Does nothing.
public class CKNoAction: ActionCard {
    init() {
        super.init(with: CKDescriptors.Action.NoAction)
    }
    
    //MARK: Executable
    
    override func setup() {
        print("CKNoAction: setup")
    }
    
    override func execute() {
        print("CKNoAction: execute")
    }
    
    override func interrupt() {
        print("CKNoAction: interrupt")
    }
    
    override func teardown() {
        print("CKNoAction: teardown")
    }
}
