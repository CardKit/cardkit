//
//  CardKit.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

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
            assetCatalog: CardAssetCatalog(description: "Set a timer"))
        
        // MARK: Triger/WaitUntilTime
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
            assetCatalog: CardAssetCatalog(description: "Wait until the specified time"))
    }
}


// MARK: - Deck Cards

extension CardKit.Deck {
    // MARK: Repeat
    public static let Repeat = DeckCardDescriptor(
        name: "Repeat",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Repeat the deck"))
    
    // MARK: Terminate
    public static let Terminate = DeckCardDescriptor(
        name: "Terminate",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Terminate the deck"))
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
        assetCatalog: CardAssetCatalog(description: "Branch to the specified hand"))
    
    // MARK: Repeat
    /// Descriptor for the Repeat card
    public static let Repeat = HandCardDescriptor(
        name: "Repeat",
        subpath: "Next",
        handCardType: .repeatHand,
        assetCatalog: CardAssetCatalog(description: "Repeat the hand"))
}

extension CardKit.Hand.End {
    // MARK: All
    /// Descriptor for the All card
    public static let OnAll = HandCardDescriptor(
        name: "All",
        subpath: "End",
        handCardType: .endWhenAllSatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when all End conditions have been satisfied"))
    
    // MARK: Any
    /// Descriptor for the Any card
    public static let OnAny = HandCardDescriptor(
        name: "Any",
        subpath: "End",
        handCardType: .endWhenAnySatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when any End condition has been satisfied"))
}

extension CardKit.Hand.Logic {
    // MARK: LogicalNot
    /// Descriptor for the LogicalNot card
    public static let LogicalNot = HandCardDescriptor(
        name: "Not",
        subpath: "Logic",
        handCardType: .booleanLogicNot,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target card has NOT been satisfied"))
    
    // MARK: LogicalAnd
    /// Descriptor for the LogicalAnd card
    public static let LogicalAnd = HandCardDescriptor(
        name: "And",
        subpath: "Logic",
        handCardType: .booleanLogicAnd,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target cards have both been satisfied"))
    
    // MARK: LogicalOr
    /// Descriptor for the LogicalOr card
    public static let LogicalOr = HandCardDescriptor(
        name: "Or",
        subpath: "Logic",
        handCardType: .booleanLogicOr,
        assetCatalog: CardAssetCatalog(description: "Satisfied when one of the two target cards have both been satisfied"))
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
        assetCatalog: CardAssetCatalog(description: "Boolean"))
}

extension CardKit.Input.Media {
    // MARK: Media/Audio
    /// Descriptor for the Audio card
    public static let Audio = InputCardDescriptor(
        name: "Audio",
        subpath: "Media/Audio",
        inputType: Data.self,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Audio"))
    
    // MARK: Media/Image
    /// Descriptor for the Image card
    public static let Image = InputCardDescriptor(
        name: "Image",
        subpath: "Media/Image",
        inputType: Data.self,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Image"))
}

extension CardKit.Input.Numeric {
    // MARK: Numeric/Integer
    /// Descriptor for the Integer card
    public static let Integer = InputCardDescriptor(
        name: "Integer",
        subpath: "Numeric",
        inputType: Int.self,
        inputDescription: "Integer",
        assetCatalog: CardAssetCatalog(description: "Integer number"))
    
    // MARK: Numeric/Real
    /// Descriptor for the Real card
    public static let Real = InputCardDescriptor(
        name: "Real",
        subpath: "Numeric",
        inputType: Double.self,
        inputDescription: "Real",
        assetCatalog: CardAssetCatalog(description: "Real number"))
}

extension CardKit.Input.Raw {
    // MARK: Raw/Data
    /// Descriptor for Raw/Data card
    public static let RawData = InputCardDescriptor(
        name: "Raw Data",
        subpath: "Raw",
        inputType: Data.self,
        inputDescription: "Raw data",
        assetCatalog: CardAssetCatalog(description: "Raw data"))
}

extension CardKit.Input.Text {
    // MARK: Text/String
    /// Descriptor for Text/String card
    public static let TextString = InputCardDescriptor(
        name: "Text String",
        subpath: "Text",
        inputType: String.self,
        inputDescription: "String",
        assetCatalog: CardAssetCatalog(description: "A string"))
}

extension CardKit.Input.Time {
    // MARK: Time/ClockTime
    /// Descriptor for ClockTime card
    public static let ClockTime = InputCardDescriptor(
        name: "Clock Time",
        subpath: "Time",
        inputType: Date.self,
        inputDescription: "Date & time string",
        assetCatalog: CardAssetCatalog(description: "Time (date & time)"))
    
    // MARK: Time/Duration
    /// Descriptor for Duration card
    public static let Duration = InputCardDescriptor(
        name: "Duration",
        subpath: "Time",
        inputType: Double.self,
        inputDescription: "Duration (seconds)",
        assetCatalog: CardAssetCatalog(description: "Duration (seconds)"))
    
    // MARK: Time/Periodicity
    /// Descriptor for the Periodicity card
    public static let Periodicity = InputCardDescriptor(
        name: "Periodicity",
        subpath: "Time",
        inputType: Double.self,
        inputDescription: "Periodic frequency (seconds)",
        assetCatalog: CardAssetCatalog(description: "Periodic frequency (seconds)"))
}
