//
//  HandCardType
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

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
