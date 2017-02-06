//
//  CKTestCards.swift
//  CardKit
//
//  Created by Justin Weisz on 8/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

@testable import CardKit

/// Descriptors for test cards.

// swiftlint:disable nesting
public struct CKTestCards {
    fileprivate init() {}
    
    // MARK: - Action Cards
    
    /// Contains descriptors for Action cards
    public struct Action {
        fileprivate init() {}
        
        // MARK: NoAction
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
            assetCatalog: CardAssetCatalog(description: "No action performed."))
        
        // MARK: YieldingNoAction
        /// Descriptor for YieldingNoAction card
        public static let YieldingNoAction = ActionCardDescriptor(
            name: "Yielding No Action",
            subpath: nil,
            inputs: [InputSlot(name: "Input", descriptor: CardKit.Input.Numeric.Real, isOptional: false)],
            tokens: nil,
            yields: [Yield(type: Double.self)],
            yieldDescription: "The answer to the question.",
            ends: true,
            endsDescription: "Ends instantly.",
            assetCatalog: CardAssetCatalog(description: "No action performed, but yields magic."))
        
        // MARK: AcceptsMultipleInputTypes
        /// Descriptor for AcceptsMultipleInputTypes card
        public static let AcceptsMultipleInputTypes = ActionCardDescriptor(
            name: "Accepts Multiple Input Types",
            subpath: nil,
            inputs: [
                InputSlot(name: "A", descriptor: CardKit.Input.Numeric.Real, isOptional: false),
                InputSlot(name: "B", descriptor: CardKit.Input.Text.TextString, isOptional: false),
                InputSlot(name: "C", descriptor: CardKit.Input.Numeric.Real, isOptional: false),
                InputSlot(name: "D", descriptor: CardKit.Input.Raw.RawData, isOptional: false)
            ],
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends instantly.",
            assetCatalog: CardAssetCatalog(description: "No action performed, but accepts magic inputs."))
    }
}
