//
//  CKTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Descriptors for test cards.

// swiftlint:disable nesting
public struct CKTests {
    private init() {}
    
    //MARK:- Action Cards
    
    /// Contains descriptors for Action cards
    public struct Action {
        private init() {}
        
        //MARK: NoAction
        /// Descriptor for NoAction card
        public static let NoAction = ActionCardDescriptor(
            name: "No Action",
            subpath: nil,
            inputs: nil,
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends instantly.",
            assetCatalog: CardAssetCatalog(description: "No action performed."),
            version: 0)
    }
}
