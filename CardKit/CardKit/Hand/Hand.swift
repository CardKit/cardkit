//
//  Hand.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct Hand {
    public var cards: [Card]
    
    public let identifier: HandIdentifier
    
    init() {
        self.init(cards: [])
    }
    
    init(cards: [Card]) {
        self.cards = cards
        self.identifier = HandIdentifier()
    }
}

//MARK: JSONDecodable

extension Hand: JSONDecodable {
    public init(json: JSON) throws {
        self.cards = []
        
        let cards: [JSON] = try json.array("cards")
        for card in cards {
            guard let descriptor: JSON = card["descriptor"] else { continue }
            let cardType: CardType = try descriptor.decode("cardType", type: CardType.self)
            switch cardType {
            case .Action:
                let actionCard = try ActionCard(json: card)
                self.cards.append(actionCard)
            case .Deck:
                let deckCard = try DeckCard(json: card)
                self.cards.append(deckCard)
            case .Hand:
                let handCard = try HandCard(json: card)
                self.cards.append(handCard)
            case .Input:
                let inputCard = try ActionCard(json: card)
                self.cards.append(inputCard)
            case .Token:
                let tokenCard = try TokenCard(json: card)
                self.cards.append(tokenCard)
            }
        }
        
        self.identifier = try json.decode("identifier", type: HandIdentifier.self)
    }
}

//MARK: JSONEncodable

extension Hand: JSONEncodable {
    public func toJSON() -> JSON {
        var jsonCards: [JSON] = []
        
        for card in self.cards {
            switch card.cardType {
            case .Action:
                if let c = card as? ActionCard {
                    jsonCards.append(c.toJSON())
                }
            case .Deck:
                if let c = card as? DeckCard {
                    jsonCards.append(c.toJSON())
                }
            case .Hand:
                if let c = card as? HandCard {
                    jsonCards.append(c.toJSON())
                }
            case .Input:
                if let c = card as? InputCard {
                    jsonCards.append(c.toJSON())
                }
            case .Token:
                if let c = card as? TokenCard {
                    jsonCards.append(c.toJSON())
                }
            }
        }
        
        return .Dictionary([
            "cards": .Array(jsonCards),
            "identifier": self.identifier.toJSON(),
            ])
    }
}
