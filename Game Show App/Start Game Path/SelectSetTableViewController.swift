//
//  SelectSetTableViewController.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/14/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import UIKit

class SelectSetTableViewController: UITableViewController {

    var questionSets: [QuestionSet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadData() {
        questionSets = DataManager.loadAll(QuestionSet.self).sorted(by: {$0.createdAt < $1.createdAt})
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionSets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)

        // Configure the cell...
        let questionSet = questionSets[indexPath.row]
        cell.textLabel?.text = questionSet.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    // MARK: - Navigation

    
    /* Sends the selected question set to ManageGameTableViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let ManageGameTableViewController = segue.destination as? ManageGameTableViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            ManageGameTableViewController.set = questionSets[indexPath.row].questions
        }
    }
    
    @IBAction func unwindToSelectSetTableViewController(segue: UIStoryboardSegue) {
        guard segue.source is ManageGameTableViewController else {return}
    }

}
