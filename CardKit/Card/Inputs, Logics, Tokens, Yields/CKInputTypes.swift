//
//  CKInputTypes.swift
//  CardKit
//
//  Created by ismails on 3/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Freddy

public enum CKBool: String {
    case yes = "Yes"
    case no = "No"
}

extension CKBool: EnumerableEnum, EnumerableAsString {
    public static var values: [CKBool] {
        return [.yes, .no]
    }
}

extension CKBool: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension CKBool: JSONEncodable, JSONDecodable {}
