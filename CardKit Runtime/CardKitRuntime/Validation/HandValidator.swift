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
    
    /// Multiple Hand-level BranchHandCards were found. Hand-level means the CardTreeIdentifier is nil, signifying
    /// that the branch will happen when the entire Hand is satisfied.
    case MultipleHandLevelBranchesFound([CardIdentifier])
    
    /// Multiple BranchHandCards are attached to the same CardTree (args: CardTree identifier, list of BranchHandCards)
    case CardTreeContainsMultipleBranches(CardTreeIdentifier, [CardIdentifier])
    
    /// There is no BranchHandCard that branches to the specified subhand
    case SubhandUnreachable(HandIdentifier)
    
    /// A circular reference was found. The list of HandIdentifiers contains the reference cycle.
    case HandContainsCircularReference([HandIdentifier])
    
    /// The Repeat card specifies an invalid number of repetitions (e.g. negative).
    case RepeatCardCountInvalid(CardIdentifier, Int)
}

//MARK: HandValidator

class HandValidator: Validator {
    private let deck: Deck
    private let hand: Hand
    
    init(_ deck: Deck, _ hand: Hand) {
        self.deck = deck
        self.hand = hand
    }
    
    var validationActions: [ValidationAction] {
        var actions: [ValidationAction] = []
        
        // NoCardsInHand
        actions.append({
            return self.checkNoCardsInHand(self.deck, self.hand)
        })
        
        // BoundTokenNotFoundInDeck
        // ConsumedTokenBoundToMultipleCards
        actions.append({
            return self.checkTokenBindings(self.deck, self.hand)
        })
        
        // BranchTargetNotSpecified
        actions.append({
            return self.checkBranchTargetNotSpecified(self.deck, self.hand)
        })
        
        // BranchTargetNotFound
        actions.append({
            return self.checkBranchTargetNotFound(self.deck, self.hand)
        })
        
        // MultipleHandLevelBranchesFound
        actions.append({
            return self.checkMultipleHandLevelBranchesFound(self.deck, self.hand)
        })
        
        // CardTreeContainsMultipleBranches
        actions.append({
            return self.checkCardTreeContainsMultipleBranches(self.deck, self.hand)
        })
        
        // SubhandUnreachable
        actions.append({
            return self.checkSubhandUnreachable(self.deck, self.hand)
        })
        
        // HandContainsCircularReference
        actions.append({
            return self.checkHandContainsCircularReference(self.deck, self.hand)
        })
        
        // RepeatCardCountInvalid
        actions.append({
            return self.checkRepeatCardCountInvalid(self.deck, self.hand)
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
    
    func checkMultipleHandLevelBranchesFound(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var handLevelBranches: [CardIdentifier] = []
        
        for card in hand.branchCards {
            if card.targetHandIdentifier == nil {
                handLevelBranches.append(card.identifier)
            }
        }
        
        if handLevelBranches.count > 1 {
            errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .MultipleHandLevelBranchesFound(handLevelBranches)))
        }
        
        return errors
    }
    
    func checkCardTreeContainsMultipleBranches(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        var cardTreeBranches: [CardTreeIdentifier : [CardIdentifier]] = [:]
        
        for card in hand.branchCards {
            guard let source = card.cardTreeIdentifier else { continue }
            guard let target = card.targetHandIdentifier else { continue }
            
            var branches = cardTreeBranches[source] ?? []
            branches.append(target)
            cardTreeBranches[source] = branches
        }
        
        for (cardTree, branchTargets) in cardTreeBranches {
            if branchTargets.count > 1 {
                errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .CardTreeContainsMultipleBranches(cardTree, branchTargets)))
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
    
    func checkHandContainsCircularReference(deck: Deck, _ hand: Hand) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // do iterative DFS to find circular references
        var handStack: [Hand] = []
        handStack.append(hand)
        
        var dfsOrder: [HandIdentifier] = []
        var discoveredHands: Set<HandIdentifier> = Set()
        
        while !handStack.isEmpty {
            let h = handStack.removeLast()
            if !discoveredHands.contains(h.identifier) {
                discoveredHands.insert(h.identifier)
                dfsOrder.append(h.identifier)
                handStack.appendContentsOf(h.subhands)
            } else {
                // check for a cycle
                if let index = dfsOrder.indexOf(h.identifier) {
                    var cycle = Array(dfsOrder[index...dfsOrder.endIndex])
                    cycle.append(h.identifier)
                    
                    // cycle found
                    errors.append(ValidationError.HandError(.Error, deck.identifier, hand.identifier, .HandContainsCircularReference(cycle)))
                }
            }
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
