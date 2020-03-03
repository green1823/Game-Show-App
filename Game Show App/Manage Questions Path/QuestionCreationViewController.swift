//
//  QuestionCreationViewController.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/7/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class QuestionCreationViewController: UIViewController, UITextFieldDelegate {
    
    struct PropertyKeys {
        static let unwindSave = "UnwindToQuestionListSave"
        static let unwindCancel = "UnwindToQuestionListCancel"
    }
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentQuestion: SendData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        updateView()
        updateSaveButtonState()
    }
    
    func updateView() {
        //Checks to make sure question is not null
        guard let currentQuestion = currentQuestion else {return}
        questionTextField.text = currentQuestion.content
    }
    
    func updateSaveButtonState() {
        if questionTextField.text! != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func questionTextFieldEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func save(_ sender: Any) {
        let question = questionTextField.text
        currentQuestion = SendData(content: question!, createdAt: Date(), itemIdentifier: UUID())
        self.navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: PropertyKeys.unwindSave, sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: PropertyKeys.unwindCancel, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
