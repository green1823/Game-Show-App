//
//  QuestionCreationViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 10/22/18.
//  Copyright © 2018 Green, Jackie. All rights reserved.



/*
 TODO:
 When the keyboard comes up it blocks the bottom half of the screen. We need to make the screen pop upwards on top of the keyboard, with some sort of scroll view. Otherwise the question answers cant be filled in or the true/false value changed. Also, we should be able to dismiss the keyboard by clicking off the text field.
 */
//The only other things taht I could find involved disabling the debugger. To revert what I did go
//Product -> Scheme -> edit scheme -> check debug executeable.
// the only other thing that I found was about deleting the certificate. This is supposidly because the certificate is expired. maybe there is a way for us to create a nw ewone without having to delete the old one.
import UIKit

extension UISegmentedControl {

    func setFontSize(fontSize: CGFloat) {

        let normalTextAttributes: [NSObject : AnyObject] = [
            //NSAttributedStringKey.foregroundColor as NSObject: UIColor.black,
            NSAttributedStringKey.font as NSObject: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        ]

        let boldTextAttributes: [NSObject : AnyObject] = [
            //NSAttributedStringKey.foregroundColor as NSObject : UIColor.white,
            NSAttributedStringKey.font as NSObject : UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium),
            ]

        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
}

class QuestionCreationViewController: UIViewController {

    struct PropertyKeys {
        
        static let unwindSave = "UnwindToQuestionListTableWithSave"
        static let unwindCancel = "UnwindToQuestionListTableWithCancel"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Changes the size of text in questionType when on an iPad
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            questionType.setFontSize(fontSize: 30)
        }
        
        //Sets up the initial view
        trueFalseView.isHidden = false
        multipleChoiceView.isHidden = true
        updateView()
        updateSaveButtonState()
    }
    
    @IBOutlet weak var answerField1: UITextField!
    @IBOutlet weak var answerField2: UITextField!
    @IBOutlet weak var answerField3: UITextField!
    @IBOutlet weak var tfSwitch: UISwitch!
    @IBOutlet weak var answerField4: UITextField!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var pointValueTextField: UITextField!
    @IBOutlet weak var questionType: UISegmentedControl!
    @IBOutlet weak var trueFalseView: UIView!
    @IBOutlet weak var multipleChoiceView: UIView!
    @IBOutlet weak var saveButton: UIButton!

    var currentQuestion: Question?
    
    /* Updates view when the question is sent in from tableView before it */
    func updateView() {
        
        //checks to make sure question is not null
        guard let currentQuestion = currentQuestion else {return}
        questionTextField.text = currentQuestion.question
        pointValueTextField.text = String(currentQuestion.pointValue)
        
        //switch case to determine what to do for each question
        switch (currentQuestion.type) {
        case .trueOrFalse:
            questionType.selectedSegmentIndex = 0
            //sets the tf switch to inital value *must unwrap*
            tfSwitch.setOn((currentQuestion.tfAnswer)!,animated: true)
                break
        case .buzzer:
            questionType.selectedSegmentIndex = 1
            break
        case .multipleChoice:
            questionType.selectedSegmentIndex = 2
            //sets the inital text from each value of the MC array *must unwrap*
            answerField1.text = currentQuestion.mcAnswers?[0]
            answerField2.text = currentQuestion.mcAnswers?[1]
            answerField3.text = currentQuestion.mcAnswers?[2]
            answerField4.text = currentQuestion.mcAnswers?[3]
            break
        }
        questionTypeChanged(questionType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Changes views when the segmented control is used */
    @IBAction func questionTypeChanged(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            trueFalseView.isHidden = false
            multipleChoiceView.isHidden = true
        case 1:
            trueFalseView.isHidden = true
            multipleChoiceView.isHidden = true
        case 2:
            trueFalseView.isHidden = true
            multipleChoiceView.isHidden = false
        default:
            break;
        }
    }

    func updateSaveButtonState() {
        if let _: Int = Int(pointValueTextField.text!){
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    @IBAction func pointValueTextEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func save(_ sender: Any) {
        if let points: Int = Int(pointValueTextField.text!) {
            guard let question = questionTextField.text else{return}
            var qType: Question.QuestionType
            var tfAns: Bool = false
            var mcAns: [String] = []
            switch questionType.selectedSegmentIndex {
            case 0:
                qType = Question.QuestionType.trueOrFalse
                tfAns = tfSwitch.isOn
                break;
            case 1:
                qType = Question.QuestionType.buzzer
                break;
            case 2:
                qType = Question.QuestionType.multipleChoice
                guard let a1 = answerField1.text, let a2 = answerField2.text, let a3 = answerField3.text, let a4 = answerField4.text else {return}
                mcAns = [a1, a2, a3, a4]
                break;
            default:
                qType = Question.QuestionType.buzzer
                break;
            }
            currentQuestion = Question(question: question, pointValue: points, type: qType, mcAnswers: mcAns, tfAnswer: tfAns)
            performSegue(withIdentifier: PropertyKeys.unwindSave, sender: self)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.unwindCancel, sender: self)
    }
    
 
        
}
