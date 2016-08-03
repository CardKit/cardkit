//
//  CardKitDescriptors.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Defines the descriptor hierarchy for all cards in CardKit, grouped by type (Action, Deck, Hand, Input, Token). Each card's implementation should extend this struct to add a new static member for its descriptor.
// swiftlint:disable nesting
public struct CKDescriptors {
    private init() {}
    
    // note these cannot be defined in extensions, otherwise they won't 
    // be extendable from the swift files for card implementations
    
    //MARK:- Action Cards
    
    /// Contains descriptors for Action cards
    public struct Action {
        private init() {}
        
        //MARK: NoAction
        /// Descriptor for NoAction card
        public static let NoAction = ActionCardDescriptor(
            name: "No Action",
            subpath: nil,
            description: "No action performed.",
            assetCatalog: CardAssetCatalog(),
            inputs: nil,
            tokens: nil,
            yields: nil,
            yieldDescription: nil,
            ends: true,
            endsDescription: "Ends instantly.",
            version: 0)
        
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
                    description: "Set a timer",
                    assetCatalog: CardAssetCatalog(),
                    inputs: [
                        InputSlot(identifier: "Duration", type: InputType.SwiftDouble, isOptional: false)
                    ],
                    tokens: nil,
                    yields: nil,
                    yieldDescription: nil,
                    ends: true,
                    endsDescription: "Ends after the specified duration",
                    version: 0)
                
                //MARK: Trigger/Time/SetATimer
                /// Descriptor for the SetATimer card
                public static let SetATimer = ActionCardDescriptor(
                    name: "Set A Timer",
                    subpath: "Trigger/Time",
                    description: "Set a timer (seconds)",
                    assetCatalog: CardAssetCatalog(),
                    inputs: [
                        InputSlot(identifier: "Duration", type: .SwiftInt, isOptional: false)
                    ],
                    tokens: nil,
                    yields: nil,
                    yieldDescription: nil,
                    ends: true,
                    endsDescription: "Ends after the specified duration",
                    version: 0)
                
                //MARK: Triger/WaitUntilTime
                /// Descriptor for the WaitUntilTime card
                public static let WaitUntilTime = ActionCardDescriptor(
                    name: "Wait Until Time",
                    subpath: "Trigger/Time",
                    description: "Wait until the specified time",
                    assetCatalog: CardAssetCatalog(),
                    inputs: [
                        InputSlot(identifier: "ClockTime", type: InputType.SwiftDouble, isOptional: false)
                    ],
                    tokens: nil,
                    yields: nil,
                    yieldDescription: nil,
                    ends: true,
                    endsDescription: "Ends when the specified time is reached",
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
            description: "Repeat the deck",
            assetCatalog: CardAssetCatalog(),
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
                description: "Branch to the specified hand",
                assetCatalog: CardAssetCatalog(),
                logicType: .Branch,
                version: 0)
            
            //MARK: Repeat
            /// Descriptor for the Repeat card
            public static let Repeat = HandCardDescriptor(
                name: "Repeat",
                subpath: "Next",
                description: "Repeat the hand",
                assetCatalog: CardAssetCatalog(),
                logicType: .Repeat,
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
                description: "Move to the next hand when all End conditions have been satisfied",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
                version: 0)
            
            //MARK: Any
            /// Descriptor for the Any card
            public static let Any = HandCardDescriptor(
                name: "Any",
                subpath: "End",
                description: "Move to the next hand when any End condition has been satisfied",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
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
                description: "Satisfied when the target card has NOT been satisfied",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
                version: 0)
            
            //MARK: LogicalAnd
            /// Descriptor for the LogicalAnd card
            public static let LogicalAnd = HandCardDescriptor(
                name: "And",
                subpath: "Logic",
                description: "Satisfied when the target cards have both been satisfied",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
                version: 0)
            
            //MARK: LogicalOr
            /// Descriptor for the LogicalOr card
            public static let LogicalOr = HandCardDescriptor(
                name: "Or",
                subpath: "Logic",
                description: "Satisfied when one of the two target cards have both been satisfied",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
                version: 0)
            
            //MARK: LogicalXor
            /// Descriptor for the LogicalXor card
            public static let LogicalXor = HandCardDescriptor(
                name: "Xor",
                subpath: "Logic",
                description: "Satisfied when only one of the two target cards has been satisfied (NOTE: functionally this is probably the same as OR)",
                assetCatalog: CardAssetCatalog(),
                logicType: .SatisfactionLogic,
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
                description: "Angle (in degrees)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDouble,
                inputDescription: "Angle (in degrees)",
                version: 0)
            
            //MARK: Location/BoundingBox
            /// Descriptor for the Bounding Box card
            public static let BoundingBox = InputCardDescriptor(
                name: "Bounding Box",
                subpath: "Location",
                description: "Bounding Box (2D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2DPath,
                inputDescription: "Set of 2D coordinates",
                version: 0)
            
            //MARK: Location/BoundingBox3D
            /// Descriptor for the Bounding Box 3D card
            public static let BoundingBox3D = InputCardDescriptor(
                name: "Bounding Box 3D",
                subpath: "Location",
                description: "Bounding Box (3D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate3DPath,
                inputDescription: "Set of 3D coordinates",
                version: 0)
            
            //MARK: Location/CardinalDirection
            /// Descriptor for the Cardinal Direction card
            public static let CardinalDirection = InputCardDescriptor(
                name: "Cardinal Direction",
                subpath: "Location",
                description: "Cardinal Direction (N, S, E, W)",
                assetCatalog: CardAssetCatalog(),
                inputType: .CardinalDirection,
                inputDescription: "Cardinal Direction",
                version: 0)
            
            //MARK: Location/Distance
            /// Descriptor for the Distance card
            public static let Distance = InputCardDescriptor(
                name: "Distance",
                subpath: "Location",
                description: "Distance (meters)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDouble,
                inputDescription: "Distance (meters)",
                version: 0)
            
            //MARK: Location/Location
            /// Descriptor for the Location card
            public static let Location = InputCardDescriptor(
                name: "Location",
                subpath: "Location",
                description: "Location (3D coordinate)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate3D,
                inputDescription: "Coordinate (3D)",
                version: 0)
            
            //MARK: Location/Path
            /// Descriptor for the Path card
            public static let Path = InputCardDescriptor(
                name: "Path",
                subpath: "Location",
                description: "Path (2D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2DPath,
                inputDescription: "2D coordinate path",
                version: 0)
            
            //MARK: Location/Path3D
            /// Descriptor for the Path 3D card
            public static let Path3D = InputCardDescriptor(
                name: "Path 3D",
                subpath: "Location",
                description: "Path (3D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate3DPath,
                inputDescription: "3D coordinate path",
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
                description: "Audio",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftData,
                inputDescription: "Audio (data)",
                version: 0)
            
            //MARK: Media/Image
            /// Descriptor for the Image card
            public static let Image = InputCardDescriptor(
                name: "Image",
                subpath: "Media/Image",
                description: "Image",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftData,
                inputDescription: "Audio (data)",
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
                description: "Integer number",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftInt,
                inputDescription: "Integer",
                version: 0)
            
            //MARK: Numeric/Real
            /// Descriptor for the Real card
            public static let Real = InputCardDescriptor(
                name: "Real",
                subpath: "Numeric",
                description: "Real number",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDouble,
                inputDescription: "Real",
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
                description: "A coordinate used to offset another coordinate",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2D,
                inputDescription: "Coordinate offset",
                version: 0)
            
            //MARK: Relative/RelativeToObject
            /// Descriptor for the RelativeToObject card
            public static let RelativeToObject = InputCardDescriptor(
                name: "Relative To Object",
                subpath: "Relative",
                description: "A coordinate used to offset from an object's location",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2D,
                inputDescription: "Coordinate offset",
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
                description: "Time (date & time)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDate,
                inputDescription: "Date & time string",
                version: 0)
            
            //MARK: Time/Duration
            /// Descriptor for Duration card
            public static let Duration = InputCardDescriptor(
                name: "Duration",
                subpath: "Time",
                description: "Duration (seconds)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftInt,
                inputDescription: "Duration (seconds)",
                version: 0)
            
            //MARK: Time/Periodicity
            /// Descriptor for the Periodicity card
            public static let Periodicity = InputCardDescriptor(
                name: "Periodicity",
                subpath: "Time",
                description: "Periodic frequency (seconds)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2D,
                inputDescription: "Periodic frequency (seconds)",
                version: 0)
        }
    }
    
    //MARK:- Token Cards
    
    /// Contains descriptors for Token cards
    public struct Token {
        private init() {}
    }
}
// swiftlint:enable nesting
