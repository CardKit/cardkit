//
//  InputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class InputCard {
    public let descriptor: InputCardDescriptor
    
    init(with descriptor: InputCardDescriptor) {
        self.descriptor = descriptor
    }
    
    // yields
    var yieldData: [Yield : YieldBinding] = [:]
    
    /// Errors that may occur when binding Input values
    public enum BindingError: ErrorType {
        /// The value is of a data type not currently supported for a Yield (see Yield.swift)
        case UnsupportedDataType(type: Any.Type)
    }
    
    /// Bind the yield data to our only yield (Input cards have only one yield).
    func bindYieldData<T>(value: T) throws {
        guard let yield = self.descriptor.yields.first else { return }
        var yieldValue: YieldBinding? = nil
        
        // this is a little silly, but we can't just use Any.Type for our yields because
        // we can't deserialize the type from a string
        switch value.dynamicType {
        case Int:
            self.yieldData[yield] = .SwiftInt(value)
        case Double:
            self.yieldData[yield] = .SwiftDouble(value)
        case String:
            self.yieldData[yield] = .SwiftString(value)
        case NSData:
            self.yieldData[yield] = .SwiftData(value)
        case NSDate:
            self.yieldData[yield] = .SwiftDate(value)
        case YieldCoordinate2D:
            self.yieldData[yield] = .YieldCoordinate2D(value)
        case YieldCoordinate2DPath:
            self.yieldData[yield] = .YieldCoordinate2DPath(value)
        case YieldCoordinate3D:
            self.yieldData[yield] = .YieldCoordinate3D(value)
        case YieldCoordinate3DPath:
            self.yieldData[yield] = .YieldCoordinate3DPath(value)
        case YieldCardinalDirection:
            self.yieldData[yield] = .YieldCardinalDirection(value)
        default:
            throw InputCard.BindingError.UnsupportedDataType(type: value.dynamicType)
        }
    }
}

//MARK:- Card

extension InputCard: Card {
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
}

//MARK:- ImplementsProducesYields

extension InputCard: ImplementsProducesYields {
    func getYieldValue(from yield: Yield) -> YieldBinding? {
        if let data = self.yieldData[yield] {
            return data
        } else {
            return nil
        }
    }
    
    func getAllYieldValues() -> [YieldBinding]? {
        if self.yieldData.count == 0 {
            return nil
        }
        
        return Array(self.yieldData.values)
    }
}
