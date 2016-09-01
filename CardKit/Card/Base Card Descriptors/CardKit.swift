//
//  CardKit.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Defines the descriptor hierarchy for all cards in CardKit, grouped by type (Action, Deck, Hand, Input, Token). Each card's implementation should extend this struct to add a new static member for its descriptor.
// swiftlint:disable nesting
public struct CardKit {
    private init() {}
    
    // note these cannot be defined in extensions, otherwise they won't 
    // be extendable from the swift files for card implementations
    
    //MARK:- Action Cards
    
    /// Contains descriptors for Action cards
    public struct Action {
        private init() {}
        
        /// Contains descriptors for Action/Trigger cards
        public struct Trigger {
            private init() {}
            
            /// Contains descriptors for Action/Trigger/Time cards
            public struct Time {
                private init() {}
                
                //MARK: Trigger/Time/Timer
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
                
                //MARK: Triger/WaitUntilTime
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
    }
    
    //MARK:- Deck Cards
    
    /// Contains descriptors for Deck cards
    public struct Deck {
        private init() {}
        
        //MARK: Repeat
        public static let Repeat = DeckCardDescriptor(
            name: "Repeat",
            subpath: nil,
            assetCatalog: CardAssetCatalog(description: "Repeat the deck"),
            version: 0)
        
        //MARK: Terminate
        public static let Terminate = DeckCardDescriptor(
            name: "Terminate",
            subpath: nil,
            assetCatalog: CardAssetCatalog(description: "Terminate the deck"),
            version: 0)
    }
    
    //MARK:- Hand Cards
    
    /// Contains descriptors for Hand cards
    public struct Hand {
        private init() {}
        
        /// Contains descriptors for Hand/Next cards
        public struct Next {
            private init() {}
            
            //MARK: Branch
            /// Descriptor for the Branch card
            public static let Branch = HandCardDescriptor(
                name: "Branch",
                subpath: "Next",
                handCardType: .Branch,
                assetCatalog: CardAssetCatalog(description: "Branch to the specified hand"),
                version: 0)
            
            //MARK: Repeat
            /// Descriptor for the Repeat card
            public static let Repeat = HandCardDescriptor(
                name: "Repeat",
                subpath: "Next",
                handCardType: .Repeat,
                assetCatalog: CardAssetCatalog(description: "Repeat the hand"),
                version: 0)
        }
        
        /// Contains descriptors for Hand/End cards
        public struct End {
            private init() {}
            
            //MARK: All
            /// Descriptor for the All card
            public static let All = HandCardDescriptor(
                name: "All",
                subpath: "End",
                handCardType: .EndWhenAllSatisfied,
                assetCatalog: CardAssetCatalog(description: "Move to the next hand when all End conditions have been satisfied"),
                version: 0)
            
            //MARK: Any
            /// Descriptor for the Any card
            public static let Any = HandCardDescriptor(
                name: "Any",
                subpath: "End",
                handCardType: .EndWhenAnySatisfied,
                assetCatalog: CardAssetCatalog(description: "Move to the next hand when any End condition has been satisfied"),
                version: 0)
        }
        
        /// Contains descriptors for Hand/Logic cards
        public struct Logic {
            private init() {}
            
            //MARK: LogicalNot
            /// Descriptor for the LogicalNot card
            public static let LogicalNot = HandCardDescriptor(
                name: "Not",
                subpath: "Logic",
                handCardType: .BooleanLogicNot,
                assetCatalog: CardAssetCatalog(description: "Satisfied when the target card has NOT been satisfied"),
                version: 0)
            
            //MARK: LogicalAnd
            /// Descriptor for the LogicalAnd card
            public static let LogicalAnd = HandCardDescriptor(
                name: "And",
                subpath: "Logic",
                handCardType: .BooleanLogicAnd,
                assetCatalog: CardAssetCatalog(description: "Satisfied when the target cards have both been satisfied"),
                version: 0)
            
            //MARK: LogicalOr
            /// Descriptor for the LogicalOr card
            public static let LogicalOr = HandCardDescriptor(
                name: "Or",
                subpath: "Logic",
                handCardType: .BooleanLogicOr,
                assetCatalog: CardAssetCatalog(description: "Satisfied when one of the two target cards have both been satisfied"),
                version: 0)
        }
    }
    
    //MARK:- Input Cards
    
    /// Contains descriptors for Input cards
    public struct Input {
        private init() {}
        
        /// Contains descriptors for Input/Location cards
        public struct Location {
            private init() {}
            
            //MARK: Location/Angle
            /// Descriptor for the Angle card
            public static let Angle = InputCardDescriptor(
                name: "Angle",
                subpath: "Location",
                inputType: .SwiftDouble,
                inputDescription: "Angle (in degrees)",
                assetCatalog: CardAssetCatalog(description: "Angle (in degrees)"),
                version: 0)
            
            //MARK: Location/BoundingBox
            /// Descriptor for the Bounding Box card
            public static let BoundingBox = InputCardDescriptor(
                name: "Bounding Box",
                subpath: "Location",
                inputType: .Coordinate2DPath,
                inputDescription: "Set of 2D coordinates",
                assetCatalog: CardAssetCatalog(description: "Bounding Box (2D)"),
                version: 0)
            
            //MARK: Location/BoundingBox3D
            /// Descriptor for the Bounding Box 3D card
            public static let BoundingBox3D = InputCardDescriptor(
                name: "Bounding Box 3D",
                subpath: "Location",
                inputType: .Coordinate3DPath,
                inputDescription: "Set of 3D coordinates",
                assetCatalog: CardAssetCatalog(description: "Bounding Box (3D)"),
                version: 0)
            
            //MARK: Location/CardinalDirection
            /// Descriptor for the Cardinal Direction card
            public static let CardinalDirection = InputCardDescriptor(
                name: "Cardinal Direction",
                subpath: "Location",
                inputType: .CardinalDirection,
                inputDescription: "Cardinal Direction",
                assetCatalog: CardAssetCatalog(description: "Cardinal Direction (N, S, E, W)"),
                version: 0)
            
            //MARK: Location/Distance
            /// Descriptor for the Distance card
            public static let Distance = InputCardDescriptor(
                name: "Distance",
                subpath: "Location",
                inputType: .SwiftDouble,
                inputDescription: "Distance (meters)",
                assetCatalog: CardAssetCatalog(description: "Distance (meters)"),
                version: 0)
            
            //MARK: Location/Location
            /// Descriptor for the Location card
            public static let Location = InputCardDescriptor(
                name: "Location",
                subpath: "Location",
                inputType: .Coordinate3D,
                inputDescription: "Coordinate (3D)",
                assetCatalog: CardAssetCatalog(description: "Location (3D coordinate)"),
                version: 0)
            
            //MARK: Location/Path
            /// Descriptor for the Path card
            public static let Path = InputCardDescriptor(
                name: "Path",
                subpath: "Location",
                inputType: .Coordinate2DPath,
                inputDescription: "2D coordinate path",
                assetCatalog: CardAssetCatalog(description: "Path (2D)"),
                version: 0)
            
            //MARK: Location/Path3D
            /// Descriptor for the Path 3D card
            public static let Path3D = InputCardDescriptor(
                name: "Path 3D",
                subpath: "Location",
                inputType: .Coordinate3DPath,
                inputDescription: "3D coordinate path",
                assetCatalog: CardAssetCatalog(description: "Path (3D)"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Media cards
        public struct Media {
            private init() {}
            
            //MARK: Media/Audio
            /// Descriptor for the Audio card
            public static let Audio = InputCardDescriptor(
                name: "Audio",
                subpath: "Media/Audio",
                inputType: .SwiftData,
                inputDescription: "Audio (data)",
                assetCatalog: CardAssetCatalog(description: "Audio"),
                version: 0)
            
            //MARK: Media/Image
            /// Descriptor for the Image card
            public static let Image = InputCardDescriptor(
                name: "Image",
                subpath: "Media/Image",
                inputType: .SwiftData,
                inputDescription: "Audio (data)",
                assetCatalog: CardAssetCatalog(description: "Image"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Numeric cards
        public struct Numeric {
            private init() {}
            
            //MARK: Numeric/Integer
            /// Descriptor for the Integer card
            public static let Integer = InputCardDescriptor(
                name: "Integer",
                subpath: "Numeric",
                inputType: .SwiftInt,
                inputDescription: "Integer",
                assetCatalog: CardAssetCatalog(description: "Integer number"),
                version: 0)
            
            //MARK: Numeric/Real
            /// Descriptor for the Real card
            public static let Real = InputCardDescriptor(
                name: "Real",
                subpath: "Numeric",
                inputType: .SwiftDouble,
                inputDescription: "Real",
                assetCatalog: CardAssetCatalog(description: "Real number"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Raw cards
        public struct Raw {
            private init() {}
            
            //MARK: Raw/Data
            /// Descriptor for Raw/Data card
            public static let Data = InputCardDescriptor(
                name: "Data",
                subpath: "Raw",
                inputType: .SwiftData,
                inputDescription: "Raw data",
                assetCatalog: CardAssetCatalog(description: "Raw data"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Relative cards
        public struct Relative {
            private init() {}
            
            //MARK: Relative/RelativeToLocation
            /// Descriptor for the RelativeToLocation card
            public static let RelativeToLocation = InputCardDescriptor(
                name: "Relative To Location",
                subpath: "Relative",
                inputType: .Coordinate2D,
                inputDescription: "Coordinate offset",
                assetCatalog: CardAssetCatalog(description: "A coordinate used to offset another coordinate"),
                version: 0)
            
            //MARK: Relative/RelativeToObject
            /// Descriptor for the RelativeToObject card
            public static let RelativeToObject = InputCardDescriptor(
                name: "Relative To Object",
                subpath: "Relative",
                inputType: .Coordinate2D,
                inputDescription: "Coordinate offset",
                assetCatalog: CardAssetCatalog(description: "A coordinate used to offset from an object's location"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Text cards
        public struct Text {
            private init() {}
            
            //MARK: Text/String
            /// Descriptor for Text/String card
            public static let String = InputCardDescriptor(
                name: "String",
                subpath: "Text",
                inputType: .SwiftString,
                inputDescription: "String",
                assetCatalog: CardAssetCatalog(description: "A string"),
                version: 0)
        }
        
        /// Contains descriptors for Input/Time cards
        public struct Time {
            private init() {}
            
            //MARK: Time/ClockTime
            /// Descriptor for ClockTime card
            public static let ClockTime = InputCardDescriptor(
                name: "Clock Time",
                subpath: "Time",
                inputType: .SwiftDate,
                inputDescription: "Date & time string",
                assetCatalog: CardAssetCatalog(description: "Time (date & time)"),
                version: 0)
            
            //MARK: Time/Duration
            /// Descriptor for Duration card
            public static let Duration = InputCardDescriptor(
                name: "Duration",
                subpath: "Time",
                inputType: .SwiftInt,
                inputDescription: "Duration (seconds)",
                assetCatalog: CardAssetCatalog(description: "Duration (seconds)"),
                version: 0)
            
            //MARK: Time/Periodicity
            /// Descriptor for the Periodicity card
            public static let Periodicity = InputCardDescriptor(
                name: "Periodicity",
                subpath: "Time",
                inputType: .Coordinate2D,
                inputDescription: "Periodic frequency (seconds)",
                assetCatalog: CardAssetCatalog(description: "Periodic frequency (seconds)"),
                version: 0)
        }
    }
}
// swiftlint:enable nesting
