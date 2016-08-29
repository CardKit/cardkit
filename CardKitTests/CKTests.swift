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
        
        //MARK: YieldingNoAction
        /// Descriptor for YieldingNoAction card
        public static let YieldingNoAction = ActionCardDescriptor(
            name: "Yielding No Action",
            subpath: nil,
            inputs: [InputSlot(name: "Input", type: .SwiftDouble, isOptional: false)],
            tokens: nil,
            yields: [Yield(type: .SwiftDouble)],
            yieldDescription: "The answer to the question.",
            ends: true,
            endsDescription: "Ends instantly.",
            assetCatalog: CardAssetCatalog(description: "No action performed, but yields magic."),
            version: 0)
        
        //MARK: AcceptsMultipleInputTypes
        /// Descriptor for AcceptsMultipleInputTypes card
        public static let AcceptsMultipleInputTypes = ActionCardDescriptor(
            name: "Accepts Multiple Input Types",
            subpath: nil,
            inputs: [
                InputSlot(name: "A", type: .SwiftDouble, isOptional: false),
                InputSlot(name: "B", type: .SwiftString, isOptional: false),
                InputSlot(name: "C", type: .SwiftDouble, isOptional: false),
                InputSlot(name: "D", type: .SwiftData, isOptional: false)
            ],
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends instantly.",
            assetCatalog: CardAssetCatalog(description: "No action performed, but accepts magic inputs."),
            version: 0)
    }
}
