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

// MARK: BindsWithInputCard

/// Applied to card instances that bind with Input cards
protocol BindsWithInputCard {
    // mutating binds
    mutating func bind(with card: InputCard) throws
    mutating func bind(with card: InputCard, in slot: InputSlot) throws
    mutating func bind(with card: InputCard, inSlotNamed name: String) throws
    mutating func unbind(_ slot: InputSlot)
    
    // non-mutating binds
    func bound(with card: InputCard) throws -> ActionCard
    func bound(with card: InputCard, in slot: InputSlot) throws -> ActionCard
    func bound(with card: InputCard, inSlotNamed name: String) throws -> ActionCard
    func unbound(_ slot: InputSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(_ slot: InputSlot) -> Bool
    
    // retrieve the binding of a slot
    func binding(of slot: InputSlot) -> InputSlotBinding?
    func value<T>(of slot: InputSlot) -> T? where T: Codable
}
