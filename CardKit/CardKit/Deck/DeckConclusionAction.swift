//
//  DeckConclusionAction.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public enum DeckConclusionAction: String {
    case Repeat
    case Terminate
}

//MARK: JSONEncodable

extension DeckConclusionAction: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Repeat:
            return .String("Repeat")
        case .Terminate:
            return .String("Terminate")
        }
    }
}

//MARK: JSONDecodable

extension DeckConclusionAction: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = DeckConclusionAction(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: DeckConclusionAction.self)
        }
        self = typeEnum
    }
}
