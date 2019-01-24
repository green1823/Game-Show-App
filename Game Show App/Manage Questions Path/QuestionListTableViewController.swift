

/*
 TODO:
 Find a better solution to the save button. Possibly remove the automatic back button
            We could do a solution where you drag down from the top of the screen to save?
 */
import UIKit

class QuestionListTableViewController: UITableViewController {
    
    struct PropertyKeys {
        static let questionCell = "QuestionCell"
        static let addQuestionSegue = "AddQuestion"
        static let editQuestionSegue = "EditQuestion"
        static let unwind = "UnwindToQuestionSetTable"
    }
    
    var questions: [Question] = []
    var set: QuestionSet?
    
    //    var questionArchiveURL: URL {
    //        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //        return documentsURL.appendingPathComponent("questions")
    //    }
    
    let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        guard let name = setNameTextField.text else {return}
        set = QuestionSet(questions: questions, name: name)
        performSegue(withIdentifier: PropertyKeys.unwind, sender: self)
        
        /* CODABLE ATTEMPT: wrong method? maybe move to the method that recieves unwind and creates an array of question sets in question sets list view controller */
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        updateSaveButtonState()
        
    }
    
    func updateView() {
        //checks to make sure question is not null
        guard let set = set else {return}
        setNameTextField.text = set.name
        questions = set.questions
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
    func updateSaveButtonState(){
        if(setNameTextField.text != ""){
            SaveButton.isEnabled = true;
        }else{
            SaveButton.isEnabled = false;
        }
    }
    @IBAction func setNameTextEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    //I think that this constructs each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.questionCell, for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = "Question \(String(indexPath.row + 1))"
        cell.detailTextLabel?.text = question.question
        
        return cell
    }
    
    // MARK: - Navigation
    
    //    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    //        guard let source = segue.source as? QuestionCreationViewController,
    //            let question = source.currentQuestion else {return}
    //
    //        if let indexPath = tableView.indexPathForSelectedRow {
    //            questions.remove(at: indexPath.row)
    //            questions.insert(question, at: indexPath.row)
    //            tableView.deselectRow(at: indexPath, animated: true)
    //        } else {
    //            questions.append(question)
    //        }
    //    }
    
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
        guard let source = segue.source as? QuestionCreationViewController else {return}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let QuestionCreationViewController = segue.destination as? QuestionCreationViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier == PropertyKeys.editQuestionSegue {
            QuestionCreationViewController.currentQuestion = questions[indexPath.row]
        }
    }
    
}
