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

// MARK: - InputType

public typealias InputType = Codable.Type

// MARK: - Enumerable

public protocol Enumerable {
    static var values: [Self] { get }
}

// MARK: - StringEnumerable

public protocol StringEnumerable {
    static var stringValues: [String] { get }
}

extension StringEnumerable where Self: RawRepresentable & Enumerable, Self.RawValue == String {
    public static var stringValues: [String] {
        return values.map { $0.rawValue }
    }
}
