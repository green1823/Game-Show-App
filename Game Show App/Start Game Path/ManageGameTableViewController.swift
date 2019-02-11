//
//  ManageGameTableViewController.swift
//  test game show interfaces
//
//  Created by Green, Jackie on 12/4/18.
//  Copyright © 2018 Green, Jackie. All rights reserved.
//


/*
 TODO:
 We need Multipeer to work for this viewcontroller's functionality.
 Recieve the user names from all the users and store them in an array of User objects.
 We need to create this User object with two elements: a String for their name and an Int for the number of points they have.
 The view controller will recieve all the strings and then create an array of these user name strings, with all their points initialized to zero.
 The table cells will fill with all these array elements.
 The plus and minus buttons will add and subtract the amount of points the current question is worth from that User object's points.
 The view controller will also use multipeer to send the array of Users to the leaderboard when students select it, as well as to send the current question to the players' screens.
 
 Needs to send the current question to users through Multipeer.
 Hitting next will increment the array of questions to the next.
 
 https://www.hackingwithswift.com/example-code/system/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework
 A decent tutorial on how to code the hosting, joining, and sending of information.
 */
import UIKit

import MultipeerConnectivity

class ManageGameTableViewController: UITableViewController {
    
    var names: [String] = []
    var currentQuestion: Question?
    
    var peerIDs:[MCPeerID] = []
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    let cafe: Data = "Café".data(using: .utf8)! // non-nil

    override func viewDidLoad() {
        super.viewDidLoad()
        //hides back button
        self.navigationItem.setHidesBackButton(true, animated:true)
        //send the question to players
        //mcSession.send(cafe, toPeers: peerIDs, with: .reliable)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func Next(_ sender: Any) {
        
        performSegue(withIdentifier: "UnwindToSelectQuestionTableViewController", sender: self)
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
    
    /* Methods to conform to multipeer protocols */
}
