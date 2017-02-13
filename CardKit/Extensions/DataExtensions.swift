//
//  DataExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

extension Data: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        let base64 = try json.getString()
        
        // there's probably a better way to do this
        if Data(base64Encoded: base64) != nil {
            //seems like we're forced to ! it here becuase of the method signature
            self.init(base64Encoded: base64)!
        } else {
            throw JSON.Error.valueNotConvertible(value: json, to: Data.self)
        }
    }
    
    public func toJSON() -> JSON {
        let base64 = self.base64EncodedString()
        return .string(base64)
    }
}
