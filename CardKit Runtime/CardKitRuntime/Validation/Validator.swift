//
//  Validator.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

public typealias ValidationAction = () -> [ValidationError]

public protocol Validator {
    var validationActions: [ValidationAction] { get }
}
