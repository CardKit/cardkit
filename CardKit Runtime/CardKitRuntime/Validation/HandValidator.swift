//
//  HandValidator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

//MARK: HandValidationError

public enum HandValidationError {
    /// No cards were present in the hand
    case NoCardsInHand
    
    /// A consumed token was bound to multiple cards (args: TokenCard identifier, set of card identifiers to which the token was bound)
    case ConsumedTokenBoundToMultipleCards(CardIdentifier, [CardIdentifier])
    
    /// The target of the branch was not found in the Deck (args: branch target HandIdentifier)
    case BranchTargetNotFound(HandIdentifier)
    
    /// The Repeat card specifies an invalid number of repetitions (e.g. negative).
    case RepeatCardCountInvalid(CardIdentifier, Int)
}

//MARK: HandValidator

class HandValidator: Validator {
    func validationActions() -> [ValidationAction] {
        var actions: [ValidationAction] = []
        
        return actions
    }
}
