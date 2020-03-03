//
//  JoinViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 1/7/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateEnterButtonState()
        
        //Dismiss keyboard
        self.nameTextField.delegate = self
    }
    
    //Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /* Activates the enter button if there is text in nameTextField, deactivates if empty */
    func updateEnterButtonState() {
        if nameTextField.text != "" {
            enterButton.isEnabled = true
        } else {
            enterButton.isEnabled = false
        }
    }
    
    /* Updates the enter button every time the text is edited */
    @IBAction func nameTextEditingChanged(_ sender: UITextField) {
        updateEnterButtonState()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        performSegue(withIdentifier: "JoinGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?){
        if segue.destination is GameViewController {
            let vc = segue.destination as? GameViewController
            vc?.name = nameTextField.text!
        }
    }
    
    @IBAction func unwindToJoin(segue: UIStoryboardSegue) {
        guard segue.source is QuestionCreationViewController else {return}
        
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
