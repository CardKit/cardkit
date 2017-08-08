//
//  CodableExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/8/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

extension JSONEncoder {
    public func boxEncode<T>(_ value: T) throws -> Data where T : Encodable {
        let box = ["value": value]
        return try self.encode(box)
    }
}

extension JSONDecoder {
    public func boxDecode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let box = try self.decode(Dictionary<String, T>.self, from: data)
        // swiftlint:disable:next force_unwrapping
        let value = box["value"]!
        return value
    }
}
