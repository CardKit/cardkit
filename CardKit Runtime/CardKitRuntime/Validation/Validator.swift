//
//  Validator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

public typealias ValidationAction = (Deck, Hand?, Card?) -> [ValidationError]

public protocol Validator {
    func validationActions() -> [ValidationAction]
}
