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
                
                //MARK: Trigger/Time
                /// Descriptor for Timer card
                public static let Timer = ActionCardDescriptor(
                    name: "Timer",
                    subpath: "Trigger/Time",
                    description: "Set a timer",
                    assetCatalog: CardAssetCatalog(),
                    inputs: [
                        InputSlot(
                            identifier: "Duration",
                            type: InputType.SwiftDouble,
                            isOptional: false)
                    ],
                    tokens: nil,
                    yields: nil,
                    yieldDescription: nil,
                    ends: true,
                    endsDescription: "Ends after the specified duration",
                    version: 0)
                
                //MARK: Triger/WaitUntilTime
                /// Descriptor for WaitUntilTime card
                public static let WaitUntilTime = ActionCardDescriptor(
                    name: "Wait Until Time",
                    subpath: "Trigger/Time",
                    description: "Wait until the specified time",
                    assetCatalog: CardAssetCatalog(),
                    inputs: [
                        InputSlot(
                            identifier: "ClockTime",
                            type: InputType.SwiftDouble,
                            isOptional: false)
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
    }
    
    //MARK:- Hand Cards
    
    /// Contains descriptors for Hand cards
    public struct Hand {
        private init() {}
        
        /// Contains descriptors for Hand/Next cards
        public struct Next {
            private init() {}
        }
        
        /// Contains descriptors for Hand/End cards
        public struct End {
            private init() {}
        }
        
        /// Contains descriptors for Hand/Logic cards
        public struct Logic {
            private init() {}
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
            /// Descriptor for Angle card
            public static let Angle = InputCardDescriptor(
                name: "Angle",
                subpath: "Location",
                description: "Angle (in degrees)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDouble,
                inputDescription: "Angle (in degrees)",
                version: 0)
            
            //MARK: Location/BoundingBox
            /// Descriptor for Bounding Box card
            public static let BoundingBox = InputCardDescriptor(
                name: "Bounding Box",
                subpath: "Location",
                description: "Bounding Box (2D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2DPath,
                inputDescription: "Set of 2D coordinates",
                version: 0)
            
            //MARK: Location/BoundingBox3D
            /// Descriptor for Bounding Box 3D card
            public static let BoundingBox3D = InputCardDescriptor(
                name: "Bounding Box 3D",
                subpath: "Location",
                description: "Bounding Box (3D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate3DPath,
                inputDescription: "Set of 3D coordinates",
                version: 0)
            
            //MARK: Location/CardinalDirection
            /// Descriptor for Cardinal Direction card
            public static let CardinalDirection = InputCardDescriptor(
                name: "Cardinal Direction",
                subpath: "Location",
                description: "Cardinal Direction (N, S, E, W)",
                assetCatalog: CardAssetCatalog(),
                inputType: .CardinalDirection,
                inputDescription: "Cardinal Direction",
                version: 0)
            
            //MARK: Location/Distance
            /// Descriptor for Distance card
            public static let Distance = InputCardDescriptor(
                name: "Distance",
                subpath: "Location",
                description: "Distance (meters)",
                assetCatalog: CardAssetCatalog(),
                inputType: .SwiftDouble,
                inputDescription: "Distance (meters)",
                version: 0)
            
            //MARK: Location/Location
            /// Descriptor for Location card
            public static let Location = InputCardDescriptor(
                name: "Location",
                subpath: "Location",
                description: "Location (3D coordinate)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate3D,
                inputDescription: "Coordinate (3D)",
                version: 0)
            
            //MARK: Location/Path
            /// Descriptor for Path card
            public static let Path = InputCardDescriptor(
                name: "Path",
                subpath: "Location",
                description: "Path (2D)",
                assetCatalog: CardAssetCatalog(),
                inputType: .Coordinate2DPath,
                inputDescription: "2D coordinate path",
                version: 0)
            
            //MARK: Location/Path3D
            /// Descriptor for Path 3D card
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
        }
        
        /// Contains descriptors for Input/Numeric cards
        public struct Numeric {
            private init() {}
        }
        
        /// Contains descriptors for Input/Relative cards
        public struct Relative {
            private init() {}
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
        }
    }
    
    //MARK:- Token Cards
    
    /// Contains descriptors for Token cards
    public struct Token {
        private init() {}
    }
}
// swiftlint:enable nesting
