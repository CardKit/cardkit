import Foundation

public struct DeckSpec : JsonSerializable {
    public let continuation : [DeckContinuationSpec]
    public let conclusion   : DeckConclusionSpec
    
    public init(continuation: [DeckContinuationSpec], conclusion: DeckConclusionSpec) {
        self.continuation   = continuation
        self.conclusion     = conclusion
    }
    
    public func toSerializable() -> AnyObject {
        var parts : [AnyObject] = []
        parts += serializeBestEffortArray(continuation)
        parts += [conclusion.toSerializable()]
        return parts
    }
}

public indirect enum DeckContinuationSpec : JsonSerializable {
    case Block(SatisfiableSpec)
    case BlockAndBranch(SatisfiableSpec, [BranchSpec])
    
    public func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        
        switch self {
        case .Block(let satisfiable):
            dict["block"] = satisfiable.toSerializable()
        case .BlockAndBranch(let satisfiable, let branches):
            dict["block"] = satisfiable.toSerializable()
            dict["branches"] = serializeBestEffortArray(branches)
        }
        
        return dict
    }
}

public enum DeckConclusionSpec : JsonSerializable {
    case ReturnFromBranch
    case RepeatHand
    case RepeatProgram
    case TerminateProgram
    
    public func toSerializable() -> AnyObject {
        let name : String
        switch self {
        case .ReturnFromBranch:
            name = "ReturnFromBranch"
        case .RepeatHand:
            name = "RepeatHand"
        case .RepeatProgram:
            name = "RepeatProgram"
        case .TerminateProgram:
            name = "Terminate"
        }
        
        return [ "conclude" : name ]
    }
}

public typealias BranchSpec = (SatisfiableSpec, DeckSpec)

public indirect enum SatisfiableSpec : JsonSerializable {
    case End(ActionSpec)
    case All([SatisfiableSpec])
    case Any([SatisfiableSpec])
    case And(SatisfiableSpec, SatisfiableSpec)
    case Or(SatisfiableSpec, SatisfiableSpec)
    case Xor(SatisfiableSpec, SatisfiableSpec)
    case Not(SatisfiableSpec)
    
    public func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        
        switch (self) {
        case .End(let action):
            dict["action"] = action.toSerializable()
        case .All(let sats):
            dict["all"] = serializeBestEffortArray(sats)
        case .Any(let sats):
            dict["any"] = serializeBestEffortArray(sats)
        case .And(let lhs, let rhs):
            dict["and"] = serializeBestEffortArray([lhs, rhs])
        case .Or(let lhs, let rhs):
            dict["or"] = serializeBestEffortArray([lhs, rhs])
        case .Xor(let lhs, let rhs):
            dict["xor"] = serializeBestEffortArray([lhs, rhs])
        case .Not(let operand):
            dict["not"] = operand.toSerializable()
        }
        
        return dict
    }
}

public typealias InputSpec = [String: InputParameter]
public typealias TokenSpec = [String: Token]

public struct ActionSpec : JsonSerializable {
    public let card     : ActionCardDesc
    public let inputs   : InputSpec
    public let tokens   : TokenSpec
    
    public init(card: ActionCardDesc,
        inputs  : InputSpec = InputSpec(),
        tokens  : TokenSpec = TokenSpec()) {
        self.card   = card
        self.inputs = inputs
        self.tokens = tokens
    }
    
    public func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"]                  = card.id.toSerializable()

        if !inputs.isEmpty {
            var inputsDict = [String: AnyObject]()
            
            for (k, v) in inputs {
                inputsDict[k] = v.toSerializable()
            }
            
            dict["inputs"] = inputsDict
        }
        
        if !tokens.isEmpty {
            var tokensDict = [String: AnyObject]()
            
            for (k, v) in tokens {
                tokensDict[k] = v.id
            }
            
            dict["tokens"] = tokensDict
        }

        return dict
    }
}

