//
//  ValidationError.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

//MARK: ValidationLevel

public enum ValidationSeverity: String {
    case Error
    case Warning
}

extension ValidationSeverity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Error:
            return "Error"
        case .Warning:
            return "Warning"
        }
    }
}

//MARK: ValidationError

public enum ValidationError {
    case DeckError(ValidationSeverity, DeckIdentifier, DeckValidationError)
    case HandError(ValidationSeverity, DeckIdentifier, HandIdentifier, HandValidationError)
    case CardError(ValidationSeverity, DeckIdentifier, HandIdentifier, CardIdentifier, CardValidationError)
}

//MARK: DeckValidationError

public enum DeckValidationError {
    /// No cards were present in the deck
    case NoDeckCardPresent
    
    /// No hands were present in the deck
    case NoHandsInDeck
    
    /// Multiple hands were found in the Deck sharing the same HandIdentifier
    case MultipleHandsWithSameIdentifier(HandIdentifier)
    
    /// A card was placed into multiple hands (args: Card identifier, set of hands in which the card was found)
    case CardUsedInMultipleHands(CardIdentifier, [HandIdentifier])
    
    /// A Card and a Hand were found sharing the same identifier (equivalent String values)
    case CardAndHandShareSameIdentifier(HandIdentifier, CardIdentifier)
}

//MARK: HandValidationError

public enum HandValidationError {
    /// No cards were present in the hand
    case NoCardsInHand
    
    /// A consumed token was bound to multiple cards (args: TokenCard identifier, set of card identifiers to which the token was bound)
    case ConsumedTokenBoundToMultipleCards(CardIdentifier, [CardIdentifier])
}

//MARK: CardValidationError

public enum CardValidationError {
    /// The type of the Card Descriptor does not match the type of the Card Instance (args: expected type, actual type)
    // swiftlint:disable:next type_name
    case CardDescriptorTypeDoesNotMatchInstanceType(CardType, Any.Type)
    
    /// The TokenSlot has not been bound with a Token card
    case TokenSlotNotBound(TokenSlot)
    
    /// The Token card bound to this card was not found in the Deck
    case BoundTokenCardNotPresentInDeck(CardIdentifier)
    
    /// The InputSlot is non-optional but does not have an InputCard bound to it
    case MandatoryInputSlotNotBound(InputSlot)
    
    /// The InputSlot expected a different type of input than that provided by the InputCard (args: slot, expected type, bound InputCard identifier, provided type)
    case InputSlotBoundToUnexpectedType(InputSlot, InputType, CardIdentifier, InputType)
    
    /// The target of the branch was not found in the Deck (args: branch target HandIdentifier)
    case BranchTargetNotFound(HandIdentifier)
    
    /// The HandCard logic has an incorrect number of children (args: expected number, actual number). AND and OR cards expect two or more children; NOT cards expect one child.
    case LogicCardHasIncorrectNumberOfChildren(Int, Int)
}
