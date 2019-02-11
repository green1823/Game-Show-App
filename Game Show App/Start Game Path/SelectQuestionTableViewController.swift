//
//  SelectQuestionTableViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 2/4/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//
//created send data function needs to be called when the question is selected
//converts Question to string this needs to be converted back to a question when it gets to the other side
import UIKit
import MultipeerConnectivity

class SelectQuestionTableViewController: UITableViewController, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var questions: [Question] = []
    var peerIDs:[MCPeerID] = []
    var set: QuestionSet?
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var setUpSession = false
    let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peerIDs.append(peerID);
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

    func sendQuestion(currQuestion: Question){
        let type = currQuestion.type
        var options: [String] = [];
        var tfAns = true
        var typeString = ""
        if(type == .multipleChoice){
            options = currQuestion.mcAnswers!
            typeString = "MC:"
            var i = 0
            while(i < options.count){
                typeString = typeString + options[i] + ","
                i = i + 1;
            }
        }
        if(type == .trueOrFalse){
            tfAns = currQuestion.tfAnswer!
            let tfAnsString = String(tfAns)
            typeString = "TF:"+tfAnsString;
        }
        if type == .buzzer {
            typeString = "BZ"
        }
        let stringData = typeString.data(using: .utf8)
        do{
            try mcSession.send(stringData!, toPeers: peerIDs, with: .reliable)
        } catch let error{
            print(error)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(setUpSession){
            print("here")
            setUpConnectivity()
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "connect", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
        }
        setUpSession = false
        
        //Fills cells with questions
        guard let set = set else {return}
        questions = set.questions
    }
    
    //may not need this - TBD
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tableView.reloadData()
//    }

    func setUpConnectivity() {
        peerID = MCPeerID(displayName: "HOST" + UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = "Question \(String(indexPath.row + 1))"
        cell.detailTextLabel?.text = question.question

        return cell
    }
    
    @IBAction func EndGame(_ sender: Any) {
        performSegue(withIdentifier: "UnwindToSelectSet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ManageGameTableViewController = segue.destination as? ManageGameTableViewController else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //Send variables to 
            ManageGameTableViewController.currentQuestion = questions[indexPath.row]
            ManageGameTableViewController.peerIDs = peerIDs
            ManageGameTableViewController.peerID = peerID
            ManageGameTableViewController.mcSession = mcSession
            ManageGameTableViewController.mcAdvertiserAssistant = mcAdvertiserAssistant
        }
    }
    
    @IBAction func unwindToSelectQuestionTableViewController(segue: UIStoryboardSegue) {
        guard segue.source is ManageGameTableViewController else {return}
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

}
