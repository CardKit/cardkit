//
//  CardValidator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

//MARK: CardValidationError

public enum CardValidationError {
    /// The type of the Card Descriptor does not match the type of the Card Instance (args: expected type, actual type)
    // swiftlint:disable:next type_name
    case CardDescriptorTypeDoesNotMatchInstanceType(CardType, Any.Type)
    
    /// The TokenSlot has not been bound with a Token card
    case TokenSlotNotBound(TokenSlot)
    
    /// The Token card bound to this card was not found in the Deck
    case BoundTokenCardNotPresentInDeck(CardIdentifier)
    
    /// The TokenSlot was bound to a card that is not a TokenCard (args: the token slot, the identifier of the non-Token card to which it was bound)
    case TokenSlotNotBoundToTokenCard(TokenSlot, CardIdentifier)
    
    /// The TokenSlot is bound, but has an Unbound value.
    case TokenSlotBoundToUnboundValue(TokenSlot)
    
    /// The InputSlot is non-optional but does not have an InputCard bound to it
    case MandatoryInputSlotNotBound(InputSlot)
    
    /// The InputSlot is bound, but has an Unbound value.
    case InputSlotBoundToUnboundValue(InputSlot)
    
    /// The InputSlot expected a different type of input than that provided by the InputCard (args: slot, expected type, bound InputCard identifier, provided type)
    case InputSlotBoundToUnexpectedType(InputSlot, InputType, CardIdentifier, InputType)
    
    /// The InputSlot was bound to an invalid Card type (Deck, Hand, or Token)
    case InputSlotBoundToInvalidCardType(InputSlot, InputType, CardIdentifier, CardType)
}

//MARK: CardValidator

class CardValidator: Validator {
    private let deck: Deck
    private let hand: Hand
    private let card: Card
    
    init(_ deck: Deck, _ hand: Hand, _ card: Card) {
        self.deck = deck
        self.hand = hand
        self.card = card
    }
    
    var validationActions: [ValidationAction] {
        var actions: [ValidationAction] = []
        
        // CardDescriptorTypeDoesNotMatchInstanceType
        actions.append({
            return self.checkCardDescriptorTypeDoesNotMatchInstanceType(self.deck, self.hand, self.card)
        })
        
        // TokenSlotNotBound
        actions.append({
            // only applies to ActionCards
            guard let actionCard = self.card as? ActionCard else { return [] }
            return self.checkTokenSlotNotBound(self.deck, self.hand, actionCard)
        })
        
        // BoundTokenCardNotPresentInDeck
        actions.append({
            // only applies to ActionCards
            guard let actionCard = self.card as? ActionCard else { return [] }
            return self.checkBoundTokenCardNotPresentInDeck(self.deck, self.hand, actionCard)
        })
        
        // TokenSlotNotBoundToTokenCard
        // TokenSlotBoundToUnboundValue
        actions.append({
            // only applies to ActionCards
            guard let actionCard = self.card as? ActionCard else { return [] }
            return self.checkTokenSlotNotBoundToTokenCard(self.deck, self.hand, actionCard)
        })
        
        // MandatoryInputSlotNotBound
        actions.append({
            // only applies to ActionCards
            guard let actionCard = self.card as? ActionCard else { return [] }
            return self.checkMandatoryInputSlotNotBound(self.deck, self.hand, actionCard)
        })
        
        // InputSlotBoundToUnboundValue
        // InputSlotBoundToUnexpectedType
        // InputSlotBoundToInvalidCardType
        actions.append({
            // only applies to ActionCards
            guard let actionCard = self.card as? ActionCard else { return [] }
            return self.checkInputSlotBindings(self.deck, self.hand, actionCard)
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
            guard let identifier = card.cardIdentifierBound(to: tokenSlot) else { break }
            
            // make sure that token is part of the Deck's tokenCards
            let found = deck.tokenCards.reduce(false) {
                (ret, token) in ret || token.identifier == identifier
            }
            
            if !found {
                errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .BoundTokenCardNotPresentInDeck(identifier)))
            }
        }
        
        return errors
    }
    
    func checkTokenSlotNotBoundToTokenCard(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for slot in card.tokenSlots {
            // unbound inputs are caught by another validation function
            let binding = card.binding(of: slot)
            switch binding {
            case .Unbound:
                // should never be the case
                errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .TokenSlotBoundToUnboundValue(slot)))
            case .BoundToTokenCard(let identifier):
                // find this card in the deck
                let found = deck.tokenCards.reduce(false) {
                    (ret, token) in ret || token.identifier == identifier
                }
                
                if !found {
                    errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .TokenSlotNotBoundToTokenCard(slot, identifier)))
                }
            }
        }
        
        return errors
    }
    
    func checkMandatoryInputSlotNotBound(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for slot in card.inputSlots {
            // !slot.isOptional && !card.isSlotBound(slot) is causing the swift compiler to freak out because of the &&. which makes no sense, because both sides of that are Bool.
            if !slot.isOptional {
                if !card.isSlotBound(slot) {
                    errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .MandatoryInputSlotNotBound(slot)))
                }
            }
        }
    
        return errors
    }
    
    func checkInputSlotBindings(deck: Deck, _ hand: Hand, _ card: ActionCard) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        for slot in card.inputSlots {
            // if there is no card bound to a mandatory slot, we would have already checked for this
            guard let binding = card.binding(of: slot) else { continue }
            let expectedType = slot.inputType
            
            switch binding {
            case .Unbound:
                errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .InputSlotBoundToUnboundValue(slot)))
            case .BoundToInputCard(let inputCard):
                // make sure the InputCard's data type matches the expected type
                let actualType = inputCard.descriptor.inputType
                if expectedType != actualType {
                    errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .InputSlotBoundToUnexpectedType(slot, expectedType, inputCard.identifier, actualType)))
                }
            case .BoundToYieldingActionCard(let identifier, let yield):
                // make sure the ActionCard's Yield type matches the expected type
                let actualType = yield.type
                if expectedType != actualType {
                    errors.append(ValidationError.CardError(.Error, deck.identifier, hand.identifier, card.identifier, .InputSlotBoundToUnexpectedType(slot, expectedType, identifier, actualType)))
                }
            }
        }
        
        return errors
    }
}
