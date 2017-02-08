//
//  ActionCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: ActionCardDescriptor

public struct ActionCardDescriptor: CardDescriptor, AcceptsInputs, AcceptsTokens, ProducesYields, Satisfiable {
    public let cardType: CardType = .action
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public let inputSlots: [InputSlot]
    public let tokenSlots: [TokenSlot]
    
    public var producesYields: Bool {
        return yields.count > 0
    }
    public let yields: [Yield]
    public let yieldDescription: String
    
    public let ends: Bool
    public let endDescription: String
    
    public init(name: String, subpath: String?, inputs: [InputSlot]?, tokens: [TokenSlot]?, yields: [Yield]?, yieldDescription: String?, ends: Bool, endsDescription: String?, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Action/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Action")
        }
        self.assetCatalog = assetCatalog
        
        self.inputSlots = inputs ?? []
        self.tokenSlots = tokens ?? []
        self.yields = yields ?? []
        self.yieldDescription = yieldDescription ?? ""
        self.ends = ends
        self.endDescription = endsDescription ?? ""
    }
    
    /// Return a new ActionCard instance using our descriptor
    func makeCard() -> ActionCard {
        return ActionCard(with: self)
    }
}

// MARK: Equatable

extension ActionCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same. All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension ActionCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension ActionCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}

// MARK: JSONEncodable

extension ActionCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "cardType": cardType.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "inputSlots": inputSlots.toJSON(),
            "tokenSlots": tokenSlots.toJSON(),
            "yields": yields.toJSON(),
            "yieldDescription": yieldDescription.toJSON(),
            "ends": ends.toJSON(),
            "endDescription": endDescription.toJSON()
            ])
    }
}

// MARK: JSONDecodable

extension ActionCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.path = try json.decode(at: "path", type: CardPath.self)
        self.assetCatalog = try json.decode(at: "assetCatalog", type: CardAssetCatalog.self)
        self.inputSlots = try json.decodedArray(at: "inputSlots", type: InputSlot.self)
        self.tokenSlots = try json.decodedArray(at: "tokenSlots", type: TokenSlot.self)
        self.yields = try json.decodedArray(at: "yields", type: Yield.self)
        self.yieldDescription = try json.getString(at: "yieldDescription")
        self.ends = try json.getBool(at: "ends")
        self.endDescription = try json.getString(at: "endDescription")
    }
}
