//
//  QuestionSet.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/5/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation

struct QuestionSet: Codable {
    
    var questions: [SendData]
    var name: String
    var createdAt: Date
    var itemIdentifier: UUID
    
    init (questions: [SendData], name: String, createdAt: Date, itemIdentifier: UUID) {
        self.questions = questions
        self.name = name
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
