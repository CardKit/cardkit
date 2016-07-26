import Foundation

/* Validation Results */

protocol CardValidationError : JsonSerializable {
    var message : String { get }
}

extension CardValidationError {
    func toSerializable() -> AnyObject {
        return message
    }
}

enum InputValidationError : CardValidationError {
    case ParameterCountDisagreesWithCardDesc(InputCardDesc, Int)
    case ParameterTypeDisagreesWithCardDesc(InputCardDesc, Int, Any.Type)
    case MissingMandatoryInput(InputCardDesc)
    case UnsupportedInput(InputCardDesc)
    case UnsupportedInputCombination(InputCardDesc, InputCardDesc)
    case UnDescifiedInputError
    
    var message : String {
        switch self {
//        case .ParameterCountDisagreesWithCardDesc(let card, let actualParameterCount):
//            return "Input validation check failed: input '\(card.id.name)' from \(card.id.path) expects \(card.parameterTypes.count) input\(card.parameterTypes.count == 1 ? "" : "s"), but \(actualParameterCount) \(actualParameterCount == 1 ? "was" : "were") specified."
        default:
            return "Input validation check failed with unDescified error."
        }
    }
}

enum TokenValidationError : CardValidationError {
//    case DisallowedConsumableToken(ConsumableTokenCardDesc)
//    case DisallowedTokenCombination(TokenCardDesc, TokenCardDesc)
//    case MissingToken(TokenCardDesc)
    case UnDescifiedTokenError
    
    var message : String {
        return "Token validation check failed with unDescified error."
    }
}

/* Default Validation */

extension AcceptsInputsCardDesc {
    func validate(inputs : [InputSpec]) -> [InputValidationError] {
        var errors = [InputValidationError]()
        
//        for expected in self.mandatoryInputs  {
//            var isExpectedActual = false
//            
//            for actual in inputs {
//                if actual.0.id == expected.id {
//                    isExpectedActual = true
//                    break
//                }
//            }
//            
//            if !isExpectedActual {
//                errors.append(InputValidationError.MissingMandatoryInput(expected))
//            }
//        }
//        
//        for actual in inputs {
//            var isActualExpected = false
//            
//            for expected in self.mandatoryInputs {
//                if actual.0.id == expected.id {
//                    isActualExpected = true
//                    break
//                }
//            }
//            
//            if !isActualExpected {
//                for expected in self.optionalInputs {
//                    if actual.0.id == expected.id {
//                        isActualExpected = true
//                        break
//                    }
//                }
//            }
//            
//            if !isActualExpected {
//                errors.append(InputValidationError.UnsupportedInput(actual.0))
//            }
//        }
//        
//        for actual in inputs {
//            if actual.0.parameterTypes.count != actual.1.count {
//                errors.append(InputValidationError.ParameterCountDisagreesWithCardDesc(actual.0, actual.1.count))
//            }
//        }
        
        return errors
    }
}

extension AcceptsTokensCardDesc {
    func validate(consumableTokens : [TokenCardDesc], sharableTokens : [TokenCardDesc]) -> [TokenValidationError] {
        return []
    }
}



