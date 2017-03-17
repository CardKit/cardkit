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

// MARK: - EnumerableAsString
public protocol EnumerableEnum {
    static var values: [Self] { get }
}


public protocol EnumerableAsString {
    static var stringValues: [String] { get }
}

extension EnumerableAsString where Self: RawRepresentable & EnumerableEnum, Self.RawValue == String {
    public static var stringValues: [String] {
        return values.map { $0.rawValue }
    }
}
