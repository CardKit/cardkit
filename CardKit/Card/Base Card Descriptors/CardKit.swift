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
            assetCatalog: CardAssetCatalog(description: "Set a timer"),
            version: 0)
        
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
            assetCatalog: CardAssetCatalog(description: "Wait until the specified time"),
            version: 0)
    }
}


// MARK: - Deck Cards

extension CardKit.Deck {
    // MARK: Repeat
    public static let Repeat = DeckCardDescriptor(
        name: "Repeat",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Repeat the deck"),
        version: 0)
    
    // MARK: Terminate
    public static let Terminate = DeckCardDescriptor(
        name: "Terminate",
        subpath: nil,
        assetCatalog: CardAssetCatalog(description: "Terminate the deck"),
        version: 0)
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
        assetCatalog: CardAssetCatalog(description: "Branch to the specified hand"),
        version: 0)
    
    // MARK: Repeat
    /// Descriptor for the Repeat card
    public static let Repeat = HandCardDescriptor(
        name: "Repeat",
        subpath: "Next",
        handCardType: .repeatHand,
        assetCatalog: CardAssetCatalog(description: "Repeat the hand"),
        version: 0)
}

extension CardKit.Hand.End {
    // MARK: All
    /// Descriptor for the All card
    public static let OnAll = HandCardDescriptor(
        name: "All",
        subpath: "End",
        handCardType: .endWhenAllSatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when all End conditions have been satisfied"),
        version: 0)
    
    // MARK: Any
    /// Descriptor for the Any card
    public static let OnAny = HandCardDescriptor(
        name: "Any",
        subpath: "End",
        handCardType: .endWhenAnySatisfied,
        assetCatalog: CardAssetCatalog(description: "Move to the next hand when any End condition has been satisfied"),
        version: 0)
}

extension CardKit.Hand.Logic {
    // MARK: LogicalNot
    /// Descriptor for the LogicalNot card
    public static let LogicalNot = HandCardDescriptor(
        name: "Not",
        subpath: "Logic",
        handCardType: .booleanLogicNot,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target card has NOT been satisfied"),
        version: 0)
    
    // MARK: LogicalAnd
    /// Descriptor for the LogicalAnd card
    public static let LogicalAnd = HandCardDescriptor(
        name: "And",
        subpath: "Logic",
        handCardType: .booleanLogicAnd,
        assetCatalog: CardAssetCatalog(description: "Satisfied when the target cards have both been satisfied"),
        version: 0)
    
    // MARK: LogicalOr
    /// Descriptor for the LogicalOr card
    public static let LogicalOr = HandCardDescriptor(
        name: "Or",
        subpath: "Logic",
        handCardType: .booleanLogicOr,
        assetCatalog: CardAssetCatalog(description: "Satisfied when one of the two target cards have both been satisfied"),
        version: 0)
}


// MARK: - Input Cards
    
extension CardKit.Input {
    /// Contains descriptors for Input/Location cards
    public struct Location {
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
    
    /// Contains descriptors for Input/Relative cards
    public struct Relative {
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

extension CardKit.Input.Location {
    // MARK: Location/Angle
    /// Descriptor for the Angle card
    public static let Angle = InputCardDescriptor(
        name: "Angle",
        subpath: "Location",
        inputType: .swiftDouble,
        inputDescription: "Angle (in degrees)",
        assetCatalog: CardAssetCatalog(description: "Angle (in degrees)"),
        version: 0)
    
    // MARK: Location/BoundingBox
    /// Descriptor for the Bounding Box card
    public static let BoundingBox = InputCardDescriptor(
        name: "Bounding Box",
        subpath: "Location",
        inputType: .coordinate2DPath,
        inputDescription: "Set of 2D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (2D)"),
        version: 0)
    
    // MARK: Location/BoundingBox3D
    /// Descriptor for the Bounding Box 3D card
    public static let BoundingBox3D = InputCardDescriptor(
        name: "Bounding Box 3D",
        subpath: "Location",
        inputType: .coordinate3DPath,
        inputDescription: "Set of 3D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (3D)"),
        version: 0)
    
    // MARK: Location/CardinalDirection
    /// Descriptor for the Cardinal Direction card
    public static let CardinalDirection = InputCardDescriptor(
        name: "Cardinal Direction",
        subpath: "Location",
        inputType: .cardinalDirection,
        inputDescription: "Cardinal Direction",
        assetCatalog: CardAssetCatalog(description: "Cardinal Direction (N, S, E, W)"),
        version: 0)
    
    // MARK: Location/Distance
    /// Descriptor for the Distance card
    public static let Distance = InputCardDescriptor(
        name: "Distance",
        subpath: "Location",
        inputType: .swiftDouble,
        inputDescription: "Distance (meters)",
        assetCatalog: CardAssetCatalog(description: "Distance (meters)"),
        version: 0)
    
    // MARK: Location/Location
    /// Descriptor for the Location card
    public static let Location = InputCardDescriptor(
        name: "Location",
        subpath: "Location",
        inputType: .coordinate3D,
        inputDescription: "Coordinate (3D)",
        assetCatalog: CardAssetCatalog(description: "Location (3D coordinate)"),
        version: 0)
    
    // MARK: Location/Path
    /// Descriptor for the Path card
    public static let Path = InputCardDescriptor(
        name: "Path",
        subpath: "Location",
        inputType: .coordinate2DPath,
        inputDescription: "2D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (2D)"),
        version: 0)
    
    // MARK: Location/Path3D
    /// Descriptor for the Path 3D card
    public static let Path3D = InputCardDescriptor(
        name: "Path 3D",
        subpath: "Location",
        inputType: .coordinate3DPath,
        inputDescription: "3D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (3D)"),
        version: 0)
}

extension CardKit.Input.Media {
    // MARK: Media/Audio
    /// Descriptor for the Audio card
    public static let Audio = InputCardDescriptor(
        name: "Audio",
        subpath: "Media/Audio",
        inputType: .swiftData,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Audio"),
        version: 0)
    
    // MARK: Media/Image
    /// Descriptor for the Image card
    public static let Image = InputCardDescriptor(
        name: "Image",
        subpath: "Media/Image",
        inputType: .swiftData,
        inputDescription: "Audio (data)",
        assetCatalog: CardAssetCatalog(description: "Image"),
        version: 0)
}

extension CardKit.Input.Numeric {
    // MARK: Numeric/Integer
    /// Descriptor for the Integer card
    public static let Integer = InputCardDescriptor(
        name: "Integer",
        subpath: "Numeric",
        inputType: .swiftInt,
        inputDescription: "Integer",
        assetCatalog: CardAssetCatalog(description: "Integer number"),
        version: 0)
    
    // MARK: Numeric/Real
    /// Descriptor for the Real card
    public static let Real = InputCardDescriptor(
        name: "Real",
        subpath: "Numeric",
        inputType: .swiftDouble,
        inputDescription: "Real",
        assetCatalog: CardAssetCatalog(description: "Real number"),
        version: 0)
}

extension CardKit.Input.Raw {
    // MARK: Raw/Data
    /// Descriptor for Raw/Data card
    public static let Data = InputCardDescriptor(
        name: "Data",
        subpath: "Raw",
        inputType: .swiftData,
        inputDescription: "Raw data",
        assetCatalog: CardAssetCatalog(description: "Raw data"),
        version: 0)
}

extension CardKit.Input.Relative {
    // MARK: Relative/RelativeToLocation
    /// Descriptor for the RelativeToLocation card
    public static let RelativeToLocation = InputCardDescriptor(
        name: "Relative To Location",
        subpath: "Relative",
        inputType: .coordinate2D,
        inputDescription: "Coordinate offset",
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset another coordinate"),
        version: 0)
    
    // MARK: Relative/RelativeToObject
    /// Descriptor for the RelativeToObject card
    public static let RelativeToObject = InputCardDescriptor(
        name: "Relative To Object",
        subpath: "Relative",
        inputType: .coordinate2D,
        inputDescription: "Coordinate offset",
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset from an object's location"),
        version: 0)
}

extension CardKit.Input.Text {
    // MARK: Text/String
    /// Descriptor for Text/String card
    public static let String = InputCardDescriptor(
        name: "String",
        subpath: "Text",
        inputType: .swiftString,
        inputDescription: "String",
        assetCatalog: CardAssetCatalog(description: "A string"),
        version: 0)
}

extension CardKit.Input.Time {
    // MARK: Time/ClockTime
    /// Descriptor for ClockTime card
    public static let ClockTime = InputCardDescriptor(
        name: "Clock Time",
        subpath: "Time",
        inputType: .swiftDate,
        inputDescription: "Date & time string",
        assetCatalog: CardAssetCatalog(description: "Time (date & time)"),
        version: 0)
    
    // MARK: Time/Duration
    /// Descriptor for Duration card
    public static let Duration = InputCardDescriptor(
        name: "Duration",
        subpath: "Time",
        inputType: .swiftInt,
        inputDescription: "Duration (seconds)",
        assetCatalog: CardAssetCatalog(description: "Duration (seconds)"),
        version: 0)
    
    // MARK: Time/Periodicity
    /// Descriptor for the Periodicity card
    public static let Periodicity = InputCardDescriptor(
        name: "Periodicity",
        subpath: "Time",
        inputType: .coordinate2D,
        inputDescription: "Periodic frequency (seconds)",
        assetCatalog: CardAssetCatalog(description: "Periodic frequency (seconds)"),
        version: 0)
}
