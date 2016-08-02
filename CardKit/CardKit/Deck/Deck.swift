//
//  Deck.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct Deck {
    public var hands: [Hand]
    
    /// Specifies whether execution should loop back to the first hand
    /// or terminate once all the hands have executed
    public var conclusionAction: DeckConclusionAction
    
    init(with hands: [Hand], onConclusion conclusionAction: DeckConclusionAction) {
        self.hands = hands
        self.conclusionAction = conclusionAction
    }
    
    init(with hands: [Hand]) {
        self.init(with: hands, onConclusion: .Repeat)
    }
}

//MARK: JSONDecodable

extension Deck: JSONDecodable {
    public init(json: JSON) throws {
        self.hands = try json.arrayOf("hands", type: Hand.self)
        self.conclusionAction = try json.decode("conclusionAction", type: DeckConclusionAction.self)
    }
}

//MARK: JSONEncodable

extension Deck: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "hands": self.hands.toJSON(),
            "conclusionAction": self.conclusionAction.toJSON(),
            ])
    }
}
