//
//  CardKitDescriptors.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public struct CKDescriptors {}

//MARK: Action Cards

extension CKDescriptors {
    public struct Action {
        private init() {}
        private static let subpath = ""
        
        public static let NoOp = ActionCardDescriptor(
            name: "NoOp",
            subpath: subpath,
            description: "No operation performed. Used as a placeholder",
            assetCatalog: CardAssetCatalog(),
            mandatoryInputs: nil,
            optionalInputs: nil,
            tokens: nil,
            yields: false,
            yieldDescription: "",
            ends: true,
            endsDescription: "Ends instantly",
            version: 0)
    }
}

//MARK: Deck Cards

extension CKDescriptors {
    public struct Deck {
        private init() {}
    }
}

//MARK: Hand Cards

extension CKDescriptors {
    public struct Hand {
        private init() {}
    }
}

//MARK: Input Cards

extension CKDescriptors {
    public struct Input {
        private init() {}
        
        public struct Location {
            private init() {}
            private static let subpath = "Location"
            
            public static let Angle = InputCardDescriptor(
                name: "Angle",
                subpath: subpath,
                description: "Angle",
                assetCatalog: CardAssetCatalog(),
                version: 0)
            
            public static let BoundingBox = InputCardDescriptor(
                name: "Bounding Box",
                subpath: subpath,
                description: "Bounding box",
                assetCatalog: CardAssetCatalog(),
                version: 0)
            
            public static let BoundingBox3D = InputCardDescriptor(
                name: "Bounding Box 3D",
                subpath: subpath,
                description: "3D bounding box",
                assetCatalog: CardAssetCatalog(),
                version: 0)
        }
    }
}

//MARK: Token Cards

extension CKDescriptors {
    public struct Token {
        private init() {}
    }
}
