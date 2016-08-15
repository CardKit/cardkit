//
//  ValidationError.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

//MARK: ValidationSeverity

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
