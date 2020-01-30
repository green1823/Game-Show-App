//
//  ManageGameTableViewController.swift
//  Buzzer Game Show
//
//  Created by Green, Jackie on 11/14/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ManageGameTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, PlayerCellDelegate {

    var set: [SendData]?
    var questionIndex = 0
    var questionsRemaining = true
    
    var correctPlayers: [String] = []
    var playerScoresDictionary: [String:Int] = [:]
    var playerScoresArray: [(String, Int)] = []
        
    var currentQuestion : SendData?
    var peerIDs : [MCPeerID] = []
    
    var hostPeerID : MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant : MCAdvertiserAssistant!
    
    @IBOutlet weak var StartNextButton: UIBarButtonItem!
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        //Hides back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Connectivity actions
        setUpConnectivity()
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "connect", discoveryInfo: nil, session: self.mcSession)
        self.mcAdvertiserAssistant.start()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Function to send the current question to players
    func sendQuestion (_ questionItem: SendData) {
        if mcSession.connectedPeers.count > 0 {
            if let questionData = DataManager.loadData(questionItem.itemIdentifier.uuidString) {
                do {
                    try mcSession.send(questionData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    fatalError("Could not send question item")
                }
            }
        } else {
            print("you are not connected to another device")
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        // Cycle through questions and reset table and send question
        StartNextButton.title = "Next"
        if set!.count > questionIndex {
            correctPlayers = []     //clear the array
            //tableView.reloadData()
            currentQuestion = set![questionIndex]
            currentQuestion?.saveItem()
            sendQuestion(currentQuestion!)
            currentQuestion?.deleteItem()
            questionIndex += 1
        } else {
            // Fill array with all players
            playerScoresArray = playerScoresDictionary.map { $0 }.sorted { $0.value > $1.value }
            questionsRemaining = false
            NavigationItem.title = "Leaderboard"
            StartNextButton.title = ""
            StartNextButton.isEnabled = false
            correctPlayers = Array(playerScoresDictionary.keys)
        }
        tableView.reloadData()
    }
    
    @IBAction func endGame(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to end the game?", preferredStyle: .alert)
        
        let endGameAction = UIAlertAction(title: "End Game", style: .default) { (action) in
            // End Session and unwind
            self.mcAdvertiserAssistant.stop()
            self.mcSession.disconnect()
            self.performSegue(withIdentifier: "UnwindToSelectSet", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alertController.addAction(endGameAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctPlayers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayerCell
        
        // Configure the cell...
        if questionsRemaining {
            let playerName = correctPlayers[indexPath.row]
            cell.playerNameLabel.text = playerName
            cell.pointsLabel.text = "\(playerScoresDictionary[playerName] ?? 0)"
            //cell.delegate = self
            cell.delegate = self
        } else {
            let playerItem = playerScoresArray[indexPath.row]
            cell.playerNameLabel.text = playerItem.0
            cell.pointsLabel.text = "\(playerItem.1)"
            cell.delegate = self
        }
        
        return cell
    }
    
    // MARK: - Player Cell Delegate Functions

    func didRequestSubtractPoints(playerName: String) {
        playerScoresDictionary[playerName]! -= 1
        tableView.reloadData()
    }
    
    func didRequestAddPoints(playerName: String) {
        playerScoresDictionary[playerName]! += 1
        tableView.reloadData()
    }
    
    // MARK: - Multipeer Functions
        
        /* Begin session */
        func setUpConnectivity() {
            hostPeerID = MCPeerID(displayName: "Host")
            mcSession = MCSession(peer: hostPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
            mcSession.delegate = self
        }
        
        func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
            certificateHandler(true)
        }
        
//        func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//            peerIDs.append(peerID);
//            if (playerScoresDictionary[peerID.displayName] == nil) {
//                playerScoresDictionary[peerID.displayName] = 0
//            }
//        }
//
//        func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//            peerIDs = peerIDs.filter {$0 != peerID}
//        }
//
//        func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//
//        }
        
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
            dismiss(animated: true, completion: nil)
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            dismiss(animated: true, completion: nil)
        }
        
        
        
        func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
            switch state {
            case MCSessionState.connected:
                print("Connected: \(peerID.displayName)")
                
            case MCSessionState.connecting:
                print("Connecting: \(peerID.displayName)")
                
            case MCSessionState.notConnected:
                print("Not Connected: \(peerID.displayName)")
            @unknown default:
                print("Unknown Case")
            }
        }
        
        func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
            
            //TODO: see if this if statement works
            if questionsRemaining == true {
                print("recieved data")
                        //Attempt to recieve name object as data
                        do {
                            let recievedName = try JSONDecoder().decode(SendData.self, from: data)
                            correctPlayers.append(recievedName.content)
                            if let _ = playerScoresDictionary[recievedName.content] {
                            }
                            else {
                                playerScoresDictionary[recievedName.content] = 0
                            }
                            
                            DispatchQueue.main.async {
                                //let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                                //self.tableView.insertRows(at: [indexPath], with: .automatic)
                                self.tableView.reloadData()
                                print("main")
                            }
                            
                            
                //            DispatchQueue.main.async {
                //                self.correctPlayers.append(recievedName)
                //                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                //                self.tableView.insertRows(at: [indexPath], with: .automatic)
                //            }
                        } catch {
                            fatalError("Unable to process the recieved data")
                        }
            }
        }
        
        func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
            //keep empty
        }
        
        func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
            //keep empty
        }
        
        func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
            //keep empty
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
