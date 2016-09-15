//
//  FreddyExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

extension JSON {
    public func stringify(_ prettyPrinted: Swift.Bool = false) -> Swift.String {
        let options: JSONSerialization.WritingOptions =
            prettyPrinted
                ? JSONSerialization.WritingOptions.prettyPrinted
                : JSONSerialization.WritingOptions.init(rawValue: 0)
        
        do {
            let data = try self.serialize()
            let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            let prettyData = try JSONSerialization.data(withJSONObject: obj, options: options)
            
            guard let str = Swift.String(data: prettyData, encoding: String.Encoding.utf8) else { return "" }
            return str
            
        } catch {
            return ""
        }
    }
}
