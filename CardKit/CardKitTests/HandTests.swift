//
//  HandTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/4/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

class HandTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHandUniqueness() {
        let h1 = Hand()
        let h2 = Hand()
        XCTAssertTrue(h1 == h1)
        XCTAssertTrue(h2 == h2)
        XCTAssertTrue(h1 != h2)
    }
    
    func testHandAdd() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        hand.add(noAction)
        
        XCTAssertTrue(hand.actionCards.count == 1)
        XCTAssertTrue(hand.handCards.count == 0)
        XCTAssertTrue(hand.cardCount == 1)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        XCTAssertTrue(hand.actionCards.count == 1)
        XCTAssertTrue(hand.handCards.count == 1)
        XCTAssertTrue(hand.cardCount == 2)
    }
    
    func testHandRemove() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        hand.add(noAction)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        XCTAssertTrue(hand.cardCount == 2)
        
        hand.remove(rep)
        
        XCTAssertTrue(hand.cardCount == 1)
        
        hand.remove(noAction)
        
        XCTAssertTrue(hand.cardCount == 0)
    }
    
    func testCardMembership() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        
        XCTAssertTrue(!hand.contains(noAction))
        
        hand.add(noAction)
        
        XCTAssertTrue(hand.contains(noAction))
        
        hand.remove(noAction)
        
        XCTAssertTrue(!hand.contains(noAction))
    }
    
    func testHandMultipleAdd() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        hand.add(noAction)
        hand.add(noAction)
        hand.add(noAction)
        
        XCTAssertTrue(hand.actionCards.count == 1)
        XCTAssertTrue(hand.handCards.count == 0)
        XCTAssertTrue(hand.cardCount == 1)
    }
    
    func testHandLogicAnd() {
        // test that AND is functioning correctly
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        guard let and = CardKit.Hand.Logic.LogicalAnd.instance() as? BinaryLogicHandCard else {
            XCTFail("LogicalAnd.instance() did not return a LogicHandCard")
            return
        }
        
        and.lhs = noActionA.identifier
        and.rhs = noActionB.identifier
        
        // test that the deck builder is adding an AND card
        let hand = noActionA && noActionB
        XCTAssertTrue(hand.cardCount == 3)
        let andCards = hand.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 1)
        
        guard let first = andCards.first as? BinaryLogicHandCard else {
            XCTFail("should have a BinaryLogicHandCard in the hand")
            return
        }
        
        XCTAssertTrue(first.descriptor.operation == .BooleanLogicAnd)
        XCTAssertTrue(first.lhs == noActionA.identifier)
        XCTAssertTrue(first.rhs == noActionB.identifier)
    }
    
    func testHandLogicOr() {
        // test that OR is functioning correctly
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        guard let or = CardKit.Hand.Logic.LogicalOr.instance() as? BinaryLogicHandCard else {
            XCTFail("LogicalOr.instance() did not return a BinaryLogicHandCard")
            return
        }
        
        or.lhs = noActionA.identifier
        or.rhs = noActionB.identifier
        
        // test that the deck builder is adding an OR card
        let hand = noActionA || noActionB
        XCTAssertTrue(hand.cardCount == 3)
        let orCards = hand.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 1)
        
        guard let first = orCards.first as? BinaryLogicHandCard else {
            XCTFail("should have a LogicHandCard in the hand")
            return
        }
        XCTAssertTrue(first.descriptor.operation == .BooleanLogicOr)
        XCTAssertTrue(first.lhs == noActionA.identifier)
        XCTAssertTrue(first.rhs == noActionB.identifier)
    }
    
    func testHandLogicNot() {
        // test that NOT is functioning correctly
        let noAction = CardKit.Action.NoAction.instance()
        
        guard let not = CardKit.Hand.Logic.LogicalNot.instance() as? UnaryLogicHandCard else {
            XCTFail("LogicalNot.instance() did not return a LogicHandCard")
            return
        }
        
        not.addChild(noAction.identifier)
        XCTAssertTrue(not.children.count == 1)
        
        // test that the deck builder is adding a NOT card
        let hand = !noAction
        XCTAssertTrue(hand.cardCount == 2)
        let notCards = hand.cards(matching: CardKit.Hand.Logic.LogicalNot)
        XCTAssertTrue(notCards.count == 1)
        
        guard let first = notCards.first as? UnaryLogicHandCard else {
            XCTFail("should have a LogicHandCard in the hand")
            return
        }
        XCTAssertTrue(first.descriptor.logicType == .BooleanLogicNot)
        XCTAssertTrue(first.children.contains(noAction.identifier))
    }
    
    func testMergeHandsWithAnd() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        let handA = noActionA && noActionB
        let handB = noActionC && noActionD
        
        // get the added AND cards
        guard let handAAnd = handA.cards(matching: CardKit.Hand.Logic.LogicalAnd).first as? BinaryLogicHandCard else {
            XCTFail("could not find AND card added to handA")
            return
        }
        guard let handBAnd = handB.cards(matching: CardKit.Hand.Logic.LogicalAnd).first as? BinaryLogicHandCard else {
            XCTFail("could not find AND card added to handB")
            return
        }
        
        let merged = handA && handB
        
        // merged should have 7 cards:
        // A, B, C, D, AND(A,B), AND(C,D), AND(AND(A,B), AND(C,D))
        XCTAssertTrue(merged.cardCount == 7)
        
        // three AND cards
        let andCards = merged.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 3)
        
        // make sure they have the right targets
        for card in andCards {
            if let andCard = card as? BinaryLogicHandCard {
                
                if andCard.identifier == handAAnd.identifier {
                    XCTAssertTrue(andCard.children.count == 2)
                    XCTAssertTrue(andCard.children.contains(noActionA.identifier))
                    XCTAssertTrue(andCard.children.contains(noActionB.identifier))
                    
                } else if andCard.identifier == handBAnd.identifier {
                    XCTAssertTrue(andCard.children.count == 2)
                    XCTAssertTrue(andCard.children.contains(noActionC.identifier))
                    XCTAssertTrue(andCard.children.contains(noActionD.identifier))
                
                } else {
                    // this should be the new AND(AND(A,B), AND(C,D))
                    XCTAssertTrue(andCard.children.count == 2)
                    XCTAssertTrue(andCard.children.contains(handAAnd.identifier))
                    XCTAssertTrue(andCard.children.contains(handBAnd.identifier))
                }
                
            } else {
                XCTFail("found an AND card that wasn't a LogicHandCard")
            }
        }
    }
    
    func testMergeHandsWithOr() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        let handA = noActionA || noActionB
        let handB = noActionC || noActionD
        
        // get the added OR cards
        guard let handAOr = handA.cards(matching: CardKit.Hand.Logic.LogicalOr).first as? BinaryLogicHandCard else {
            XCTFail("could not find OR card added to handA")
            return
        }
        guard let handBOr = handB.cards(matching: CardKit.Hand.Logic.LogicalOr).first as? BinaryLogicHandCard else {
            XCTFail("could not find OR card added to handB")
            return
        }
        
        let merged = handA || handB
        
        // merged should have 7 cards:
        // A, B, C, D, OR(A,B), OR(C,D), OR(OR(A,B), OR(C,D))
        XCTAssertTrue(merged.cardCount == 7)
        
        // three OR cards
        let orCards = merged.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 3)
        
        // make sure they have the right targets
        for card in orCards {
            if let orCard = card as? LogicHandCard {
                
                if orCard.identifier == handAOr.identifier {
                    XCTAssertTrue(orCard.children.count == 2)
                    XCTAssertTrue(orCard.children.contains(noActionA.identifier))
                    XCTAssertTrue(orCard.children.contains(noActionB.identifier))
                    
                } else if orCard.identifier == handBOr.identifier {
                    XCTAssertTrue(orCard.children.count == 2)
                    XCTAssertTrue(orCard.children.contains(noActionC.identifier))
                    XCTAssertTrue(orCard.children.contains(noActionD.identifier))
                    
                } else {
                    // this should be the new OR(OR(A,B), OR(C,D))
                    XCTAssertTrue(orCard.children.count == 2)
                    XCTAssertTrue(orCard.children.contains(handAOr.identifier))
                    XCTAssertTrue(orCard.children.contains(handBOr.identifier))
                }
                
            } else {
                XCTFail("found an OR card that wasn't a LogicHandCard")
            }
        }
    }
    
    func testComplicatedHandLogic() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        let noActionE = CardKit.Action.NoAction.instance()
        let noActionF = CardKit.Action.NoAction.instance()
        
        let hand = ((noActionA && noActionB) || (noActionC && noActionD)) + noActionE + !noActionF
        
        // should be 10 cards total:
        // noActionA, noActionB, noActionC, noActionD, noActionE, noActionF (6)
        // AND(A,B), AND(C,D), NOT(F) (3)
        // OR(AND(A,B), AND(C,D)) (1)
        
        XCTAssertTrue(hand.cardCount == 10)
        
        let andCards = hand.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 2)
        
        let orCards = hand.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 1)
        
        let notCards = hand.cards(matching: CardKit.Hand.Logic.LogicalNot)
        XCTAssertTrue(notCards.count == 1)
        
        // verify the childrens
        var addedAndIds: Set<CardIdentifier> = Set()
        for card in andCards {
            if let and = card as? LogicHandCard {
                XCTAssertTrue(and.children.count == 2)
                addedAndIds.insert(and.identifier)
            } else {
                XCTFail("found an AND card that isn't a LogicHandCard")
            }
        }
        
        guard let orCard = orCards.first as? LogicHandCard else {
            XCTFail("OR card isn't a LogicHandCard")
            return
        }
        
        XCTAssertTrue(orCard.children.count == 2)
        for and in addedAndIds {
            XCTAssertTrue(orCard.children.contains(and))
        }
        
        guard let notCard = notCards.first as? LogicHandCard else {
            XCTFail("NOT card isn't a LogicHandCard")
            return
        }
        
        XCTAssertTrue(notCard.children.count == 1)
        XCTAssertTrue(notCard.children.contains(noActionF.identifier))
    }

}
