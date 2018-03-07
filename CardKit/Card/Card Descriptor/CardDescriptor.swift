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

/// Defines all the metadata for a card.
public protocol CardDescriptor {
    /// The type of the card (Action, Deck, Hand, Input, Token)
    var cardType: CardType { get }
    
    /// The name of the card (e.g. "Location", "Turn On", "Fly To")
    var name: String { get }
    
    /// The path of the card. Card paths are always prefixed by their type. For example, a card path for an Input card specifying a distance might be "Input/Location/Distance".
    var path: CardPath { get }
    
    /// Information about the card asset (image & text resources)
    var assetCatalog: CardAssetCatalog { get }
}
