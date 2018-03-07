/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

@testable import CardKit

/// Descriptors for test cards.
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
