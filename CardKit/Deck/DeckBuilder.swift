import Foundation

/*** Action Specification ***/

infix operator <- { associativity right precedence 130}

public func <-(lhs: InputSpec, rhs: TokenSpec) -> (InputSpec, TokenSpec) {
    return (lhs, rhs)
}

public func <-(lhs: TokenSpec, rhs: InputSpec) -> (InputSpec, TokenSpec) {
    return (rhs, lhs)
}

public func <-(lhs: ActionCardDesc, rhs: InputSpec) -> ActionSpec {
    return ActionSpec(card: lhs, inputs: rhs)
}

public func <-(lhs: ActionCardDesc, rhs: TokenSpec) -> ActionSpec {
    return ActionSpec(card: lhs, tokens: rhs)
}

public func <-(lhs: ActionCardDesc, rhs: (InputSpec, TokenSpec)) -> ActionSpec {
    let (inputs, tokens) = rhs
    return ActionSpec(card: lhs, inputs: inputs, tokens: tokens)
}

public func <-(lhs: ActionCardDesc, rhs: (TokenSpec, InputSpec)) -> ActionSpec {
    let (tokens, inputs) = rhs
    return ActionSpec(card: lhs, inputs: inputs, tokens: tokens)
}


/*** Satisfiable Specficiation ***/

public func done(operand: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.End(ActionSpec(card: operand))
}

public func done(operand: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.End(operand)
}

prefix operator ! { }

public prefix func !(operand: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.Not(done(operand))
}

public prefix func !(operand: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Not(operand)
}

public func &&(lhs: ActionCardDesc, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), done(rhs))
}

public func &&(lhs: ActionCardDesc, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), done(rhs))
}

public func &&(lhs: ActionCardDesc, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), rhs)
}

public func &&(lhs: ActionSpec, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), done(rhs))
}

public func &&(lhs: ActionSpec, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), done(rhs))
}

public func &&(lhs: ActionSpec, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(done(lhs), rhs)
}

public func &&(lhs: SatisfiableSpec, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.And(lhs, done(rhs))
}

public func &&(lhs: SatisfiableSpec, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(lhs, done(rhs))
}

public func &&(lhs: SatisfiableSpec, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.And(lhs, rhs)
}

public func ||(lhs: ActionCardDesc, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), done(rhs))
}

public func ||(lhs: ActionCardDesc, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), done(rhs))
}

public func ||(lhs: ActionCardDesc, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), rhs)
}

public func ||(lhs: ActionSpec, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), done(rhs))
}

public func ||(lhs: ActionSpec, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), done(rhs))
}

public func ||(lhs: ActionSpec, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(done(lhs), rhs)
}

public func ||(lhs: SatisfiableSpec, rhs: ActionCardDesc) -> SatisfiableSpec {
    return SatisfiableSpec.Or(lhs, done(rhs))
}

public func ||(lhs: SatisfiableSpec, rhs: ActionSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(lhs, done(rhs))
}

public func ||(lhs: SatisfiableSpec, rhs: SatisfiableSpec) -> SatisfiableSpec {
    return SatisfiableSpec.Or(lhs, rhs)
}

/*** Block and Branch Specification ***/

public func block(condition: ActionCardDesc) -> DeckContinuationSpec {
    return DeckContinuationSpec.Block(done(condition))
}

public func block(condition: ActionSpec) -> DeckContinuationSpec {
    return DeckContinuationSpec.Block(done(condition))
}

public func block(condition: SatisfiableSpec) -> DeckContinuationSpec {
    return DeckContinuationSpec.Block(condition)
}

public func branch(condition: ActionCardDesc, branches: BranchSpec...) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(done(condition), branches)
}

public func branch(condition: ActionCardDesc, branches: [BranchSpec]) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(done(condition), branches)
}

public func branch(condition: ActionSpec, branches: BranchSpec...) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(done(condition), branches)
}

public func branch(condition: ActionSpec, branches: [BranchSpec]) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(done(condition), branches)
}

public func branch(condition: SatisfiableSpec, branches: BranchSpec...) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(condition, branches)
}

public func branch(condition: SatisfiableSpec, branches: [BranchSpec]) -> DeckContinuationSpec {
    return DeckContinuationSpec.BlockAndBranch(condition, branches)
}

infix operator ==> { associativity left precedence 80 }

public func ==>(lhs: ActionCardDesc, rhs: ActionCardDesc) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionCardDesc, rhs: ActionSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionCardDesc, rhs: SatisfiableSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionCardDesc, rhs: DeckContinuationSpec) -> [DeckContinuationSpec] {
    return [block(lhs), rhs]
}

public func ==>(lhs: ActionCardDesc, rhs: [DeckContinuationSpec]) -> [DeckContinuationSpec] {
    return [block(lhs)] + rhs
}

public func ==>(lhs: ActionCardDesc, rhs: DeckConclusionSpec) -> DeckSpec {
    return DeckSpec(continuation: [block(lhs)], conclusion: rhs)
}

public func ==>(lhs: ActionSpec, rhs: ActionCardDesc) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionSpec, rhs: ActionSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionSpec, rhs: SatisfiableSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: ActionSpec, rhs: DeckContinuationSpec) -> [DeckContinuationSpec] {
    return [block(lhs), rhs]
}

public func ==>(lhs: ActionSpec, rhs: [DeckContinuationSpec]) -> [DeckContinuationSpec] {
    return [block(lhs)] + rhs
}

public func ==>(lhs: ActionSpec, rhs: DeckConclusionSpec) -> DeckSpec {
    return DeckSpec(continuation: [block(lhs)], conclusion: rhs)
}

public func ==>(lhs: SatisfiableSpec, rhs: ActionCardDesc) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: SatisfiableSpec, rhs: ActionSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: SatisfiableSpec, rhs: SatisfiableSpec) -> [DeckContinuationSpec] {
    return [block(lhs), block(rhs)]
}

public func ==>(lhs: SatisfiableSpec, rhs: DeckContinuationSpec) -> [DeckContinuationSpec] {
    return [block(lhs), rhs]
}

public func ==>(lhs: SatisfiableSpec, rhs: [DeckContinuationSpec]) -> [DeckContinuationSpec] {
    return [block(lhs)] + rhs
}

public func ==>(lhs: SatisfiableSpec, rhs: DeckConclusionSpec) -> DeckSpec {
    return DeckSpec(continuation: [block(lhs)], conclusion: rhs)
}

public func ==>(lhs: DeckContinuationSpec, rhs: ActionCardDesc) -> [DeckContinuationSpec] {
    return [lhs, block(rhs)]
}

public func ==>(lhs: DeckContinuationSpec, rhs: ActionSpec) -> [DeckContinuationSpec] {
    return [lhs, block(rhs)]
}

public func ==>(lhs: DeckContinuationSpec, rhs: SatisfiableSpec) -> [DeckContinuationSpec] {
    return [lhs, block(rhs)]
}

public func ==>(lhs: DeckContinuationSpec, rhs: DeckContinuationSpec) -> [DeckContinuationSpec] {
    return [lhs, rhs]
}

public func ==>(lhs: DeckContinuationSpec, rhs: [DeckContinuationSpec]) -> [DeckContinuationSpec] {
    return [lhs] + rhs
}

public func ==>(lhs: DeckContinuationSpec, rhs: DeckConclusionSpec) -> DeckSpec {
    return DeckSpec(continuation: [lhs], conclusion: rhs)
}

public func ==>(lhs: [DeckContinuationSpec], rhs: ActionCardDesc) -> [DeckContinuationSpec] {
    return lhs + [block(rhs)]
}

public func ==>(lhs: [DeckContinuationSpec], rhs: ActionSpec) -> [DeckContinuationSpec] {
    return lhs + [block(rhs)]
}

public func ==>(lhs: [DeckContinuationSpec], rhs: SatisfiableSpec) -> [DeckContinuationSpec] {
    return lhs + [block(rhs)]
}

public func ==>(lhs: [DeckContinuationSpec], rhs: DeckContinuationSpec) -> [DeckContinuationSpec] {
    return lhs + [rhs]
}

public func ==>(lhs: [DeckContinuationSpec], rhs: [DeckContinuationSpec]) -> [DeckContinuationSpec] {
    return lhs + rhs
}

public func ==>(lhs: [DeckContinuationSpec], rhs: DeckConclusionSpec) -> DeckSpec {
    return DeckSpec(continuation: lhs, conclusion: rhs)
}

infix operator <=> { associativity none precedence 120 }

public func <=>(lhs: ActionCardDesc, rhs: DeckSpec) -> BranchSpec {
    return (done(lhs), rhs)
}

public func <=>(lhs: ActionSpec, rhs: DeckSpec) -> BranchSpec {
    return (done(lhs), rhs)
}

public func <=>(lhs: SatisfiableSpec, rhs: DeckSpec) -> BranchSpec {
    return (lhs, rhs)
}


infix operator ?? { associativity right precedence 105 }

public func ??(lhs: ActionCardDesc, rhs: BranchSpec) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: ActionCardDesc, rhs: [BranchSpec]) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: ActionSpec, rhs: BranchSpec) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: ActionSpec, rhs: [BranchSpec]) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: SatisfiableSpec, rhs: BranchSpec) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: SatisfiableSpec, rhs: [BranchSpec]) -> DeckContinuationSpec {
    return branch(lhs, branches: rhs)
}

public func ??(lhs: BranchSpec, rhs: BranchSpec) -> [BranchSpec] {
    return [lhs] + [rhs]
}


/**** Convenience Functions ***/

public let NO_OP                = BaseCardDescs.Action.NoOp
public let RETURN_FROM_BRANCH   = DeckConclusionSpec.ReturnFromBranch
public let REPEAT_HAND          = DeckConclusionSpec.RepeatHand
public let REPEAT_PROGRAM       = DeckConclusionSpec.RepeatProgram
public let TERMINATE            = DeckConclusionSpec.TerminateProgram

/*** Example Specification ***/

let action = BaseCardDescs.Action.ExampleAction

let deck =
        action
        ==> action && action
        ==> action
        ==> BaseCardDescs.Action.ExampleAction
//            <- ["sharable": "some_token_id"]
//            <- ["input": "some value"]
        ==> action || action
            ?? action <=> (NO_OP ==> REPEAT_HAND)
        ==> action
            ?? action <=> (NO_OP ==> REPEAT_PROGRAM)
            ?? action <=> (NO_OP ==> TERMINATE)
        ==> REPEAT_HAND

