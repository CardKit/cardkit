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

public struct CardPath: Codable {
    fileprivate let pathComponents: [String]
    
    /// Create a CardPath from a path string. Path strings are of the form "a/b/c" (e.g. "Input/Location").
    init(withPath path: String) {
        self.pathComponents = path.split(separator: "/").map(String.init)
    }
}

// MARK: Equatable

extension CardPath: Equatable {
    static public func == (lhs: CardPath, rhs: CardPath) -> Bool {
        if lhs.pathComponents.count != rhs.pathComponents.count { return false }
        for i in 0..<lhs.pathComponents.count {
            if lhs.pathComponents[i] != rhs.pathComponents[i] {
                return false
            }
        }
        return true
    }
}

// MARK: Hashable

extension CardPath: Hashable {
    public var hashValue: Int {
        // sum up the hash values of all the components
        return self.pathComponents.reduce(0, { $0 &+ $1.hashValue })
    }
}

// MARK: CustomStringConvertible

extension CardPath: CustomStringConvertible {
    public var description: String {
        return self.pathComponents.joined(separator: "/")
    }
}
