//
//  SendData.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/4/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation

struct SendData: Codable {

var content: String
    var createdAt: Date
var itemIdentifier: UUID

    init (content: String, createdAt: Date, itemIdentifier: UUID) {
        self.content = content
        self.createdAt = createdAt
        self.itemIdentifier = itemIdentifier
    }
    
    func saveItem() {
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }

    
}
