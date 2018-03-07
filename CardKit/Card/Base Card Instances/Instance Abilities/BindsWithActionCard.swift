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

// MARK: BindsWithActionCard

/// Applied to card instances that bind with Action cards (i.e. bind to their yield values)
protocol BindsWithActionCard {
    // mutating binds
    mutating func bind(with card: ActionCard, yield: Yield, in slot: InputSlot)
    mutating func bind(with card: ActionCard, yield: Yield) throws
    mutating func unbind(_ slot: InputSlot)
    
    // non-mutating binds
    func bound(with card: ActionCard, yield: Yield, in slot: InputSlot) -> ActionCard
    func bound(with card: ActionCard, yield: Yield) throws -> ActionCard
    func unbound(_ slot: InputSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(_ slot: InputSlot) -> Bool
    
    // retrieve the binding of the slot
    func binding(of slot: InputSlot) -> InputSlotBinding?
}
