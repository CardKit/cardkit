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
    case CardAndHandShareSameIdentifier(String)
    
    /// A Card and the Deck were found sharing the same identifier (equivalent String values)
    case CardAndDeckShareSameIdentifier(String)
    
    /// A Hand and the Deck were found sharing the same identifier (equivalent String values)
    case HandAndDeckShareSameIdentifier(String)
    
    /// A Yield was used before it was produced (args: consuming Card identifier, consuming Hand identifier, producing Card identifier, Yield identifier, producing Hand identifier)
    case YieldConsumedBeforeProduced(CardIdentifier, HandIdentifier, CardIdentifier, YieldIdentifier, HandIdentifier)
    
    /// ActionCard A was bound to ActionCard B, but ActionCard B could not be found in the Deck. (args: ActionCard A identifier, ActionCard A hand identifier, ActionCard B identifier)
    case YieldProducerNotFoundInDeck(CardIdentifier, HandIdentifier, CardIdentifier)
}

//MARK DeckValidator

class DeckValidator: Validator {
    private let deck: Deck
    
    init(_ deck: Deck) {
        self.deck = deck
    }
    
    var validationActions: [ValidationAction] {
        var actions: [ValidationAction] = []
        
        // NoCardsInDeck
        actions.append({
            return self.checkNoCardsInDeck(self.deck)
        })
        
        // NoHandsInDeck
        actions.append({
            return self.checkNoHandsInDeck(self.deck)
        })
        
        // MultipleHandsWithSameIdentifier
        actions.append({
            return self.checkMultipleHandsWithSameIdentifier(self.deck)
        })
        
        // CardUsedInMultipleHands
        actions.append({
            return self.checkCardUsedInMultipleHands(self.deck)
        })
        
        // CardAndHandShareSameIdentifier
        actions.append({
            return self.checkCardAndHandShareSameIdentifier(self.deck)
        })
        
        // CardAndDeckShareSameIdentifier
        actions.append({
            return self.checkCardAndDeckShareSameIdentifier(self.deck)
        })
        
        // HandAndDeckShareSameIdentifier
        actions.append({
            return self.checkHandAndDeckShareSameIdentifier(self.deck)
        })
        
        // YieldConsumedBeforeProduced
        // YieldProducerNotFoundInDeck
        actions.append({
            return self.checkYields(self.deck)
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
    
    func checkCardUsedInMultipleHands(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var cardInHands: [CardIdentifier : [HandIdentifier]] = [:]
        
        for hand in deck.hands {
            for card in hand.cards {
                var hands = cardInHands[card.identifier] ?? []
                hands.append(hand.identifier)
                cardInHands[card.identifier] = hands
            }
        }
        
        for (identifier, hands) in cardInHands {
            if hands.count > 1 {
                errors.append(ValidationError.DeckError(.Warning, deck.identifier, .CardUsedInMultipleHands(identifier, hands)))
            }
        }
        
        return errors
    }
    
    func checkCardAndHandShareSameIdentifier(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var cardIdentifiers: Set<String> = Set()
        var handIdentifiers: Set<String> = Set()
        
        for card in deck.cards {
            cardIdentifiers.insert(card.identifier.description)
        }
        
        for hand in deck.hands {
            handIdentifiers.insert(hand.identifier.description)
        }
        
        // check if Card identifiers are contained in Hand
        for cardIdentifier in cardIdentifiers {
            if handIdentifiers.contains(cardIdentifier) {
                errors.append(ValidationError.DeckError(.Error, deck.identifier, .CardAndHandShareSameIdentifier(cardIdentifier)))
            }
        }
        
        // check if Hand identifiers are contained in Card
        for handIdentifier in handIdentifiers {
            if cardIdentifiers.contains(handIdentifier) {
                errors.append(ValidationError.DeckError(.Error, deck.identifier, .CardAndHandShareSameIdentifier(handIdentifier)))
            }
        }
        
        return errors
    }
    
    func checkCardAndDeckShareSameIdentifier(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for card in deck.cards {
            if card.identifier.description == deck.identifier.description {
                errors.append(ValidationError.DeckError(.Error, deck.identifier, .CardAndDeckShareSameIdentifier(card.identifier.description)))
            }
        }
        
        return errors
    }
    
    func checkHandAndDeckShareSameIdentifier(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for hand in deck.hands {
            if hand.identifier.description == deck.identifier.description {
                errors.append(ValidationError.DeckError(.Error, deck.identifier, .HandAndDeckShareSameIdentifier(hand.identifier.description)))
            }
        }
        
        return errors
    }
    
    func checkYields(deck: Deck) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        func handContainingCard(with identifier: CardIdentifier) -> Hand? {
            for hand in deck.hands {
                if hand.contains(identifier) {
                    return hand
                }
            }
            return nil
        }
        
        func checkYieldUsage(hand: Hand, actionCardsWithProducedYields: Set<CardIdentifier>) {
            for card in hand.actionCards {
                for (_, binding) in card.inputBindings {
                    // if this card is bound to a yielding action card...
                    if case .BoundToYieldingActionCard(let identifier, let yield) = binding {
                        // and that card hasn't yet produced its yields...
                        if !actionCardsWithProducedYields.contains(identifier) {
                            // then the yield is being used before it was produced!
                            // figure out which hand the actionCard belongs to
                            if let producingHand = handContainingCard(with: identifier) {
                                errors.append(ValidationError.DeckError(.Error, deck.identifier, .YieldConsumedBeforeProduced(card.identifier, hand.identifier, identifier, yield.identifier, producingHand.identifier)))
                            } else {
                                errors.append(ValidationError.DeckError(.Error, deck.identifier, .YieldProducerNotFoundInDeck(card.identifier, hand.identifier, identifier)))
                            }
                        }
                    }
                }
            }
        }
        
        return errors
    }
}
