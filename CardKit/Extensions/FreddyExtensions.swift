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
    public func stringify(prettyPrinted: Swift.Bool = false) -> Swift.String {
        let options: NSJSONWritingOptions =
            prettyPrinted
                ? NSJSONWritingOptions.PrettyPrinted
                : NSJSONWritingOptions.init(rawValue: 0)
        
        do {
            let data = try self.serialize()
            let obj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0))
            let prettyData = try NSJSONSerialization.dataWithJSONObject(obj, options: options)
            
            guard let str = Swift.String(data: prettyData, encoding: NSUTF8StringEncoding) else { return "" }
            return str
            
        } catch {
            return ""
        }
    }
}
