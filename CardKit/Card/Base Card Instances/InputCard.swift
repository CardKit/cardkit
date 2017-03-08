//
//  InputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public class InputCard: Card, JSONEncodable, JSONDecodable {
    public let descriptor: InputCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // input data
    public var boundData: DataBinding = .unbound
    
    public init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
    
    public init(with descriptor: InputCardDescriptor, boundData: DataBinding) {
        self.descriptor = descriptor
        self.boundData = boundData
    }
    
    // MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode(at: "descriptor", type: InputCardDescriptor.self)
        self.boundData = try json.decode(at: "boundData", type: DataBinding.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "boundData": boundData.toJSON()
            ])
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
    
    /// Convert the given value to a DataBinding. Throws an error if the type of the given
    /// value doesn't match the type expected by this InputCard.
    fileprivate func boundValue<T>(_ value: T) throws -> DataBinding {
        // make sure the type of the value matches the type expected by the descriptor
        let givenType = String(describing: type(of: value))
        let expectedType = self.descriptor.inputType
        
        if givenType != expectedType {
            throw InputCard.BindingError.bindingTypeMismatch(given: givenType, expected: expectedType)
        }
        
        // bind the value
        if let v = value as? JSONEncodable {
            return .bound(v.toJSON())
        } else {
            throw InputCard.BindingError.unsupportedDataType(type: type(of: value))
        }
    }
    
    /// Bind the given value to this InputCard.
    func bind<T>(withValue value: T) throws {
        self.boundData = try self.boundValue(value)
    }
    
    /// Returns a new InputCard with the given value bound to it.
    public func bound<T>(withValue value: T) throws -> InputCard {
        let data = try self.boundValue(value)
        return InputCard(with: self.descriptor, boundData: data)
    }
    
    /// Return the data value bound to the input. Returns nil if no data has yet been bound.
    public func inputDataValue<T>() -> T? where T : JSONDecodable {
        switch self.boundData {
        case .unbound:
            return nil
        case .bound(let val):
            do {
                return try T(json: val)
            } catch {
                return nil
            }
        }
    }
    
    /// Returns true if data has been bound to this InputCard.
    public func isBound() -> Bool {
        if case .unbound = self.boundData {
            return false
        } else {
            return true
        }
    }
}
