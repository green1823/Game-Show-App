//
//  QuestionListTableViewController.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/5/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import UIKit

class QuestionListTableViewController: UITableViewController, UITextFieldDelegate {

    struct PropertyKeys {
        static let questionCell = "QuestionCell"
        static let addQuestionSegue = "AddQuestion"
        static let editQuestionSegue = "EditQuestion"
        static let unwindSave = "UnwindToQuestionSetSave"
        static let unwindCancel = "UnwindToQuestionSetCancel"
    }
    
    var questions: [SendData] = []
    var set: QuestionSet?
        
    @IBOutlet weak var setNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        self.hideKeyboardWhenTappedAround()
        
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Displays Questions when returning from
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func updateView() {
        // checks to make sure question is not null
        guard let set = set else {return}
        setNameTextField.text = set.name
        questions = set.questions
    }
    
    @IBAction func BackSaveButton(_ sender: Any) {
        
        if (setNameTextField.text != "") {
            // If the set has a title, save it
            guard let name = setNameTextField.text else {return}
            set?.deleteItem()
            set = QuestionSet(questions: questions, name: name, createdAt: Date(), itemIdentifier: UUID())
            set?.saveItem()
            performSegue(withIdentifier: PropertyKeys.unwindSave, sender: self)
        } else if (questions.count > 0) {
            // If a set has questions and no title, shake the text field to alert
            setNameTextField.shake()
        } else {
            // If set has no questions or title, cancel
            performSegue(withIdentifier: PropertyKeys.unwindCancel, sender: self)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.questionCell, for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = "Question \(String(indexPath.row + 1))"
        cell.detailTextLabel?.text = question.content

        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.questions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        tableView.reloadData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    @IBAction func unwindToQuestionListSave(segue: UIStoryboardSegue) {
        guard let source = segue.source as? QuestionCreationViewController, let currentQuestion = source.currentQuestion else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            questions.remove(at: indexPath.row)
            questions.insert(currentQuestion, at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            questions.append(currentQuestion)
        }
    }
    
    @IBAction func unwindToQuestionListCancel(segue: UIStoryboardSegue) {
        guard segue.source is QuestionCreationViewController else {return}
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let QuestionCreationViewController = segue.destination as? QuestionCreationViewController else {return}
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == PropertyKeys.editQuestionSegue {
            QuestionCreationViewController.currentQuestion = questions[indexPath.row]
        }
    }
}


/* Enables shake animation */
extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}

