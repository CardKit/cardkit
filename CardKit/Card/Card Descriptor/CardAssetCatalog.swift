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

public struct CardAssetCatalog: Codable {
    public var textualDescription: String
    public var cardImageName: String
    
    public init() {
        self.textualDescription = ""
        self.cardImageName = ""
    }
    
    public init(description: String, cardImageName: String) {
        self.textualDescription = description
        self.cardImageName = cardImageName
    }
}
