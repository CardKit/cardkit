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
        XCTAssertTrue(hand.count == 1)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        XCTAssertTrue(hand.actionCards.count == 1)
        XCTAssertTrue(hand.handCards.count == 1)
        XCTAssertTrue(hand.count == 2)
    }
    
    func testHandRemove() {
        var hand = Hand()
        
        let noAction = CardKit.Action.NoAction.instance()
        hand.add(noAction)
        
        let rep = CardKit.Hand.Next.Repeat.instance()
        hand.add(rep)
        
        XCTAssertTrue(hand.count == 2)
        
        hand.remove(rep)
        
        XCTAssertTrue(hand.count == 1)
        
        hand.remove(noAction)
        
        XCTAssertTrue(hand.count == 0)
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
    
    func testHandLogicAnd() {
        let noActionA = CardKit.Action.NoAction.instance()
        let noActionB = CardKit.Action.NoAction.instance()
        
        var and = CardKit.Hand.Logic.LogicalAnd.instance()
        and.logic = .Logic(.LogicalAnd(.Card(noActionA), .Card(noActionB)))
    }
    
    func testHandLogicOr() {
        
    }
    
    func testHandLogicNot() {
        
    }
    
    func testMergeHandsWithAnd() {
        
    }
    
    func testMergeHandsWithOr() {
        
    }
    
    func testComplicatedHandLogic() {
        
    }

}
