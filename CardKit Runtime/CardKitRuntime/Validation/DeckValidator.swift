//
//  DeckValidator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

//MARK: DeckValidationError

public enum DeckValidationError {
    /// No cards were present in the deck
    case NoCardsInDeck
    
    /// No hands were present in the deck
    case NoHandsInDeck
    
    /// Multiple hands were found in the Deck sharing the same HandIdentifier
    case MultipleHandsWithSameIdentifier(HandIdentifier)
    
    /// A card was placed into multiple hands (args: Card identifier, set of hands in which the card was found)
    case CardUsedInMultipleHands(CardIdentifier, [HandIdentifier])
    
    /// A Card and a Hand were found sharing the same identifier (equivalent String values)
    case CardAndHandShareSameIdentifier(HandIdentifier, CardIdentifier)
    
    /// A Yield was used before it was produced (args: consuming Card identifier, consuming Hand identifier, producing Card identifier, Yield identifier, producing Hand identifier)
    case YieldConsumedBeforeProduced(CardIdentifier, HandIdentifier, CardIdentifier, YieldIdentifier, HandIdentifier)
}

//MARK DeckValidator

class DeckValidator: Validator {
    func validationActions() -> [ValidationAction] {
        var actions: [ValidationAction] = []
        
        return actions
    }
}
