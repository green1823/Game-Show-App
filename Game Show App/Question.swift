////
////  Question.swift
////  test game show interfaces
////
////  Created by Green, Jackie on 10/17/18.
////  Copyright © 2018 Green, Jackie. All rights reserved.
////
//
//import Foundation
//
//enum QuestionType {
//    case multipleChoice, trueOrFalse, buzzer
//}
//
//
//struct Question {
//    var question: String
//    var pointValue: Int
//    var type: QuestionType
//    var mcAnswers: [String]?
//    var tfAnswer: Bool?
//
//
//}


//THIS IS WHERE THE STRUCT ATTEMPT BEGINS

import CloudKit

struct Question: Codable {
    
    enum QuestionType: String, Codable {case multipleChoice, trueOrFalse, buzzer}
    
    var question: String
    var pointValue: Int
    var type: QuestionType
    var mcAnswers: [String]?
    var tfAnswer: Bool?
    var itemIdentifier: UUID
    init(question: String, pointValue: Int, type: QuestionType, mcAnswers: [String]?, tfAnswer: Bool?, itemIdentifier: UUID) {
        self.question = question
        self.pointValue = pointValue
        self.type = type
        self.mcAnswers = mcAnswers
        self.tfAnswer = tfAnswer
        self.itemIdentifier = itemIdentifier
    }
    
    func saveItem() {
        DataManager.save(self, with: "\(itemIdentifier.uuidString)")
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }

}
//THIS IS WHERE THE STRuCT ATTEMPT  ENDS

//THIS IS WHERE THE WORKING CLASS VERSION STARTS

//import Foundation
//
//class Question: NSObject, Codable {
//
//    enum QuestionType: String, Codable {
//
//        case multipleChoice, trueOrFalse, buzzer
//    }
//
////    struct PropertyKeys {
////        static let question = "question"
////        static let pointValue =  "pointValue"
////        static let type = "type"
////        static let mcAnswers = "mcAnswers"
////        static let tfAnswer = "tfAnswer"
////    }
//
//    let question: String
//    let pointValue: Int
//    let type: QuestionType
//    let mcAnswers: [String]?
//    let tfAnswer: Bool?
//    init(question: String, pointValue: Int, type: QuestionType, mcAnswers: [String]?, tfAnswer: Bool?) {
//        self.question = question
//        self.pointValue = pointValue
//        self.type = type
//        self.mcAnswers = mcAnswers
//        self.tfAnswer = tfAnswer
//    }
//}

//THIS IS WHERE THE WORKING CLASS VERSION ENDS
    
    
    
    //Methods from https://medium.com/@azamsharp/encoding-and-decoding-in-swift-4-f82114897862 - delete if they don't work
    
//    struct Language: Codable {
//        var name: String
//        var version: String
//    }
//
//    // create a new language
//    let language = Language(name: "Swift", version: "4")
//
//    // encode with one line of code
//    let data = try? language.encode()
//
//    let lang: Language? = try? Language.decode(from: data!)


//extension Serializable {
//    func serialize() -> Data? {
//        let encoder = JSONEncoder()
//        return try? encoder.encode(self)
//    }
//}
//protocol Serializable : Codable {
//    func serialize() -> Data?
//}
//
//extension Encodable {
//    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
//        return try encoder.encode(self)
//    }
//}
//
//extension Decodable {
//    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
//        return try decoder.decode(Self.self, from: data)
//    }
//}




//import Foundation
//
//class Question: NSObject, NSCoding {
//
//    enum QuestionType {
//        case multipleChoice, trueOrFalse, buzzer
//    }
//
//    struct PropertyKeys {
//        static let question = "question"
//        static let pointValue =  "pointValue"
//        static let type = "type"
//        static let mcAnswers = "mcAnswers"
//        static let tfAnswer = "tfAnswer"
//    }
//
//    let question: String
//    let pointValue: Int
//    let type: QuestionType
//    let mcAnswers: [String]?
//    let tfAnswer: Bool?
//
//    init(question: String, pointValue: Int, type: QuestionType, mcAnswers: [String]?, tfAnswer: Bool?) {
//        self.question = question
//        self.pointValue = pointValue
//        self.type = type
//        self.mcAnswers = mcAnswers
//        self.tfAnswer = tfAnswer
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let question = aDecoder.decodeObject(forKey: PropertyKeys.question) as? String,
//            let pointValue = aDecoder.decodeObject(forKey: PropertyKeys.pointValue) as? Int,
//            let type = aDecoder.decodeObject(forKey: PropertyKeys.type) as? QuestionType,
//            let mcAnswers = aDecoder.decodeObject(forKey: PropertyKeys.mcAnswers) as? [String], let tfAnswer = aDecoder.decodeObject(forKey: PropertyKeys.tfAnswer) as? Bool else {return nil}
//
//        self.init(question: question, pointValue: pointValue, type: type, mcAnswers: mcAnswers, tfAnswer: tfAnswer)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(question, forKey: PropertyKeys.question)
//        aCoder.encode(pointValue, forKey: PropertyKeys.pointValue)
//        aCoder.encode(type, forKey: PropertyKeys.type)
//        aCoder.encode(mcAnswers, forKey: PropertyKeys.mcAnswers)
//        aCoder.encode(tfAnswer, forKey: PropertyKeys.tfAnswer)
//    }
//}
