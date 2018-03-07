/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/// Defines the descriptor hierarchy for all cards in CardKit.
public struct CardKit {
    fileprivate init() {}

    /// Contains descriptors for Action cards
    public struct Action {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Deck cards
    public struct Deck {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Hand cards
    public struct Hand {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input cards
    public struct Input {
        fileprivate init() {}
    }
}

// MARK: - Action Cards

extension CardKit.Action {
    /// Contains descriptors for Action/Trigger cards
    public struct Trigger {
        fileprivate init() {}
    }
}

extension CardKit.Action.Trigger {
    /// Contains descriptors for Action/Trigger/Time cards
    public struct Time {
        fileprivate init() {}
        
        // MARK: Trigger/Time/Timer
        /// Descriptor for the Timer card
        public static let Timer = ActionCardDescriptor(
            name: "Timer",
            subpath: "Trigger/Time",
            inputs: [
                InputSlot(name: "Duration", descriptor: CardKit.Input.Time.Duration, isOptional: false)
            ],
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends after the specified duration",
            assetCatalog: CardAssetCatalog(description: "Set a timer", cardImageName: "trigger-timer"))
        
        // MARK: Trigger/WaitUntilTime
        /// Descriptor for the WaitUntilTime card
        public static let WaitUntilTime = ActionCardDescriptor(
            name: "Wait Until Time",
            subpath: "Trigger/Time",
            inputs: [
                InputSlot(name: "ClockTime", descriptor: CardKit.Input.Time.ClockTime, isOptional: false)
            ],
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends when the specified time is reached",
            assetCatalog: CardAssetCatalog(description: "Wait until the specified time", cardImageName: "trigger-wait-until-time"))
    }
}


// MARK: - Deck Cards

extension CardKit.Deck {
    // MARK: Repeat
    public static let Repeat = DeckCardDescriptor(
        name: "Repeat",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Repeat the deck", cardImageName: "deck-repeat"))
    
    // MARK: Terminate
    public static let Terminate = DeckCardDescriptor(
        name: "Terminate",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Terminate the deck", cardImageName: ""))
}


// MARK: - Hand Cards

extension CardKit.Hand {
    /// Contains descriptors for Hand/Next cards
    public struct Next {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Hand/End cards
    public struct End {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Hand/Logic cards
    public struct Logic {
        fileprivate init() {}
    }
}

extension CardKit.Hand.Next {
    // MARK: Branch
    /// Descriptor for the Branch card
    public static let Branch = HandCardDescriptor(
        name: "Branch",
        subpath: "Next",
        handCardType: .branch,
        assetCatalog: CardAssetCatalog(description: "Branch to the specified hand", cardImageName: "hand-branch"))
    
    // MARK: Repeat
    /// Descriptor for the Repeat card
    public static let Repeat = HandCardDescriptor(
        name: "Repeat",
        subpath: "Next",
        handCardType: .repeatHand,
        assetCatalog: CardAssetCatalog(description: "Repeat the hand", cardImageName: "hand-repeat"))
}

extension CardKit.Hand.End {
    // MARK: All
    /// Descriptor for the All card
    public static let OnAll = HandCardDescriptor(
        name: "All",
        subpath: "End",
        handCardType: .endWhenAllSatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when all End conditions have been satisfied", cardImageName: ""))
    
    // MARK: Any
    /// Descriptor for the Any card
    public static let OnAny = HandCardDescriptor(
        name: "Any",
        subpath: "End",
        handCardType: .endWhenAnySatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when any End condition has been satisfied", cardImageName: "hand-end-any"))
}

extension CardKit.Hand.Logic {
    // MARK: LogicalNot
    /// Descriptor for the LogicalNot card
    public static let LogicalNot = HandCardDescriptor(
        name: "Not",
        subpath: "Logic",
        handCardType: .booleanLogicNot,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target card has NOT been satisfied", cardImageName: "logic-not"))
    
    // MARK: LogicalAnd
    /// Descriptor for the LogicalAnd card
    public static let LogicalAnd = HandCardDescriptor(
        name: "And",
        subpath: "Logic",
        handCardType: .booleanLogicAnd,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target cards have both been satisfied", cardImageName: "logic-and"))
    
    // MARK: LogicalOr
    /// Descriptor for the LogicalOr card
    public static let LogicalOr = HandCardDescriptor(
        name: "Or",
        subpath: "Logic",
        handCardType: .booleanLogicOr,
        assetCatalog: CardAssetCatalog(description: "Satisfied when one of the two target cards have both been satisfied", cardImageName: "logic-or"))
}


// MARK: - Input Cards
    
extension CardKit.Input {
    /// Contains descriptors for Input/Logical cards
    public struct Logical {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input/Media cards
    public struct Media {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input/Numeric cards
    public struct Numeric {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input/Raw cards
    public struct Raw {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input/Text cards
    public struct Text {
        fileprivate init() {}
    }
    
    /// Contains descriptors for Input/Time cards
    public struct Time {
        fileprivate init() {}
    }
}

extension CardKit.Input.Logical {
    // MARK: Logical
    /// Descriptor for the Boolean card
    public static let Boolean = InputCardDescriptor(
        name: "Boolean",
        subpath: "Logical",
        inputType: Bool.self,
        inputDescription: "Boolean value (true or false)",
        assetCatalog: CardAssetCatalog(description: "Boolean", cardImageName: ""))
}

extension CardKit.Input.Media {
    // MARK: Media/Audio
    /// Descriptor for the Audio card
    public static let Audio = InputCardDescriptor(
        name: "Audio",
        subpath: "Media/Audio",
        inputType: Data.self,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Audio", cardImageName: "input-audio"))
    
    // MARK: Media/Image
    /// Descriptor for the Image card
    public static let Image = InputCardDescriptor(
        name: "Image",
        subpath: "Media/Image",
        inputType: Data.self,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Image", cardImageName: "input-image"))
}

extension CardKit.Input.Numeric {
    // MARK: Numeric/Integer
    /// Descriptor for the Integer card
    public static let Integer = InputCardDescriptor(
        name: "Integer",
        subpath: "Numeric",
        inputType: Int.self,
        inputDescription: "Integer",
        assetCatalog: CardAssetCatalog(description: "Integer number", cardImageName: ""))
    
    // MARK: Numeric/Real
    /// Descriptor for the Real card
    public static let Real = InputCardDescriptor(
        name: "Real",
        subpath: "Numeric",
        inputType: Double.self,
        inputDescription: "Real",
        assetCatalog: CardAssetCatalog(description: "Real number", cardImageName: ""))
}

extension CardKit.Input.Raw {
    // MARK: Raw/Data
    /// Descriptor for Raw/Data card
    public static let RawData = InputCardDescriptor(
        name: "Raw Data",
        subpath: "Raw",
        inputType: Data.self,
        inputDescription: "Raw data",
        assetCatalog: CardAssetCatalog(description: "Raw data", cardImageName: ""))
}

extension CardKit.Input.Text {
    // MARK: Text/String
    /// Descriptor for Text/String card
    public static let TextString = InputCardDescriptor(
        name: "Text String",
        subpath: "Text",
        inputType: String.self,
        inputDescription: "String",
        assetCatalog: CardAssetCatalog(description: "A string", cardImageName: ""))
}

extension CardKit.Input.Time {
    // MARK: Time/ClockTime
    /// Descriptor for ClockTime card
    public static let ClockTime = InputCardDescriptor(
        name: "Clock Time",
        subpath: "Time",
        inputType: Date.self,
        inputDescription: "Date & time string",
        assetCatalog: CardAssetCatalog(description: "Time (date & time)", cardImageName: "input-clock-time"))
    
    // MARK: Time/Duration
    /// Descriptor for Duration card
    public static let Duration = InputCardDescriptor(
        name: "Duration",
        subpath: "Time",
        inputType: TimeInterval.self,
        inputDescription: "Duration (seconds)",
        assetCatalog: CardAssetCatalog(description: "Duration (seconds)", cardImageName: "input-duration"))
    
    // MARK: Time/Periodicity
    /// Descriptor for the Periodicity card
    public static let Periodicity = InputCardDescriptor(
        name: "Periodicity",
        subpath: "Time",
        inputType: TimeInterval.self,
        inputDescription: "Periodic frequency (seconds)",
        assetCatalog: CardAssetCatalog(description: "Periodic frequency (seconds)", cardImageName: ""))
}
