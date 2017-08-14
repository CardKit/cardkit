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
    
    /// The data bound to this Input card, seralized in a box of type `Dictionary<String, T>` where `T`
    /// is the type of the data bound to the card. The bound value is contained in the dictionary under
    /// the key "value". For example, a bound integer with a value of 1 would be stored in the box
    /// `["value": 1]`. The box is used because `JSONEncoder` doesn't handle primitive types.
    public fileprivate (set) var boundData: Data?
    
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
    fileprivate func bindingValue<T>(_ value: T) throws -> Data where T : Codable {
        // make sure the type of the value matches the type expected by the descriptor
        let givenType = String(describing: Swift.type(of: value))
        let expectedType = self.descriptor.inputType
        
        if givenType != expectedType {
            throw InputCard.BindingError.bindingTypeMismatch(given: givenType, expected: expectedType)
        }
        
        // bind the value -- need to put it in a box because the JSONEncoder can't encode primitive values
        guard let boxedValue = value.boxedEncoding() else {
            throw InputCard.BindingError.unsupportedDataType(type: Swift.type(of: value))
        }
        
        return boxedValue
    }
    
    /// Bind the given value to this InputCard.
    func bind<T>(withValue value: T) throws where T : Codable {
        self.boundData = try self.bindingValue(value)
    }
    
    /// Returns a new InputCard with the given value bound to it.
    public func bound<T>(withValue value: T) throws -> InputCard where T : Codable {
        let data = try self.bindingValue(value)
        return InputCard(with: self.descriptor, boundData: data)
    }
    
    /// Returns true if data has been bound to this InputCard.
    public func isBound() -> Bool {
        return self.boundData != nil
    }
    
    /// Returns the value bound to this card, or nil if no value has been bound or
    /// if the type expected by the caller doesn't match the type actually stored in
    /// the binding.
    public func boundValue<T>() -> T? where T : Codable {
        guard let boundData = self.boundData else { return nil }
        guard let boundValue: T = boundData.unboxedValue() else { return nil }
        return boundValue
    }
}
