import Foundation

public protocol ActionImpl {
    var done : Bool { get }
    
    mutating func setup()
    
    mutating func execute()
    
    mutating func interrupt()
    
    mutating func teardown()
}

public class SimpleActionImpl : ActionImpl {
    private let _setup      : () -> Void
    private let _execute    : () -> Void
    private let _interrupt  : () -> Void
    private let _teardown   : () -> Void
    private var _done = false
    
    public init(
        setup:      () -> Void = {},
        execute:    () -> Void = {},
        interrupt:  () -> Void = {},
        teardown:   () -> Void = {}) {
        _setup      = setup
        _execute    = execute
        _interrupt  = interrupt
        _teardown   = teardown
    }
    
    public var done : Bool {
        get {
            return _done
        }
    }
    
    public func setup() {
        _setup()
    }
    
    public func execute() {
        _execute()
       _done = true
    }
    
    public func interrupt() {
        _interrupt()
    }
    
    public func teardown() {
        _teardown()
    }
    
}

public typealias ActionFactory = (InputSpec, TokenSpec) -> ActionImpl

typealias SatisfactionResult = () -> Bool

public class ExecutionEngine {
    private var loopProgram = false
    private var continueProgram = true
    
    public init() {
    }
    
    
    public func execute(spec: DeckSpec) {
        repeat {
            branch(spec)
            continueProgram = true
        }
        while (loopProgram)
    }
    
    public func branch(spec : DeckSpec) {
        for continuation in spec.continuation {
            execute(continuation)
            
            if !continueProgram {
                break
            }
        }
        
        switch spec.conclusion {
        case .ReturnFromBranch:
            print("Return from Branch")
        case .RepeatHand:
            print("Repeat Hand")
            execute(DeckSpec(continuation: [spec.continuation.last!], conclusion: DeckConclusionSpec.RepeatHand))
        case .RepeatProgram:
            print("Repeat Program")
            loopProgram = true
            continueProgram = false
        case .TerminateProgram:
            print("Terminate Program")
            continueProgram = false
        }
    }
    
    private func execute(spec: DeckContinuationSpec) {
        print("-- Hand --")
        
        switch spec {
        case .Block(let condition):
            execute([prepare(condition)])
        case .BlockAndBranch(let condition, let branches):
            var preparations : [([ActionImpl], SatisfactionResult)] = []
            preparations.append(prepare(condition))
            
            for branch in branches {
                preparations.append(prepare(branch.0))
            }
            
            let firstSatisfied = execute(preparations)
            
            if firstSatisfied > 0 {
                branch(branches[firstSatisfied - 1].1)
            }
        }
    }
    
    private func execute(spec: DeckConclusionSpec) {
        print("-- Conclusion --")
        
        switch spec {
        case .ReturnFromBranch:
            print("Return from Branch")
        case .RepeatHand:
            print("Repeat Hand")
        case .RepeatProgram:
            print("Repeat Program")
        case .TerminateProgram:
            print("Terminate Program")
        }
    }
    
    private func execute(spec: [([ActionImpl], SatisfactionResult)]) -> Int {
        for (actions, _) in spec {
            for var action in actions {
                action.setup()
            }
        }
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        for (actions, _) in spec {
            for var action in actions {
                dispatch_group_async(group, queue) {
                    action.execute()
                }
            }
        }
        
        var firstSatisfied : Int = -1
        
        while firstSatisfied < 0 {
            for i in 0 ..< spec.count {
                if spec[i].1() {
                    firstSatisfied = i
                    break
                }
            }
            
            usleep(100)
        }
        
        for (actions, _) in spec {
            for var action in actions {
                action.interrupt()
            }
        }
            
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        for (actions, _) in spec {
            for var action in actions {
                action.teardown()
            }
        }
        
        return firstSatisfied
    }
    
    private func prepare(spec: SatisfiableSpec) -> ([ActionImpl], SatisfactionResult) {
        switch spec {
            
        case .End(let action):
            let impl = prepare(action)
            return ([impl], { return impl.done } )
            
        case .All(let satisfiables):
            var actions : [ActionImpl] = []
            var satisfaction : SatisfactionResult = { return true }
            
            for satisfiable in satisfiables {
                let (nextActions, nextSatisfaction) = prepare(satisfiable)
                actions += nextActions
                satisfaction = { return satisfaction() && nextSatisfaction() }
            }
            
            return (actions, satisfaction)
            
        case .Any(let satisfiables):
            var actions : [ActionImpl] = []
            var satisfaction : SatisfactionResult = { return false }
            
            for satisfiable in satisfiables {
                let (nextActions, nextSatisfaction) = prepare(satisfiable)
                actions += nextActions
                satisfaction = { return satisfaction() || nextSatisfaction() }
            }
            
            return (actions, satisfaction)
            
        case .And(let lhs, let rhs):
            let (lhsActions, lhsSatisfaction) = prepare(lhs)
            let (rhsActions, rhsSatisfaction) = prepare(rhs)
            return (lhsActions + rhsActions, {
                return lhsSatisfaction() && rhsSatisfaction()
            });
            
        case .Or(let lhs, let rhs):
            let (lhsActions, lhsSatisfaction) = prepare(lhs)
            let (rhsActions, rhsSatisfaction) = prepare(rhs)
            return (lhsActions + rhsActions, { return lhsSatisfaction() || rhsSatisfaction() })
            
        case .Xor(let lhs, let rhs):
            let (lhsActions, lhsSatisfaction) = prepare(lhs)
            let (rhsActions, rhsSatisfaction) = prepare(rhs)
            return (lhsActions + rhsActions, {
                let lhsVal = lhsSatisfaction()
                let rhsVal = rhsSatisfaction()
                return lhsVal && !rhsVal || !lhsVal && rhsVal
            })
            
        case .Not(let satisfiable):
            let (actions, satisfaction) = prepare(satisfiable)
            return (actions, { !satisfaction() })
        }
    }
    
    private func prepare(spec: ActionSpec) -> ActionImpl {
        return spec.card.factory(spec.inputs, spec.tokens)
    }
}
