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

// MARK: HandCardType

public enum HandCardType: String {
    /// Branch to another hand.
    case branch
    
    /// Repeat executing the hand.
    case repeatHand
    
    /// Conclude the hand when ALL conditions are satisfied
    case endWhenAllSatisfied
    
    /// Conclude the hand when ANY condition is satisfied
    case endWhenAnySatisfied
    
    /// Perform a boolean AND to determine whether this card is satisfied.
    case booleanLogicAnd
    
    /// Perform a boolean OR to determine whether this card is satisfied.
    case booleanLogicOr
    
    /// Perform a boolean NOT to determine whether this card is satisfied.
    case booleanLogicNot
}

// MARK: Codable

extension HandCardType: Codable {}
