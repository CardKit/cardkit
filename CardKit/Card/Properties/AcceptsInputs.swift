//
//  AcceptsInputs.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public typealias CardInputs = [String: InputCardDescriptor]

protocol AcceptsInputs {
    var mandatoryInputs: CardInputs { get }
    var optionalInputs: CardInputs { get }
}
