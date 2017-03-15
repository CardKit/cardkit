//
//  CKInputTypes.swift
//  CardKit
//
//  Created by ismails on 3/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Freddy

public enum CKBool: String, InputProtocol, EnumerableEnum, CustomStringConvertible, JSONEncodable, JSONDecodable {
    case ckTrue = "True"
    case ckFalse = "False"
    
    //static vars
    public static var defaultUnit: String? {
        return nil
    }
    
    public static var inputDetails: [InputDetails] {
        return [.choices(self.allValues.map { $0.rawValue })]
    }
    
    public static var allValues: [CKBool] {
        return [.ckTrue, .ckFalse]
    }
    
    //instance vars
    public var description: String {
        return self.rawValue
    }
    
    public var boolValue: Bool {
        switch self {
        case .ckTrue:
            return true
        case .ckFalse:
            return false
        }
    }
}
