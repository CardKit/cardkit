//
//  DateExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 7/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension NSDate {
    private static let _formatter = NSDateFormatter()
    private static let _formatString = "yyyy-MM-dd HH:mm:ss ZZZ"
    
    var localTimeString: String {
        get {
            NSDate._formatter.dateFormat = NSDate._formatString
            NSDate._formatter.timeZone = NSTimeZone.localTimeZone()
            return NSDate._formatter.stringFromDate(self)
        }
    }
    
    var gmtTimeString: String {
        get {
            NSDate._formatter.dateFormat = NSDate._formatString
            NSDate._formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            return NSDate._formatter.stringFromDate(self)
        }
    }
    
    static func date(fromTimezoneFormattedString string: String) -> NSDate? {
        return NSDate._formatter.dateFromString(string)
    }
}
