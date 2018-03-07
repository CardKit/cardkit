/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

// MARK: YieldType
public typealias YieldType = InputType

// MARK: YieldIdentifier
public typealias YieldIdentifier = UUID

// MARK: - Yield

public struct Yield: Codable {
    public let identifier: YieldIdentifier
    
    // in the future, this should be Any.Type. however, swift3 has no way
    // to take a String and figure out the Swift struct type that corresponds to
    // that String (e.g. "Dictionary<Int, Int>" -> Dictionary<Int, Int>)
    public let type: String
    
    public init(type: YieldType) {
        self.identifier = UUID()
        
        // remove the ".Type" suffix
        let typeStr = String(describing: Swift.type(of: type))
        if typeStr.hasSuffix(".Type") {
            let index = typeStr.index(typeStr.endIndex, offsetBy: -5)
            self.type = String(typeStr[..<index])
        } else {
            self.type = typeStr
        }
    }
    
    public func matchesType<T>(of value: T) -> Bool {
        let valueType = String(describing: Swift.type(of: value))
        return self.type == valueType
    }
}

// MARK: Equatable

extension Yield: Equatable {
    static public func == (lhs: Yield, rhs: Yield) -> Bool {
        var equal = true
        equal = equal && lhs.identifier == rhs.identifier
        equal = equal && lhs.type == rhs.type
        return equal
    }
}

// MARK: Hashable

extension Yield: Hashable {
    public var hashValue: Int {
        return "\(self.identifier).\(self.type)".hashValue
    }
}

// MARK: CustomStringConvertible

extension Yield: CustomStringConvertible {
    public var description: String {
        return "\(self.identifier) [\(self.type)]"
    }
}
