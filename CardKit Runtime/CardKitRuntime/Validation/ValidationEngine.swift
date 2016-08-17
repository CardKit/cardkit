//
//  ValidationEngine.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

public class ValidationEngine {
    /// Validates the entire Deck.
    public class func validate(deck: Deck) -> [ValidationError] {
        var validationActions: [ValidationAction] = []
        
        validationActions.appendContentsOf(DeckValidator(deck).validationActions)
        
        for hand in deck.hands {
            validationActions.appendContentsOf(HandValidator(deck, hand).validationActions)
            
            for card in hand.cards {
                validationActions.appendContentsOf(CardValidator(deck, hand, card).validationActions)
            }
        }
        
        return ValidationEngine.executeValidation(validationActions)
    }
    
    /// Validates the given Hand in the given Deck.
    public class func validate(hand: Hand, _ deck: Deck) -> [ValidationError] {
        var validationActions: [ValidationAction] = []
        
        validationActions.appendContentsOf(HandValidator(deck, hand).validationActions)
            
        for card in hand.cards {
            validationActions.appendContentsOf(CardValidator(deck, hand, card).validationActions)
        }
        
        return ValidationEngine.executeValidation(validationActions)
    }
    
    /// Validates the given Card in the given Hand in the given Deck.
    public class func validate(card: Card, _ hand: Hand, _ deck: Deck) -> [ValidationError] {
        var validationActions: [ValidationAction] = []
        
        validationActions.appendContentsOf(CardValidator(deck, hand, card).validationActions)
        
        return ValidationEngine.executeValidation(validationActions)
    }
    
    class func executeValidation(validationActions: [ValidationAction]) -> [ValidationError] {
        let queue: dispatch_queue_t = dispatch_queue_create("com.ibm.research.CardKit.ValidationEngine", DISPATCH_QUEUE_CONCURRENT)
        
        var validationErrors: [ValidationError] = []
        
        for action in validationActions {
            dispatch_async(queue) {
                let errors = action()
                
                dispatch_barrier_sync(queue) {
                    validationErrors.appendContentsOf(errors)
                }
            }
        }
        
        return validationErrors
    }
}
