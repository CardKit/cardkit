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

// MARK: BindsWithTokenCard

/// Applied to card instances that accept tokens
protocol BindsWithTokenCard {
    // mutating binds
    mutating func bind(with card: TokenCard, in slot: TokenSlot) throws
    mutating func bind(with card: TokenCard, inSlotNamed name: String) throws
    mutating func unbind(_ slot: TokenSlot)
    
    // non-mutating binds
    func bound(with card: TokenCard, in slot: TokenSlot) throws -> ActionCard
    func bound(with card: TokenCard, inSlotNamed name: String) throws -> ActionCard
    func unbound(_ slot: TokenSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(_ slot: TokenSlot) -> Bool
    
    // retrieve the binding of a slot
    func binding(of slot: TokenSlot) -> TokenSlotBinding
    func cardIdentifierBound(to slot: TokenSlot) -> CardIdentifier?
}
