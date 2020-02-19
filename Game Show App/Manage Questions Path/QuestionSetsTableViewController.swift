//
//  QuestionSetsTableViewController.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/4/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//


//TODO: Deleting isn't permanent right now, sets reappear after segueing away and back. When returning from editing, the set is double saved, fix this by deleting the set after loading into the next view
import UIKit

class QuestionSetsTableViewController: UITableViewController {

    struct PropertyKeys {
        static let questionSetCell = "QuestionSetCell"
        static let addQuestionSetSegue = "AddQuestionSet"
        static let editQuestionSetSegue = "EditQuestionSet"
    }
    
    var questionSets: [QuestionSet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func loadData() {
        questionSets = DataManager.loadAll(QuestionSet.self).sorted(by: {$0.createdAt < $1.createdAt})
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questionSets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.questionSetCell, for: indexPath)
        
        let questionSet = questionSets[indexPath.row]
        cell.textLabel?.text = questionSet.name

        // Configure the cell...

        return cell
    }
    
    //MARK: -Navigation
    
    @IBAction func unwindToQuestionSetSave(segue: UIStoryboardSegue) {
        guard let source = segue.source as? QuestionListTableViewController, let set = source.set else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            questionSets.remove(at: indexPath.row)
            questionSets.insert(set, at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            questionSets.append(set)
        }
    }
    
    @IBAction func unwindToQuestionSetCancel(segue: UIStoryboardSegue) {
    }
    
    /* Sends the selected Question Set to QuestionListTableViewController IFF an existing set is selected */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let QuestionListTableViewController = segue.destination as? QuestionListTableViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier == PropertyKeys.editQuestionSetSegue {
            QuestionListTableViewController.set = questionSets[indexPath.row]
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            questionSets[indexPath.row].deleteItem()
            questionSets.remove(at: indexPath.row)
            
            //Delete the row
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
