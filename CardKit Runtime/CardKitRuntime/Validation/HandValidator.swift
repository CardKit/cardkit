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
    
    /// A bound token was not found in the Deck. (args: TokenCard identifier, ActionCard identifier)
    case BoundTokenNotFoundInDeck(CardIdentifier, CardIdentifier)
    
    /// A consumed token was bound to multiple cards (args: TokenCard identifier, set of card identifiers to which the token was bound)
    case ConsumedTokenBoundToMultipleCards(CardIdentifier, [CardIdentifier])
    
    /// The BranchHandCard did not specify a target Hand to which to branch
    case BranchTargetNotSpecified(CardIdentifier)
    
    /// The target of the branch was not found in the Deck (args: branch target HandIdentifier)
    case BranchTargetNotFound(HandIdentifier)
    
    /// There is no BranchHandCard that branches to the specified subhand
    case SubhandUnreachable(HandIdentifier)
    
    /// The Repeat card specifies an invalid number of repetitions (e.g. negative).
    case RepeatCardCountInvalid(CardIdentifier, Int)
}

//MARK: HandValidator

class HandValidator: Validator {
    func validationActions() -> [ValidationAction] {
        var actions: [ValidationAction] = []
        
        // NoCardsInHand
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkNoCardsInHand(deck, hand)
        })
        
        // BoundTokenNotFoundInDeck
        // ConsumedTokenBoundToMultipleCards
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkTokenBindings(deck, hand)
        })
        
        // BranchTargetNotSpecified
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkBranchTargetNotSpecified(deck, hand)
        })
        
        // BranchTargetNotFound
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkBranchTargetNotFound(deck, hand)
        })
        
        // SubhandUnreachable
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkSubhandUnreachable(deck, hand)
        })
        
        // RepeatCardCountInvalid
        actions.append({
            (deck, hand, _) in
            guard let hand = hand else { return [] }
            return self.checkRepeatCardCountInvalid(deck, hand)
        })
        
        return actions
    }
    
    func checkNoCardsInHand(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        if hand.cards.count <= 1 {
            // all Hands have an End Rule card, so check if there's something else
            errors.append(ValidationError.HandError(.Warning, deck.identifier, hand.identifier, .NoCardsInHand))
        }
        
        return errors
    }
    
    func checkTokenBindings(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var tokenBindings: [CardIdentifier : [CardIdentifier]] = [:]
        
        for card in hand.actionCards {
            for tokenCardIdentifier in card.boundTokenCardIdentifiers {
                var bindings = tokenBindings[tokenCardIdentifier] ?? []
                bindings.append(card.identifier)
                tokenBindings[tokenCardIdentifier] = bindings
            }
        }
        
        for (tokenCardIdentifier, bindings) in tokenBindings {
            let tokenCard = deck.tokenCard(with: tokenCardIdentifier)
            
            if let tokenCard = tokenCard {
                // found the Token in the Deck, check if it's Consumed
                if tokenCard.descriptor.isConsumed {
                    // make sure only ONE card is bound to this token
                    if bindings.count > 1 {
                        errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .ConsumedTokenBoundToMultipleCards(tokenCardIdentifier, bindings)))
                    }
                }
            } else {
                // bound Token not found in Deck, throw an error
                // for every ActionCard that bound to this Token
                for actionCardIdentifier in bindings {
                    errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .BoundTokenNotFoundInDeck(tokenCardIdentifier, actionCardIdentifier)))
                }
            }
        }
        
        return errors
    }
    
    func checkBranchTargetNotSpecified(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for card in hand.branchCards {
            if card.targetHandIdentifier == nil {
                errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .BranchTargetNotSpecified(card.identifier)))
            }
        }
        
        return errors
    }
    
    func checkBranchTargetNotFound(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for card in hand.branchCards {
            guard let branchTarget = card.targetHandIdentifier else { continue }
            
            // find it in hand.subhands
            let found = hand.subhands.map { $0.identifier == branchTarget }.reduce(false) {
                (ret, result) in ret || result
            }
            
            if !found {
                errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .BranchTargetNotFound(branchTarget)))
            }
        }
        
        return errors
    }
    
    func checkSubhandUnreachable(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var unbranchedSubhands = Array(hand.subhands)
        
        for card in hand.branchCards {
            let branchTarget = card.targetHandIdentifier
            
            // remove the target Hand from unbranchedSubhands
            unbranchedSubhands = unbranchedSubhands.filter { $0.identifier != branchTarget }
        }
        
        // anything still in unbranchedSubhands didn't have a BranchHandCard
        // targeting it
        for subhand in unbranchedSubhands {
            errors.append(ValidationError.HandError(.Warning, deck.identifier, hand.identifier, .SubhandUnreachable(subhand.identifier)))
        }
        
        return errors
    }
    
    func checkRepeatCardCountInvalid(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        guard let repeatCard = hand.repeatCard else { return [] }
        
        if repeatCard.repeatCount < 0 {
            errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .RepeatCardCountInvalid(repeatCard.identifier, repeatCard.repeatCount)))
        }
        
        return errors
    }
}
