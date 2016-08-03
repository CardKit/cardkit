//
//  DeckBuilder.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation


//MARK: Binding Operator

infix operator <- { associativity right precedence 130 }


//MARK: Binding Data to an InputCard

/// Bind data to an InputCard
public func <-<T> (lhs: InputCard, rhs: T) throws -> InputCard {
    return try lhs.bound(withValue: rhs)
}

//MARK: Binding Input & Token Cards to ActionCard

/// Try binding an InputCard to an ActionCard, looking for the first
/// available InputSlot that matches the InputCard's InputType
public func <- (lhs: ActionCard, rhs: InputCard) throws -> ActionCard {
    return try lhs.bound(with: rhs)
}



// ActionCard <- InputCard
// ActionCard <- TokenCard
// ActionCard <-
/*
public func <- (lhs: InputSpec, rhs: TokenSpec) -> (InputSpec, TokenSpec) {
    return (lhs, rhs)
}

public func <- (lhs: TokenSpec, rhs: InputSpec) -> (InputSpec, TokenSpec) {
    return (rhs, lhs)
}

public func <- (lhs: ActionCardDesc, rhs: InputSpec) -> ActionSpec {
    return ActionSpec(card: lhs, inputs: rhs)
}

public func <- (lhs: ActionCardDesc, rhs: TokenSpec) -> ActionSpec {
    return ActionSpec(card: lhs, tokens: rhs)
}

public func <- (lhs: ActionCardDesc, rhs: (InputSpec, TokenSpec)) -> ActionSpec {
    let (inputs, tokens) = rhs
    return ActionSpec(card: lhs, inputs: inputs, tokens: tokens)
}

public func <- (lhs: ActionCardDesc, rhs: (TokenSpec, InputSpec)) -> ActionSpec {
    let (tokens, inputs) = rhs
    return ActionSpec(card: lhs, inputs: inputs, tokens: tokens)
}
*/
