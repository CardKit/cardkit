//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: HandCardDescriptor

public struct HandCardDescriptor: CardDescriptor {
    public let cardType: CardType = .hand
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public let handCardType: HandCardType
    
    public init(name: String, subpath: String?, handCardType: HandCardType, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Hand/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Hand")
        }
        self.assetCatalog = assetCatalog
        
        self.handCardType = handCardType
    }
    
    /// Return a new instance of the HandCard.
    func makeCard() -> HandCard {
        switch self.handCardType {
        case .branch:
            return BranchHandCard(with: self)
        case .repeatHand:
            return RepeatHandCard(with: self)
        case .endWhenAnySatisfied:
            return EndRuleHandCard(with: self)
        case .endWhenAllSatisfied:
            return EndRuleHandCard(with: self)
        case .booleanLogicAnd, .booleanLogicOr, .booleanLogicNot:
            return LogicHandCard(with: self)
        }
    }
    
    /// Return a new, subtyped HandCard instance. This method is generic to enable callers to obtain the 
    /// correctly-typed subclass of HandCard based on the cardType of this descriptor. For example, this 
    /// is how one would obtain a RepeatHandCard instance from the Repeat card descriptor.
    ///
    /// `guard let card: RepeatHandCard = CardKit.Hand.Next.Repeat.makeCard() else { // should not fail }`
    ///
    /// In case of a type mismatch, nil will be returned. For example, trying to obtain a RepeatHandCard
    /// from a descriptor of type End Rule:
    ///
    /// `guard let card: RepeatHandCard = CardKit.Hand.End.All.makeCard() else { // will always fail }`
    ///
    /// Also, when using this method, the type of the variable being assigned must always be specified, otherwise
    /// the compiler will not be able to infer the type.
    func typedInstance<T>() -> T? {
        switch self.handCardType {
        case .branch:
            return BranchHandCard(with: self) as? T
        case .repeatHand:
            return RepeatHandCard(with: self) as? T
        case .endWhenAnySatisfied:
            return EndRuleHandCard(with: self) as? T
        case .endWhenAllSatisfied:
            return EndRuleHandCard(with: self) as? T
        case .booleanLogicAnd, .booleanLogicOr, .booleanLogicNot:
            return LogicHandCard(with: self) as? T
        }
    }
}

// MARK: Equatable

extension HandCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same. All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: HandCardDescriptor, rhs: HandCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension HandCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension HandCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}

// MARK: JSONEncodable

extension HandCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "cardType": cardType.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "handCardType": handCardType.toJSON()
            ])
    }
}

// MARK: JSONDecodable

extension HandCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.path = try json.decode(at: "path", type: CardPath.self)
        self.assetCatalog = try json.decode(at: "assetCatalog", type: CardAssetCatalog.self)
        self.handCardType = try json.decode(at: "handCardType", type: HandCardType.self)
    }
}
