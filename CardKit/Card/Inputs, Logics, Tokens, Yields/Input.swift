//
//  Input.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: - InputType
public typealias InputType = (JSONEncodable & JSONDecodable).Type

// MARK: - EnumerableEnum
public protocol EnumerableEnum {
    static var allValues: [Self] { get }
}

// MARK: - InputProtocol
public enum InputDetails {
    case none
    case supportedUnits([String])
    case choices([String])
}

public protocol InputProtocol {
    static var inputDetails: [InputDetails] { get }
}

extension InputProtocol {
    public static var inputDetails: [InputDetails] {
        return [.none]
    }
}

// MARK: - InputProtocol Extensions for Basic Types
extension Bool: InputProtocol {
    public static var InputProtocol: [InputDetails] {
        return [.choices(["True", "False"])]
    }
}

// These fall back to the default implementation of
// inputDetails (see extension of InputProtocol)
extension Data: InputProtocol {}

extension String: InputProtocol {}

extension Int: InputProtocol {}

extension Double: InputProtocol {}

extension Date: InputProtocol {}
