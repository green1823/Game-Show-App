//
//  Answer.swift
//  Game Show App
//
//  Created by Bellini, Dan on 4/5/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation
import CloudKit

struct Answer: Codable {
    
    enum QuestionType: String, Codable {case multipleChoice, trueOrFalse, buzzer}
    enum multipleChoiceAns : Int, Codable {case 0,1,2,3,4}
    var tfAns: Bool
    var type: QuestionType
    var choiceAns: multipleChoiceAns
    var itemIdentifier: UUID
    init(multAns: multipleChoiceAns, tfAnsIn: Bool, type: QuestionType, itemIdentifier: UUID) {
        self.tfAns = tfAnsIn
        self.choiceAns = multAns
        self.type = type
        self.itemIdentifier = itemIdentifier
    }
    
    func saveItem() {
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
}
