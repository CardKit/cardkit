//
//  CardValidator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

class CardValidator: Validator {
    func validationActions() -> [ValidationAction] {
        var actions: [ValidationAction] = []
        
        // CardDescriptorTypeDoesNotMatchInstanceType
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            return self.checkCardDescriptorTypeDoesNotMatchInstanceType(deck, hand, card)
        })
        
        // CheckTokenSlotNotBound
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to ActionCards
            guard let actionCard = card as? ActionCard else { return [] }
            return self.checkTokenSlotNotBound(deck, hand, actionCard)
        })
        
        // BoundTokenCardNotPresentInDeck
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to ActionCards
            guard let actionCard = card as? ActionCard else { return [] }
            return self.checkBoundTokenCardNotPresentInDeck(deck, hand, actionCard)
        })
        
        // MandatoryInputSlotNotBound
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to ActionCards
            guard let actionCard = card as? ActionCard else { return [] }
            return self.checkMandatoryInputSlotNotBound(deck, hand, actionCard)
        })
        
        // InputSlotBoundToUnexpectedType
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to ActionCards
            guard let actionCard = card as? ActionCard else { return [] }
            return self.checkInputSlotBoundToUnexpectedType(deck, hand, actionCard)
        })
        
        // BranchTargetNotFound
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to HandCards
            guard let handCard = card as? HandCard else { return [] }
            return self.checkBranchTargetNotFound(deck, hand, handCard)
        })
        
        // LogicCardHasIncorrectNumberOfChildren
        actions.append({
            (deck, hand, card) in
            guard let hand = hand else { return [] }
            guard let card = card else { return [] }
            
            // only applies to HandCards
            guard let handCard = card as? HandCard else { return [] }
            return self.checkLogicCardHasIncorrectNumberOfChildren(deck, hand, handCard)
        })
        
        return actions
    }
    
    func checkCardDescriptorTypeDoesNotMatchInstanceType(deck: Deck, _ hand: Hand, _ card: Card) -> [ValidationError] {
        switch card.cardType {
        case .Action:
            guard let _ = card as? ActionCard else {
                return [ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .CardDescriptorTypeDoesNotMatchInstanceType(.Action, card.dynamicType))]
            }
        case .Deck:
            guard let _ = card as? DeckCard else {
                return [ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .CardDescriptorTypeDoesNotMatchInstanceType(.Deck, card.dynamicType))]
            }
        case .Hand:
            guard let _ = card as? HandCard else {
                return [ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .CardDescriptorTypeDoesNotMatchInstanceType(.Hand, card.dynamicType))]
            }
        case .Input:
            guard let _ = card as? InputCard else {
                return [ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .CardDescriptorTypeDoesNotMatchInstanceType(.Input, card.dynamicType))]
            }
        case .Token:
            guard let _ = card as? TokenCard else {
                return [ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .CardDescriptorTypeDoesNotMatchInstanceType(.Token, card.dynamicType))]
            }
        }
        
        // success!
        return []
    }
    
    func checkTokenSlotNotBound(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for tokenSlot in card.tokenSlots {
            if !card.isSlotBound(tokenSlot) {
                errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .TokenSlotNotBound(tokenSlot)))
            }
        }
        
        return errors
    }
    
    func checkBoundTokenCardNotPresentInDeck(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for tokenSlot in card.tokenSlots {
            // this is the TokenCard bound to the slot
            guard let boundTokenCard = card.cardBound(to: tokenSlot) else { break }
            
            // make sure that token is part of the Deck's tokenCards
            let found = deck.tokenCards.reduce(false) {
                (ret, token) in ret || token.identifier == boundTokenCard.identifier
            }
            
            if !found {
                errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .BoundTokenCardNotPresentInDeck(boundTokenCard.identifier)))
            }
        }
        
        return errors
    }
    
    func checkMandatoryInputSlotNotBound(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        return errors
    }
    
    func checkInputSlotBoundToUnexpectedType(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        return errors
    }
    
    func checkBranchTargetNotFound(deck: Deck, _ hand: Hand, _ card: HandCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        return errors
    }
    
    func checkLogicCardHasIncorrectNumberOfChildren(deck: Deck, _ hand: Hand, _ card: HandCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        return errors
    }
}
