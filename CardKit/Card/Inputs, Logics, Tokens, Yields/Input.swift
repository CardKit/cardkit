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

// MARK: - Enumerable

public protocol Enumerable {
    static var values: [Self] { get }
}

// MARK: - StringEnumerable

public protocol StringEnumerable {
    static var stringValues: [String] { get }
}

extension StringEnumerable where Self: RawRepresentable & Enumerable, Self.RawValue == String {
    public static var stringValues: [String] {
        return values.map { $0.rawValue }
    }
}
