//
//  CodableExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/8/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

extension Encodable {
    public func boxedEncoding() -> Data? {
        let encoder = JSONEncoder()
        let box = ["value": self]
        do {
            let data = try encoder.encode(box)
            return data
        } catch {
            return nil
        }
    }
}

extension Data {
    public func unboxedValue<T>() -> T? where T: Codable {
        let decoder = JSONDecoder()
        do {
            let box = try decoder.decode(Dictionary<String, T>.self, from: self)
            guard let value = box["value"] else { return nil }
            return value
        } catch {
            return nil
        }
    }
}
