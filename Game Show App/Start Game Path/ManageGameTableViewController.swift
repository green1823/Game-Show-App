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

class ManageGameTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var names: [String] = []
    var set: [Question]?
    var questionIndex = 0
    
    //var currentQuestion: Question?
    /*
        these two arrays should be updated at the same time and hold data in parallel
        I would use a map but I dont think that swift has map built in
    */
    var ansPeers : [MCPeerID] = [];
    //var answers : [Answer] = [];
    var questions : [Question] = [];
    var currentQuestion: Question?
    var peerIDs:[MCPeerID] = []
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    @IBOutlet weak var StartNextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        // Hides back button
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        // Connectivity actions
        setUpConnectivity()
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "connect", discoveryInfo: nil, session: self.mcSession)
        self.mcAdvertiserAssistant.start()
        
        
        //send the question to players
        //mcSession.send(cafe, toPeers: peerIDs, with: .reliable)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Function to send the current question to players
    func sendQuestion (_ questionItem: Question) {
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


    // MARK: - Table view data source

    @IBAction func Next(_ sender: UIButton) {
        //cycle through questions and reset table and send question
        StartNextButton.title = "Next"
        if set!.count > questionIndex {
            names = []
            tableView.reloadData()
            currentQuestion = set![questionIndex]
            currentQuestion?.saveItem()
            sendQuestion(currentQuestion!)
            currentQuestion?.deleteItem()
            questionIndex += 1
        } else {
            let gameOverAlertController = UIAlertController(title: "Game Over", message: "", preferredStyle: .alert)
            gameOverAlertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "UnwindToSelectSet", sender: self)
            }))
            self.present(gameOverAlertController, animated: true, completion: nil)
            //sender.isHidden = true
            for peer in peerIDs {
                names.append(peer.displayName)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func endGame(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to end the game?", preferredStyle: .alert)
        
        let endGameAction = UIAlertAction(title: "End Game", style: .default) { (action) in
            print("end game selected")
            self.performSegue(withIdentifier: "UnwindToSelectSet", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel selected")
        }
        
        alertController.addAction(endGameAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Multipeer Functions
    
    /* Begin session */
    func setUpConnectivity() {
        //peerID = MCPeerID(displayName: UIDevice.current.name)
        peerID = MCPeerID(displayName: "Host")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        mcSession.delegate = self
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peerIDs.append(peerID);
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
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
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("recieved data")
//
//        //Attempt to recieve name object as data
//        do {
//            let recievedName = try JSONDecoder().decode(String.self, from: data)
//            names.append(recievedName)
//        } catch {
//            fatalError("Unable to process the recieved data")
//        }
//        // This is where we can recieve the usernames with the answer they chose
//        // IFF the answer they chose matches the correct answer the username will display as a cell
//        var incomingPeer = peerID
//        ansPeers.append(incomingPeer);
//        let decoder = JSONDecoder();
//        //UNCOMMENT and fix error
//        //var decodedAns : Answer = try decoder.decode(data.self, from: json)
//        //answers.append(decodedAns)
        
        let incomingPeer = peerID
        ansPeers.append(incomingPeer)
        let decoder = JSONDecoder()
//        var decodedAns: Answer?
//        do {
//            decodedAns = try decoder.decode(Answer.self, from: data)
//        } catch {
//            print("error decoding answer")
//        }
//        answers.append(decodedAns!)
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
    
    
    // MARK: - Tableview functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        
        // Configure the cell...
        
        
        return cell
    }
    
    
}
