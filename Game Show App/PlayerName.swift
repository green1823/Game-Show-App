//
//  PlayerName.swift
//  Game Show App
//
//  Created by Green, Jackie on 9/24/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation
import CloudKit

struct PlayerName: Codable {
    
    var name: String
    var itemIdentifier: UUID
    
    init(name: String, itemIdentifier: UUID) {
        self.name = name
        self.itemIdentifier = itemIdentifier
    }
    
    func saveItem() {
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
}
