import Foundation

public struct BaseCardDescs {
    private init() {}
    private static let _root = CardPath.Root
    
    public struct Action {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Action")
        
        
        public static let NoOp : ActionCardDesc = ActionCardDesc(
            path: _class,
            name: "No Operation",
            ends: true,
            description: "No operation peformed. Use as a placeholder.",
            factory: noOpFactory)
        
        private static let noOpFactory : ActionFactory = { inputs, tokens in
            return SimpleActionImpl(execute: {"%%% NO OP"})
        }
        
        public static let ExampleAction : ActionCardDesc = ActionCardDesc(
            path: _class,
            name: "Example Action",
            ends: true,
            factory: exampleActionFactory)
        
        private static let exampleActionFactory : ActionFactory = { inputs, tokens in
            return SimpleActionImpl(execute: {"%%% EXAMPLE ACTION %%%"})
        }
    }
    
    public struct Input {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Input")
        
        public struct Location {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Location")
            
            public static let Angle : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Angle",
                parameter: Double.self)
            public static let BoundingBox : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Bounding Box",
                parameter: InputCoordinate2DPath.self)
            public static let BoundingBox3D : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "3D Bounding Box",
                parameter: InputCoordinate3DPath.self)
            public static let CardinalDirection : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Cardinal Direction",
                parameter: Double.self)
            public static let Distance : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Distance",
                parameter: Double.self)
            public static let Location : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Location",
                parameter: InputCoordinate3D.self)
            public static let Path : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Path",
                parameter: InputCoordinate2DPath.self)
            public static let Path3D : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "3D Path",
                parameter: InputCoordinate3DPath.self)
        }
        
        public struct Media {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Media")
            
            public static let Audio : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Audio",
                parameter: String.self)
            public static let Image : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Image",
                parameter: String.self)
        }
        
        public struct Numeric {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Numeric")
            
            public static let Integer : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Integer",
                parameter: Int.self)
            public static let Real : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Real",
                parameter: Double.self)
        }
        
        public struct Relative {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Relative")
            
            public static let RelativeToLocation : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Relative to Location",
                parameter: InputCoordinate2D.self)
            public static let RelativeToObject : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Relative o Object",
                parameter: InputCoordinate2D.self)
        }
        
        public struct Time {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Time")
            
            public static let ClockTime : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Clock Time",
                parameter: Int.self)
            public static let Duration : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Duration",
                parameter: Int.self)
            public static let Periodicity : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Periodicity",
                parameter: Int.self)
        }
    }
    
    public struct Trigger {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Trigger")
        
        public struct Time {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Time")
            
            public static let SetATimer : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Set a Timer",
                ends: true,
                mandatoryInputs: ["duration": Input.Time.Duration])
            public static let WaitUntilTime : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait until Time",
                ends: true,
                mandatoryInputs: ["time" : Input.Time.ClockTime])
        }
    }
    
    public struct Hand {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Hand")
        
        public struct Next {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Next")

            public static let Concurrently : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Concurrently")
            public static let WithPrevious : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "WithPrevious")
            public static let Branch : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Branch")
            public static let Repeat : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Repeat")
        }
        
        public struct End {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "End")
            
            public static let All : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "All")
            public static let Any : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Any")
        }
        
        public struct Logic {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Logic")
            
            public static let Not : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Not")
            public static let And : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "And")
            public static let Or : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Or")
            public static let Xor : HandCardDesc = HandCardDesc(
                path: _subclass,
                name: "Xor")
        }
    }
    
    public struct Deck {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Deck")
        
        public static let Repeat : DeckCardDesc = DeckCardDesc(
            path: _class,
            name: "Repeat")
    }
    
    public struct Token {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Token")
        
        public static let ExampleConsumable = TokenCardDesc(
            path: _class,
            name: "Example Consumable",
            consumed: true)
        public static let ExampleSharable = TokenCardDesc(
            path: _class,
            name: "Example Sharable",
            consumed: false)
    }
}
