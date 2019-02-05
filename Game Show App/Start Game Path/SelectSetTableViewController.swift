//
//  SelectSetTableViewController.swift
//  test game show interfaces
//
//  Created by Bellini, Dan on 11/29/18.
//  Copyright © 2018 Green, Jackie and ya boi. All rights reserved.
//




/*
 TODO:
 Crashes when a set is selected. Need to fix.
 Need to send the selected QuestionSet object to ManageGameTableViewController.
 */
import UIKit

class SelectSetTableViewController: UITableViewController {
    
    var questionSets: [QuestionSet] = []
    
    var questionSetArchiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("questionSets")
    }
    
    let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let archiveUrl = documentsDirectory.appendingPathComponent("set_test").appendingPathExtension("plist")
        let propertyListDecoder2 = PropertyListDecoder();
        if let retrievedQuestionSetData = try? Data(contentsOf: archiveUrl), let decodedQuestionSet = try? propertyListDecoder2.decode([QuestionSet].self,from: retrievedQuestionSetData){
            questionSets = decodedQuestionSet
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionSets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
        
        let questionSet = questionSets[indexPath.row]
        cell.textLabel?.text = questionSet.name
        
        return cell
    }

    /* Sends the selected question set to SelectQuestionViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let SelectQuestionTableViewController = segue.destination as? SelectQuestionTableViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            SelectQuestionTableViewController.set = questionSets[indexPath.row]
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
