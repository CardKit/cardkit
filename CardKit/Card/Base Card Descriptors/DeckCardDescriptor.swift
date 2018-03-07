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

// MARK: DeckCardDescriptor

public struct DeckCardDescriptor: CardDescriptor, Codable {
    public let cardType: CardType = .deck
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public init(name: String, subpath: String?, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Deck/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Deck")
        }
        self.assetCatalog = assetCatalog
    }
    
    /// Return a new DeckCard instance using our descriptor
    public func makeCard() -> DeckCard {
        return DeckCard(with: self)
    }
}

// MARK: Equatable

extension DeckCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same.
    /// All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: DeckCardDescriptor, rhs: DeckCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension DeckCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension DeckCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}
