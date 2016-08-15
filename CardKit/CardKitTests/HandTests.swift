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
        
        // this should be 3: NoAction, Repeat, End Rule
        XCTAssertTrue(hand.cardCount == 3)
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
        
        // two cards: NoAction and End Rule
        XCTAssertTrue(hand.cardCount == 2)
    }
    
    func testHandLogicAnd() {
        // test that AND is functioning correctly
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        // test that the deck builder is adding an AND card
        let hand = noActionA && noActionB
        
        // four cards: NoActionA, NoActionB, AND, End Rule
        XCTAssertTrue(hand.cardCount == 4)
        
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
        
        // four cards: NoActionA, NoActionB, OR, End Rule
        XCTAssertTrue(hand.cardCount == 4)
        
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
        
        // three cards: NoAction, NOT, End Rule
        XCTAssertTrue(hand.cardCount == 3)
        
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
        
        // merged should have 7 cards:
        // A, B, C, D, AND(A,B), AND(C,D), End Rule
        XCTAssertTrue(merged.cardCount == 7)
        
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
        
        // merged should have 8 cards:
        // A, B, C, D, AND(A,B), AND(C,D), AND(AND(A,B), AND(C,D)), End Rule
        XCTAssertTrue(merged.cardCount == 8)
        
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
        
        // merged should have 8 cards:
        // A, B, C, D, OR(A,B), OR(C,D), OR(OR(A,B), OR(C,D)), End Rule
        XCTAssertTrue(merged.cardCount == 8)
        
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
        
        // should be 11 cards total:
        // noActionA, noActionB, noActionC, noActionD, noActionE, noActionF (6)
        // AND(A,B), AND(C,D), NOT(F) (3)
        // OR(AND(A,B), AND(C,D)) (1)
        // End Rule (1)
        XCTAssertTrue(hand.cardCount == 11)
        
        // there should be 3 CardTrees
        // OR(AND(A,B), AND(C,D))
        // E
        // NOT(F)
        XCTAssertTrue(hand.cardTrees.count == 3)
        
        let andCards = hand.cards(matching: CardKit.Hand.Logic.LogicalAnd)
        XCTAssertTrue(andCards.count == 2)
        
        let orCards = hand.cards(matching: CardKit.Hand.Logic.LogicalOr)
        XCTAssertTrue(orCards.count == 1)
        
        let notCards = hand.cards(matching: CardKit.Hand.Logic.LogicalNot)
        XCTAssertTrue(notCards.count == 1)
    }
    
    func testSimpleAddRemove() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        var hand = Hand()
        
        // noActionA, End Rule
        hand.add(noActionA)
        XCTAssertTrue(hand.cardCount == 2)
        
        // noActionA, noActionB, End Rule
        hand.add(noActionB)
        XCTAssertTrue(hand.cardCount == 3)
        
        // noActionA, noActionB, noActionC, End Rule
        hand.add(noActionC)
        XCTAssertTrue(hand.cardCount == 4)
        
        // noActionA, noActionB, noActionC, noActionD, End Rule
        hand.add(noActionD)
        XCTAssertTrue(hand.cardCount == 5)
        
        // noActionB, noActionC, noActionD, End Rule
        hand.remove(noActionA)
        XCTAssertTrue(hand.cardCount == 4)
        
        // noActionC, noActionD, End Rule
        hand.remove(noActionB)
        XCTAssertTrue(hand.cardCount == 3)
        
        // noActionD, End Rule
        hand.remove(noActionC)
        XCTAssertTrue(hand.cardCount == 2)
        
        // End Rule
        hand.remove(noActionD)
        XCTAssertTrue(hand.cardCount == 1)
    }
    
    func testComplicatedAddRemove() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        guard let andA: LogicHandCard = CardKit.Hand.Logic.LogicalAnd.typedInstance() else {
            XCTFail("did not obtain a LogicHandCard from typedInstance()")
            return
        }
        guard let andB: LogicHandCard = CardKit.Hand.Logic.LogicalAnd.typedInstance() else {
            XCTFail("did not obtain a LogicHandCard from typedInstance()")
            return
        }
        guard let or: LogicHandCard = CardKit.Hand.Logic.LogicalOr.typedInstance() else {
            XCTFail("did not obtain a LogicHandCard from typedInstance()")
            return
        }
        
        var hand = Hand()
        
        // AND(AND(A,OR(B,C)),D)
        hand.attach(noActionB, to: or)
        hand.attach(noActionC, to: or)
        hand.attach(noActionA, to: andA)
        hand.attach(or, to: andA)
        hand.attach(noActionD, to: andB)
        hand.attach(andA, to: andB)
        
        // noActionA, noActionB, noActionC, noActionD, OR, AND_A, AND_B, End Rule
        XCTAssertTrue(hand.cardCount == 8)
        
        // remove AND_A
        hand.remove(andA)
        
        // noActionA, noActionB, noActionC, noActionD, OR, AND_B, End Rule
        XCTAssertTrue(hand.cardCount == 7)
        do {
            let andBchildren = hand.children(of: andB)
            XCTAssertTrue(andBchildren.count == 1)
            andBchildren.forEach { XCTAssertTrue($0 == noActionD.identifier) }
        }
    }
    
    //swiftlint:disable:next function_body_length
    func testAttachDetach() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        let noActionC = CardKit.Action.NoAction.instance()
        let noActionD = CardKit.Action.NoAction.instance()
        
        guard let and: LogicHandCard = CardKit.Hand.Logic.LogicalAnd.typedInstance() else {
            XCTFail("did not obtain a LogicHandCard from typedInstance()")
            return
        }
        guard let or: LogicHandCard = CardKit.Hand.Logic.LogicalOr.typedInstance() else {
            XCTFail("did not obtain a LogicHandCard from typedInstance()")
            return
        }
        
        var hand = Hand()
        
        // attach noActionA to the AND, this should implicity add both cards to the hand
        // noActionA, AND(A,_), End Rule
        hand.attach(noActionA, to: and)
        XCTAssertTrue(hand.cardCount == 3)
        
        // re-attach noActionA to the AND, should have no effect
        // noActionA, AND(A,_), End Rule
        hand.attach(noActionA, to: and)
        XCTAssertTrue(hand.cardCount == 3)
        
        // attach noActionB, should now have 4 cards
        // noActionA, noActionB, AND(A,B), End Rule
        hand.attach(noActionB, to: and)
        XCTAssertTrue(hand.cardCount == 4)
        
        // lets add an OR, should now have 5 cards
        // noActionA, noActionB, AND(A,B), OR(_,_), End Rule
        hand.add(or)
        XCTAssertTrue(hand.cardCount == 5)
        
        // move noActionA to the OR, should still have 5 cards
        // noActionA, noActionB, AND(_,B), OR(A,_), End Rule
        hand.attach(noActionA, to: or)
        XCTAssertTrue(hand.cardCount == 5)
        do {
            let andChildren = hand.children(of: and)
            let orChildren = hand.children(of: or)
            
            XCTAssertTrue(andChildren.count == 1)
            XCTAssertTrue(orChildren.count == 1)
            andChildren.forEach { XCTAssertTrue($0 == noActionB.identifier) }
            orChildren.forEach { XCTAssertTrue($0 == noActionA.identifier) }
        }
        
        // attach noActionC to the AND (since it has a free slot now), should have 6 cards
        // noActionA, noActionB, noActionC, AND(C,B), OR(A,_), End Rule
        hand.attach(noActionC, to: and)
        XCTAssertTrue(hand.cardCount == 6)
        do {
            let andChildren = hand.children(of: and)
            XCTAssertTrue(andChildren.count == 2)
            andChildren.forEach { XCTAssertTrue($0 == noActionC.identifier || $0 == noActionB.identifier) }
        }
        
        // attach noActionD to the AND should fail; children are already noActionA and noActionC
        // noActionA, noActionB, noActionC, AND(C,B), OR(A,_), End Rule
        hand.attach(noActionD, to: and)
        XCTAssertTrue(hand.cardCount == 6)
        do {
            let andChildren = hand.children(of: and)
            XCTAssertTrue(andChildren.count == 2)
            andChildren.forEach { XCTAssertTrue($0 == noActionC.identifier || $0 == noActionB.identifier) }
        }
        
        // attach AND(C,B) to OR(A,_)
        // noActionA, noActionB, noActionC, AND(C,B), OR(A,AND(C,B)), End Rule
        hand.attach(and, to: or)
        XCTAssertTrue(hand.cardCount == 6)
        do {
            let orChildren = hand.children(of: or)
            XCTAssertTrue(orChildren.count == 2)
            orChildren.forEach { XCTAssertTrue($0 == noActionA.identifier || $0 == and.identifier) }
        }
        
        // detach AND(C,B) from OR(A,AND(C,B))
        // noActionA, noActionB, noActionC, AND(C,B), OR(A,_), End Rule
        hand.detach(and)
        XCTAssertTrue(hand.cardCount == 6)
        do {
            let orChildren = hand.children(of: or)
            XCTAssertTrue(orChildren.count == 1)
            orChildren.forEach { XCTAssertTrue($0 == noActionA.identifier) }
        }
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
