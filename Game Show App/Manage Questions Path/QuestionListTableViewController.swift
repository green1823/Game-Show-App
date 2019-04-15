/*
 TODO:
 N/A
 */
import UIKit

class QuestionListTableViewController: UITableViewController, UITextFieldDelegate {
    
    struct PropertyKeys {
        static let questionCell = "QuestionCell"
        static let addQuestionSegue = "AddQuestion"
        static let editQuestionSegue = "EditQuestion"
        static let unwind = "UnwindToQuestionSetTable"
        static let unwindCancel = "UnwindToQuestionSetTableCancel"
    }
    
    var questions: [Question] = []
    var set: QuestionSet?
    
    let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        //Dismiss keyboard
        self.setNameTextField.delegate = self
    }
    
    func updateView() {
        //checks to make sure question is not null
        guard let set = set else {return}
        setNameTextField.text = set.name
        questions = set.questions
    }
    
    //Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func BackButton(_ sender: Any) {
        
        if(setNameTextField.text != ""){
            // If the set has a title, save it
            guard let name = setNameTextField.text else {return}
            set = QuestionSet(questions: questions, name: name)
            performSegue(withIdentifier: PropertyKeys.unwind, sender: self)
        }else if (questions.count > 0){
            // If a set has questions and no title, shake the text field to alert
            setNameTextField.shake()
        } else {
            // If set has no questions or title, cancel
            performSegue(withIdentifier: PropertyKeys.unwindCancel, sender: self)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.questions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            /*
            This saves the whole question/questionSet file structure not just the idividual
            questions on the screen
             */
            let archiveUrl = documentsDirectory.appendingPathComponent("set_test").appendingPathExtension("plist")
            let propertyListEncoder = PropertyListEncoder()
            let encodedQuestionSet = try? propertyListEncoder.encode(questions);
            try? encodedQuestionSet?.write(to: archiveUrl, options: .noFileProtection);
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    /* Constructs each cell */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.questionCell, for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = "Question \(String(indexPath.row + 1))"
        cell.detailTextLabel?.text = question.question
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToQuestionListWithSave(segue: UIStoryboardSegue) {
        guard let source = segue.source as? QuestionCreationViewController, let currentQuestion = source.currentQuestion else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            questions.remove(at: indexPath.row)
            questions.insert(currentQuestion, at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            questions.append(currentQuestion)
        }
    }
    
    @IBAction func unwindToQuestionListWithCancel(segue: UIStoryboardSegue) {
        guard segue.source is QuestionCreationViewController else {return}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let QuestionCreationViewController = segue.destination as? QuestionCreationViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier == PropertyKeys.editQuestionSegue {
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
