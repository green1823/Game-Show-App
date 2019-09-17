//
//  QuestionSet.swift
//  test game show interfaces
//
//  Created by Bellini, Dan on 11/16/18.
//  Copyright © 2018 Green, Jackie. All rights reserved.
import Foundation

class QuestionSet:  NSObject, Codable {
    
    struct PropertyKeys{
        
        static let questions = "questions"
        static let name = "name"
    }
    
    let questions: [Question]
    let name: String
    
    init(questions: [Question], name: String) {
        self.name = name;
        self.questions = questions;
    }
    
}



/* The NSCoding version of QuestionSet. Didn't work for storage, trying Codable. If that doesn't work, switch back to this one */
//import Foundation
//
//class QuestionSet:  NSObject, NSCoding {
//
//    struct PropertyKeys{
//
//        static let questions = "questions"
//        static let name = "name"
//    }
//
//    let questions: [Question]
//    let name: String
//
//    init(questions: [Question], name: String) {
//        self.name = name;
//        self.questions = questions;
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let questions = aDecoder.decodeObject(forKey: PropertyKeys.questions) as? [Question],
//            let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as? String else {return nil}
//
//        self.init(questions: questions, name:name)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(questions, forKey: PropertyKeys.questions)
//        aCoder.encode(name, forKey: PropertyKeys.name)
//    }
//}
