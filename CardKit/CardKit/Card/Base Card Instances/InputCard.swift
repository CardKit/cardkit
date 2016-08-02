//
//  InputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct InputCard: Card {
    public let descriptor: InputCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
    
    init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
    
    // input data
    public var inputData: InputBinding?
    
    /// Errors that may occur when binding Input values
    public enum BindingError: ErrorType {
        /// The value is of a data type not currently supported for an Input (see Input.swift)
        case UnsupportedDataType(type: Any.Type)
    }
    
    /// Bind the input data
    mutating func bindInputData<T>(value: T) throws {
        // this is a little silly, but we can't just use Any.Type for our 
        // Inputs because we can't deserialize the type from a string
        switch value {
        case let v as Int:
            self.inputData = .SwiftInt(v)
        case let v as Double:
            self.inputData = .SwiftDouble(v)
        case let v as String:
            self.inputData = .SwiftString(v)
        case let v as NSData:
            self.inputData = .SwiftData(v)
        case let v as NSDate:
            self.inputData = .SwiftDate(v)
        case let v as InputCoordinate2D:
            self.inputData = .Coordinate2D(v)
        case let v as [InputCoordinate2D]:
            self.inputData = .Coordinate2DPath(v)
        case let v as InputCoordinate3D:
            self.inputData = .Coordinate3D(v)
        case let v as [InputCoordinate3D]:
            self.inputData = .Coordinate3DPath(v)
        case let v as InputCardinalDirection:
            self.inputData = .CardinalDirection(v)
        default:
            throw InputCard.BindingError.UnsupportedDataType(type: value.dynamicType)
        }
    }
}

//MARK: JSONDecodable

extension InputCard: JSONDecodable {
    public init(json: JSON) throws {
        self.descriptor = try json.decode("descriptor", type: InputCardDescriptor.self)
        
        do {
            self.inputData = try json.decode("inputData", type: InputBinding.self)
        } catch {
            self.inputData = nil
        }
    }
}

//MARK: JSONEncodable

extension InputCard: JSONEncodable {
    public func toJSON() -> JSON {
        if let inputData = self.inputData {
            return .Dictionary([
                "descriptor": self.descriptor.toJSON(),
                "inputData": inputData.toJSON()
                ])
        } else {
            return .Dictionary(["descriptor": self.descriptor.toJSON()])
        }
    }
}
