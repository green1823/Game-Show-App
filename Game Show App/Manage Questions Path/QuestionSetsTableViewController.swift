//
//  QuestionSetsTableViewController.swift
//  test game show interfaces
//
//  Created by Green, Jackie on 10/25/18.
//  Copyright © 2018 Green, Jackie. All rights reserved.
//

/*
 TODO:
 Add a delete QuestionSet option. This must not only remove the object from the list, but also the version stored with codable.
 */
import UIKit

class QuestionSetsTableViewController: UITableViewController {

    struct PropertyKeys {
        static let questionSetCell = "QuestionSetCell"
        static let addQuestionSetSegue = "AddQuestionSet"
        static let editQuestionSetSegue = "EditQuestionSet"
    }
    
    var questionSets: [QuestionSet] = []
    
    var questionSetArchiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("questionSets")
    }
    //need for decoding
    let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    //end
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        //Declares a global instance of QuestionSets, allows it to be accessed from other view controllers
        let userDefaults = UserDefaults.standard
        userDefaults.set(questionSets, forKey: "QuestionSets")
        questionSets = userDefaults.object(forKey: "QuestionSets") as! [QuestionSet]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //need for decoding
        let archiveUrl = documentsDirectory.appendingPathComponent("set_test").appendingPathExtension("plist")
        let propertyListDecoder2 = PropertyListDecoder();
        if let retrievedQuestionSetData = try? Data(contentsOf: archiveUrl), let decodedQuestionSet = try? propertyListDecoder2.decode([QuestionSet].self,from: retrievedQuestionSetData){
            questionSets = decodedQuestionSet
        }
        //end
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionSets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.questionSetCell, for: indexPath)

        let questionSet = questionSets[indexPath.row]
        cell.textLabel?.text = questionSet.name

        return cell
    }

    @IBAction func unwindToQuestionSet(segue: UIStoryboardSegue) {
        guard let source = segue.source as? QuestionListTableViewController, let set = source.set else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            questionSets.remove(at: indexPath.row)
            questionSets.insert(set, at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            questionSets.append(set)
        }
        //need for decoding
        let archiveUrl = documentsDirectory.appendingPathComponent("set_test").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        if let encodedSet = try? propertyListEncoder.encode(questionSets) {
            //print(encodedSet)
            let encodedQuestionSet = try? propertyListEncoder.encode(questionSets);
            try? encodedQuestionSet?.write(to: archiveUrl, options: .noFileProtection);
        }
        //end
    }
    
    /* Sends the selected Question Set to QuestionListTableViewController IFF an existing set is selected */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let QuestionListTableViewController = segue.destination as? QuestionListTableViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == PropertyKeys.editQuestionSetSegue {
            
            QuestionListTableViewController.set = questionSets[indexPath.row]
        }
    }

}
