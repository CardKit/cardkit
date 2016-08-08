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
    case MandatoryInputIsMissing(InputSlot)
}

//MARK:- CardValidator

public class CardValidator {
    private let card: Card
    
    init(with card: Card) {
        self.card = card
    }
}
