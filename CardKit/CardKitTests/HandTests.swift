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
        
        // this is 2 because we will always have an End Rule card in the hand
        XCTAssertTrue(hand.cardCount == 2)
        XCTAssertTrue(hand.cards(matching: CardKit.Action.NoAction).count == 1)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        XCTAssertTrue(hand.cardCount == 2)
        XCTAssertTrue(hand.cards(matching: CardKit.Hand.Next.Repeat).count == 1)
    }
    
    func testHandRemove() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        hand.add(noAction)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        // this is 3 because we will always have an End Rule card in the hand
        XCTAssertTrue(hand.cardCount == 3)
        
        hand.remove(rep)
        XCTAssertTrue(hand.cardCount == 2)
        
        hand.remove(noAction)
        XCTAssertTrue(hand.cardCount == 1)
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
        
        XCTAssertTrue(hand.cards(matching: CardKit.Action.NoAction).count == 1)
        XCTAssertTrue(hand.cardCount == 1)
    }
    
    func testHandLogicAnd() {
        // test that AND is functioning correctly
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        // test that the deck builder is adding an AND card
        let hand = noActionA && noActionB
        XCTAssertTrue(hand.cardCount == 3)
        
        let andCards = hand.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 1)
        
        guard let first = andCards.first as? LogicHandCard else {
            XCTFail("should have a LogicHandCard in the hand")
            return
        }
        
        XCTAssertTrue(first.descriptor.handCardType == .BooleanLogicAnd)
        
        let children = hand.children(of: first)
        XCTAssertTrue(children.count == 2)
        XCTAssertTrue(children[0] == noActionA.identifier)
        XCTAssertTrue(children[1] == noActionB.identifier)
    }
    
    func testHandLogicOr() {
        // test that OR is functioning correctly
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        // test that the deck builder is adding an OR card
        let hand = noActionA || noActionB
        XCTAssertTrue(hand.cardCount == 3)
        
        let orCards = hand.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 1)
        
        guard let first = orCards.first as? LogicHandCard else {
            XCTFail("should have a LogicHandCard in the hand")
            return
        }
        
        XCTAssertTrue(first.descriptor.handCardType == .BooleanLogicOr)
        
        let children = hand.children(of: first)
        XCTAssertTrue(children.count == 2)
        XCTAssertTrue(children[0] == noActionA.identifier)
        XCTAssertTrue(children[1] == noActionB.identifier)
    }
    
    func testHandLogicNot() {
        // test that NOT is functioning correctly
        let noAction = CardKit.Action.NoAction.instance()
        
        // test that the deck builder is adding a NOT card
        let hand = !noAction
        XCTAssertTrue(hand.cardCount == 2)
        
        let notCards = hand.cards(matching: CardKit.Hand.Logic.LogicalNot)
        XCTAssertTrue(notCards.count == 1)
        
        guard let first = notCards.first as? LogicHandCard else {
            XCTFail("should have a LogicHandCard in the hand")
            return
        }
        
        XCTAssertTrue(first.descriptor.handCardType == .BooleanLogicNot)
        
        let children = hand.children(of: first)
        XCTAssertTrue(children.count == 1)
        XCTAssertTrue(children[0] == noAction.identifier)
    }
    
    func testMergeHands() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        let handA = noActionA && noActionB
        let handB = noActionC && noActionD
        let merged = handA + handB
        
        // merged should have 6 cards:
        // A, B, C, D, AND(A,B), AND(C,D)
        XCTAssertTrue(merged.cardCount == 6)
        
        // two AND cards
        let andCards = merged.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 2)
    }
    
    func testMergeHandsWithAnd() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        let handA = noActionA && noActionB
        let handB = noActionC && noActionD
        let merged = handA && handB
        
        // merged should have 7 cards:
        // A, B, C, D, AND(A,B), AND(C,D), AND(AND(A,B), AND(C,D))
        XCTAssertTrue(merged.cardCount == 7)
        
        // three AND cards
        let andCards = merged.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 3)
        
        // handA & handB AND cards
        guard let handAAnd = handA.cards(matching: CardKit.Hand.Logic.LogicalAnd).first else {
            XCTFail("could not find AND card added to hand A")
            return
        }
        guard let handBAnd = handB.cards(matching: CardKit.Hand.Logic.LogicalAnd).first else {
            XCTFail("could not find AND card added to hand B")
            return
        }
        
        // make sure they have the right targets
        for card in andCards {
            if let andCard = card as? LogicHandCard {
                let targets = merged.children(of: andCard)
                
                if andCard.identifier == handAAnd.identifier {
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(noActionA.identifier))
                    XCTAssertTrue(targets.contains(noActionB.identifier))
                    
                } else if andCard.identifier == handBAnd.identifier {
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(noActionC.identifier))
                    XCTAssertTrue(targets.contains(noActionD.identifier))
                
                } else {
                    // this should be the new AND(AND(A,B), AND(C,D))
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(handAAnd.identifier))
                    XCTAssertTrue(targets.contains(handBAnd.identifier))
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
        let merged = handA || handB
        
        // merged should have 7 cards:
        // A, B, C, D, OR(A,B), OR(C,D), OR(OR(A,B), OR(C,D))
        XCTAssertTrue(merged.cardCount == 7)
        
        // three OR cards
        let orCards = merged.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 3)
        
        // handA & handB OR cards
        guard let handAOr = handA.cards(matching: CardKit.Hand.Logic.LogicalOr).first else {
            XCTFail("could not find OR card added to hand A")
            return
        }
        guard let handBOr = handB.cards(matching: CardKit.Hand.Logic.LogicalOr).first else {
            XCTFail("could not find OR card added to hand B")
            return
        }
        
        // make sure they have the right targets
        for card in orCards {
            if let orCard = card as? LogicHandCard {
                let targets = merged.children(of: orCard)
                
                if orCard.identifier == handAOr.identifier {
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(noActionA.identifier))
                    XCTAssertTrue(targets.contains(noActionB.identifier))
                    
                } else if orCard.identifier == handBOr.identifier {
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(noActionC.identifier))
                    XCTAssertTrue(targets.contains(noActionD.identifier))
                    
                } else {
                    // this should be the new OR(OR(A,B), OR(C,D))
                    XCTAssertTrue(targets.count == 2)
                    XCTAssertTrue(targets.contains(handAOr.identifier))
                    XCTAssertTrue(targets.contains(handBOr.identifier))
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
    }
    
    func testEndRule() {
        guard let endRuleAny: EndRuleHandCard = CardKit.Hand.End.Any.typedInstance() else {
            XCTFail("did not obtain an EndRuleHandCard instance from typedInstance()")
            return
        }
        
        var hand = Hand()
        hand.add(endRuleAny)
        
        XCTAssertTrue(hand.endRule == .EndWhenAnySatisfied)
    }
    
    func testEndRuleMergesCorrectly() {
        guard let endRuleAll: EndRuleHandCard = CardKit.Hand.End.All.typedInstance() else {
            XCTFail("did not obtain an EndRuleHandCard instance from typedInstance()")
            return
        }
        guard let endRuleAny: EndRuleHandCard = CardKit.Hand.End.Any.typedInstance() else {
            XCTFail("did not obtain an EndRuleHandCard instance from typedInstance()")
            return
        }
        
        var handA = Hand()
        handA.add(endRuleAll)
        
        var handB = Hand()
        handB.add(endRuleAny)
        
        // merge B into A: B's rule overwrites A's rule
        let btoa = handA.merged(with: handB)
        XCTAssertTrue(btoa.cardCount == 1)
        XCTAssertTrue(btoa.endRule == .EndWhenAnySatisfied)
        
        // merge A into B: A's rule overwrites B's rule
        let atob = handB.merged(with: handA)
        XCTAssertTrue(atob.cardCount == 1)
        XCTAssertTrue(atob.endRule == .EndWhenAllSatisfied)
    }
    
    func testRepeatCard() {
        guard let repeatCard: RepeatHandCard = CardKit.Hand.Next.Repeat.typedInstance() else {
            XCTFail("did not obtain a RepeatHandCard instance from typedInstance()")
            return
        }
        
        repeatCard.repeatCount = 5
        
        var hand = Hand()
        XCTAssertTrue(hand.repeatCount == 0)
        XCTAssertTrue(hand.executionCount == 1)
        
        hand.add(repeatCard)
        XCTAssertTrue(hand.repeatCount == 5)
        XCTAssertTrue(hand.executionCount == 6)
    }
    
    func testRepeatCardMergesCorrectly() {
        guard let repeatCardA: RepeatHandCard = CardKit.Hand.Next.Repeat.typedInstance() else {
            XCTFail("did not obtain a RepeatHandCard instance from typedInstance()")
            return
        }
        guard let repeatCardB: RepeatHandCard = CardKit.Hand.Next.Repeat.typedInstance() else {
            XCTFail("did not obtain a RepeatHandCard instance from typedInstance()")
            return
        }
        
        repeatCardA.repeatCount = 3
        repeatCardB.repeatCount = 6
        
        var handA = Hand()
        handA.add(repeatCardA)
        
        var handB = Hand()
        handB.add(repeatCardB)
        
        // merge B into A: B's rule overwrites A's rule
        let btoa = handA.merged(with: handB)
        XCTAssertTrue(btoa.repeatCount == 6)
        
        // merge A into B: A's rule overwrites B's rule
        let atob = handB.merged(with: handA)
        XCTAssertTrue(atob.repeatCount == 3)
    }
    
    func testSimpleBranchCard() {
        var handA = Hand()
        let handB = Hand()
        
        let branchCard = handA.addBranch(to: handB)
        XCTAssertTrue(branchCard.targetHandIdentifier == handB.identifier)
    }
    
    func testComplexBranchCard() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        let noActionE = CardKit.Action.NoAction.instance()
        let noActionF = CardKit.Action.NoAction.instance()
        
        // this is kind of cheating, we should never use action card instances across hands like this
        var handA = ((noActionA && noActionB) || (noActionC && noActionD)) + noActionE + !noActionF
        let handB = !noActionA + (noActionB && noActionC) + (noActionD || !noActionE) + noActionF
        
        for tree in handA.cardTrees {
            let branch = handA.addBranch(from: tree, to: handB)
            XCTAssertTrue(branch.targetHandIdentifier == handB.identifier)
        }
        
        XCTAssertTrue(handA.cards(matching: CardKit.Hand.Next.Branch).count == handA.cardTrees.count)
    }
    
    func testBranchOverwriting() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        var handA = noActionA && noActionB
        guard let tree = handA.cardTrees.first else {
            XCTFail("handA does not have any cardTrees")
            return
        }
        
        let handB = Hand()
        handA.addBranch(from: tree, to: handB)
        
        let handC = Hand()
        handA.addBranch(from: tree, to: handC)
        
        XCTAssertTrue(handA.branchTarget(of: tree) == handC.identifier)
    }
}
