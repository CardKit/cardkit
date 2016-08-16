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
    
    /// Multiple hands were found in the Deck sharing the same HandIdentifier (args: Hand identifier, count)
    case MultipleHandsWithSameIdentifier(HandIdentifier, Int)
    
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
        
        // NoCardsInDeck
        actions.append({
            (deck, _, _) in
            return self.checkNoCardsInDeck(deck)
        })
        
        // NoHandsInDeck
        actions.append({
            (deck, _, _) in
            return self.checkNoHandsInDeck(deck)
        })
        
        // MultipleHandsWithSameIdentifier
        actions.append({
            (deck, _, _) in
            return self.checkMultipleHandsWithSameIdentifier(deck)
        })
        
        return actions
    }
    
    func checkNoCardsInDeck(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        if deck.cardCount == 0 {
            errors.append(ValidationError.DeckError(.Warning, deck.identifier, .NoCardsInDeck))
        }
        
        return errors
    }
    
    func checkNoHandsInDeck(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        if deck.hands.isEmpty {
            errors.append(ValidationError.DeckError(.Warning, deck.identifier, .NoHandsInDeck))
        }
        
        return errors
    }
    
    func checkMultipleHandsWithSameIdentifier(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var identifierCounts: [HandIdentifier : Int] = [:]
        
        for hand in deck.hands {
            let count = identifierCounts[hand.identifier] ?? 0
            identifierCounts[hand.identifier] = count + 1
        }
        
        for (identifier, count) in identifierCounts {
            if count > 1 {
                errors.append(ValidationError.DeckError(.Error, deck.identifier, .MultipleHandsWithSameIdentifier(identifier, count)))
            }
        }
        
        return errors
    }
}
