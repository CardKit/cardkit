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
    
    //MARK: Action Cards

    /// Contains descriptors for Action cards
    public struct Action {
        private init() {}
        
        /// Contains descriptors for Action/Trigger cards
        public struct Trigger {
            private init() {}
            
            /// Contains descriptors for Action/Trigger/Time cards
            public struct Time {
                private init() {}
            }
        }
    }

    //MARK: Deck Cards

    /// Contains descriptors for Deck cards
    public struct Deck {
        private init() {}
    }

    //MARK: Hand Cards
    
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

    //MARK: Input Cards

    /// Contains descriptors for Input cards
    public struct Input {
        private init() {}

        /// Contains descriptors for Input/Location cards
        public struct Location {
            private init() {}
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
        }
    }
    
    //MARK: Token Cards

    /// Contains descriptors for Token cards
    public struct Token {
        private init() {}
    }
}
// swiftlint:enable nesting
