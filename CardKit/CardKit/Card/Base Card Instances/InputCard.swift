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
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // input data
    public var inputData: InputBinding?
    
    init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
    
    init(with descriptor: InputCardDescriptor, inputData: InputBinding) {
        self.descriptor = descriptor
        self.inputData = inputData
    }
    
    //MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: InputCardDescriptor.self)
        
        do {
            self.inputData = try json.decode("inputData", type: InputBinding.self)
        } catch {
            self.inputData = nil
        }
    }
    
    public func toJSON() -> JSON {
        if let inputData = self.inputData {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "inputData": inputData.toJSON()
                ])
        } else {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON()])
        }
    }
}

//MARK: Equatable

extension InputCard: Equatable {}

public func == (lhs: InputCard, rhs: InputCard) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension InputCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: Binding

extension InputCard {
    /// Errors that may occur when binding Input values
    public enum BindingError: ErrorType {
        /// The value is of a data type not currently supported for an Input (see Input.swift)
        case UnsupportedDataType(type: Any.Type)
        
        /// The value given for a binding does not match the expected type for the InputCard
        case BindingTypeMismatch(given: InputType, expected: InputType)
    }
    
    /// Bind the input data
    private func boundValue<T>(value: T) throws -> InputBinding {
        
        // make sure the type of the value matches the type expected by the descriptor
        func throwIfTypesDisagree(given: InputType, _ expected: InputType) throws {
            if given != expected {
                throw InputCard.BindingError.BindingTypeMismatch(given: given, expected: expected)
            }
        }
        
        // this is a little silly, but we can't just use Any.Type for our
        // Inputs because we can't deserialize the type from a string
        switch value {
        case let v as Int:
            try throwIfTypesDisagree(.SwiftInt, self.descriptor.inputType)
            return .SwiftInt(v)
        case let v as Double:
            try throwIfTypesDisagree(.SwiftDouble, self.descriptor.inputType)
            return .SwiftDouble(v)
        case let v as String:
            try throwIfTypesDisagree(.SwiftString, self.descriptor.inputType)
            return .SwiftString(v)
        case let v as NSData:
            try throwIfTypesDisagree(.SwiftData, self.descriptor.inputType)
            return .SwiftData(v)
        case let v as NSDate:
            try throwIfTypesDisagree(.SwiftDate, self.descriptor.inputType)
            return .SwiftDate(v)
        case let v as InputCoordinate2D:
            try throwIfTypesDisagree(.Coordinate2D, self.descriptor.inputType)
            return .Coordinate2D(v)
        case let v as [InputCoordinate2D]:
            try throwIfTypesDisagree(.Coordinate2DPath, self.descriptor.inputType)
            return .Coordinate2DPath(v)
        case let v as InputCoordinate3D:
            try throwIfTypesDisagree(.Coordinate3D, self.descriptor.inputType)
            return .Coordinate3D(v)
        case let v as [InputCoordinate3D]:
            try throwIfTypesDisagree(.Coordinate3DPath, self.descriptor.inputType)
            return .Coordinate3DPath(v)
        case let v as InputCardinalDirection:
            try throwIfTypesDisagree(.CardinalDirection, self.descriptor.inputType)
            return .CardinalDirection(v)
        default:
            throw InputCard.BindingError.UnsupportedDataType(type: value.dynamicType)
        }
    }
    
    func bind<T>(withValue value: T) throws {
        self.inputData = try self.boundValue(value)
    }
    
    public func bound<T>(withValue value: T) throws -> InputCard {
        let inputData = try self.boundValue(value)
        return InputCard(with: self.descriptor, inputData: inputData)
    }
    
    /// Return the data value bound to the input. Returns nil if no data has yet been bound.
    public func inputDataValue<T>() -> T? {
        if let inputData = self.inputData {
            switch inputData {
            case .SwiftInt(let val):
                if let ret = val as? T { return ret }
            case .SwiftDouble(let val):
                if let ret = val as? T { return ret }
            case .SwiftString(let val):
                if let ret = val as? T { return ret }
            case .SwiftData(let val):
                if let ret = val as? T { return ret }
            case .SwiftDate(let val):
                if let ret = val as? T { return ret }
            case .Coordinate2D(let val):
                if let ret = val as? T { return ret }
            case .Coordinate2DPath(let val):
                if let ret = val as? T { return ret }
            case .Coordinate3D(let val):
                if let ret = val as? T { return ret }
            case .Coordinate3DPath(let val):
                if let ret = val as? T { return ret }
            case .CardinalDirection(let val):
                if let ret = val as? T { return ret }
            }
        }
        
        return nil
    }
    
    /// Returns true if data has been bound to this InputCard.
    public func isBound() -> Bool {
        return self.inputData != nil
    }
}
