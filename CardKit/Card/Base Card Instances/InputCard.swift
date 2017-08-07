//
//  InputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class InputCard: Card, Codable {
    public let descriptor: InputCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // input data
    public var boundData: Data?
    
    public init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
    
    public init(with descriptor: InputCardDescriptor, boundData: Data) {
        self.descriptor = descriptor
        self.boundData = boundData
    }
}

// MARK: Equatable

extension InputCard: Equatable {
    static public func == (lhs: InputCard, rhs: InputCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension InputCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

// MARK: Binding

extension InputCard {
    /// Errors that may occur when binding Input values
    public enum BindingError: Error {
        /// The value is of a data type not currently supported for an Input (see Input.swift)
        case unsupportedDataType(type: Any.Type)
        
        /// The value given for a binding does not match the expected type for the InputCard
        case bindingTypeMismatch(given: String, expected: String)
    }
    
    /// Encodes the given value as Data. Throws an error if the type of the given
    /// value doesn't match the type expected by this InputCard.
    fileprivate func boundValue<T>(_ value: T) throws -> Data where T : Codable {
        // make sure the type of the value matches the type expected by the descriptor
        let givenType = String(describing: type(of: value))
        let expectedType = self.descriptor.inputType
        
        if givenType != expectedType {
            throw InputCard.BindingError.bindingTypeMismatch(given: givenType, expected: expectedType)
        }
        
        // bind the value
        let encoder = JSONEncoder()
        do {
            let boundValue = try encoder.encode(value)
            return boundValue
        } catch {
            throw InputCard.BindingError.unsupportedDataType(type: Swift.type(of: value))
        }
    }
    
    /// Bind the given value to this InputCard.
    func bind<T>(withValue value: T) throws where T : Codable {
        self.boundData = try self.boundValue(value)
    }
    
    /// Returns a new InputCard with the given value bound to it.
    public func bound<T>(withValue value: T) throws -> InputCard where T : Codable {
        let data = try self.boundValue(value)
        return InputCard(with: self.descriptor, boundData: data)
    }
    
    /// Returns true if data has been bound to this InputCard.
    public func isBound() -> Bool {
        return self.boundData != nil
    }
}
