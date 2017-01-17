//
//  DateExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

extension Date {
    fileprivate static let formatter = DateFormatter()
    fileprivate static let formatString = "yyyy-MM-dd HH:mm:ss ZZZ"
    
    var localTimeString: String {
        Date.formatter.dateFormat = Date.formatString
        Date.formatter.timeZone = TimeZone.autoupdatingCurrent
        return Date.formatter.string(from: self)
    }
    
    var gmtTimeString: String {
        Date.formatter.dateFormat = Date.formatString
        Date.formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return Date.formatter.string(from: self)
    }
    
    static func date(fromTimezoneFormattedString string: String) -> Date? {
        return Date.formatter.date(from: string)
    }
}

extension Date: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        let gmtString = try json.getString()
        let formatter = DateFormatter()
        formatter.dateFormat = Date.formatString
        
        if let date = formatter.date(from: gmtString) {
            self.init(timeInterval: 0, since: date)
        } else {
            throw JSON.Error.valueNotConvertible(value: json, to: Date.self)
        }
    }
    
    public func toJSON() -> JSON {
        let gmtString = self.gmtTimeString
        return .string(gmtString)
    }
}
