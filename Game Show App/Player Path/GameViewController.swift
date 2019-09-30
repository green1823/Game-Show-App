//
//  GameViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 1/7/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//
/*
 Multipeer needed
 Recieve Question object from array of questions in ManageGameTableViewController
 Enable correct answer view based on question type
 Change questionLabel text to question
 If MC question - change button labels to answers
 Add images for buttons and buzzer
 Program animations for buttons and buzzer pressing (last priority, images will be provided when we get here)
 */
/*
My thought is that we are going to ahve to set up the MCSession and connect in this view controller right after we segue. That way we wont have to worry about sending MCSessions through a segue and if the connection fails we can just segue back
*/
import UIKit
import MultipeerConnectivity
//let s = "hello"
//s[0..<3] // "hel"
//s[3..<s.count] // "lo"
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
class GameViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //Multipeer Variables
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var name: String!
    var playerName: PlayerName?
    var recievedQuestion: Question!
    //Outlet Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var MCView: UIView!
    @IBOutlet weak var TFView: UIView!
    @IBOutlet weak var BZView: UIView!
    @IBOutlet weak var a1Button: UIButton!
    @IBOutlet weak var a2Button: UIButton!
    @IBOutlet weak var a3Button: UIButton!
    @IBOutlet weak var a4Button: UIButton!
    @IBOutlet weak var buzzerButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConnectivity()
        let mcBrowser = MCBrowserViewController(serviceType: "connect", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
        MCView.isHidden = true
        TFView.isHidden = true
        BZView.isHidden = true
        //        if(mcSession.connectedPeers.count == 0){
        //            performSegue(withIdentifier: "EnterName", sender: self)
        //        }
        // Do any additional setup after loading the view.
    }
    
    func displayQuestion(recievedQuestion: Question) {
        switch recievedQuestion.type {
        case .trueOrFalse:
            MCView.isHidden = true
            TFView.isHidden = false
            BZView.isHidden = true
            enableTrueFalse()
            break;
        case .buzzer:
            MCView.isHidden = true
            TFView.isHidden = true
            BZView.isHidden = false
            enableBuzzer()
            break;
        case .multipleChoice:
            MCView.isHidden = false
            TFView.isHidden = true
            BZView.isHidden = true
            enableButtons()
            a1Button.setTitle(recievedQuestion.mcAnswers?[0], for: .normal)
            a2Button.setTitle(recievedQuestion.mcAnswers?[1], for: .normal)
            a3Button.setTitle(recievedQuestion.mcAnswers?[2], for: .normal)
            a4Button.setTitle(recievedQuestion.mcAnswers?[3], for: .normal)

            break;
        }
        questionLabel.text = recievedQuestion.question
    }
    
    //MARK: - Multipeer delegate functions
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

    }
    
    /* Recieves and handles the question sent by the host */
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("recieved data")
        
        //Attempt to recieve question object as data
        do {
            recievedQuestion = try JSONDecoder().decode(Question.self, from: data)
            displayQuestion(recievedQuestion: recievedQuestion)
        } catch {
            fatalError("Unable to process the recieved data")
        }
    }
    
    /* Sends the user's name to the host */
    func sendName() {
        if mcSession.connectedPeers.count > 0 {
            //The name is not saved to datamanager - one way os to send it and then append the string on the host end. Otherwise I could send anything just to ping the host and take the peerid property as the name --- peerId.displayName = String
            playerName = PlayerName(name: name, itemIdentifier: UUID())
            playerName?.saveItem()
            if let nameData = DataManager.loadData((playerName?.itemIdentifier.uuidString)!) {
                do {
                    try mcSession.send(nameData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    fatalError("Could not send question item")
                }
            }
            playerName?.deleteItem()
            
        } else {
            print("you are not connected to another device")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // keep empty
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // keep empty
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        print("recieved resource")
//        //decoding error "message"
//        let jsonString = "error"
//        let typeData = jsonString.data(using: .utf8)
//        //tries decoding from data url if doesn't work decodes error
//        var info = try! JSONDecoder().decode(String.self, from: localURL?.dataRepresentation ?? typeData!)
//        //info should now have data represented as a string
//        print(info)
//        if info.hasPrefix("Q") {
//            print(info)
//            info.remove(at: info.startIndex)
//            questionLabel.text = info
//        } else if (info.hasPrefix("TF")) {
//            info.remove(at: info.startIndex)
//            info.remove(at: info.startIndex)
//            MCView.isHidden = true
//            TFView.isHidden = false
//            BZView.isHidden = true
//        } else if (info.hasPrefix("BZ")) {
//            MCView.isHidden = true
//            TFView.isHidden = true
//            BZView.isHidden = false
//
//            info.remove(at: info.startIndex)
//            info.remove(at: info.startIndex)
//        } else if (info.hasPrefix("MC")) {
//            MCView.isHidden = false
//            TFView.isHidden = true
//            BZView.isHidden = true
//            var tempString = info
//
//
//            info.remove(at: info.startIndex)
//            info.remove(at: info.startIndex)
//        }

    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "UnwindToJoin", sender: self)
    }
    
    //MARK: - Additional Multipeer functions
    
    func setUpConnectivity() {
        print(name);
        peerID = MCPeerID(displayName: name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        mcSession.delegate = self
    }
    
//    //trying to fix connectivity error
//    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
//        certificateHandler(true)
//    }
//    func respond(){
//
//    }
    
    //MARK: - Actions for when all buttons are pressed
    
    @IBAction func a1Pressed(_ sender: Any) {
        disableButtons()
        if recievedQuestion.correctMCIndex == 0 {
            sendName()
        }
    }
    
    @IBAction func a2Pressed(_ sender: Any) {
        disableButtons()
        if recievedQuestion.correctMCIndex == 1 {
            sendName()
        }
    }
    
    @IBAction func a3Pressed(_ sender: Any) {
        disableButtons()
        if recievedQuestion.correctMCIndex == 2 {
            sendName()
        }
    }
    
    @IBAction func a4Pressed(_ sender: Any) {
        disableButtons()
        if recievedQuestion.correctMCIndex == 3 {
            sendName()
        }
    }
    
    @IBAction func buzzerPressed(_ sender: Any) {
        disableBuzzer()
        sendName()
    }
    
    @IBAction func truePressed(_ sender: Any) {
        disableTrueFalse()
        if recievedQuestion.tfAnswer == true {
            sendName()
        }
    }
    
    @IBAction func falsePressed(_ sender: Any) {
        disableTrueFalse()
        if recievedQuestion.tfAnswer == false {
            sendName()
        }
    }
    
    
    // MARK: - functions to activate and deactivate buttons
    
    /* Disables multiple choice buttons */
    func disableButtons () {
        a1Button.isEnabled = false
        a2Button.isEnabled = false
        a3Button.isEnabled = false
        a4Button.isEnabled = false
    }

    /* Enables multiple choice buttons */
    func enableButtons () {
        a1Button.isEnabled = true
        a2Button.isEnabled = true
        a3Button.isEnabled = true
        a4Button.isEnabled = true
    }
    
    /* Disables buzzer button */
    func disableBuzzer() {
        buzzerButton.isEnabled = false
    }
    
    /* Enables buzzer button */
    func enableBuzzer() {
        buzzerButton.isEnabled = true
    }

    /* Disables true/false buttons */
    func disableTrueFalse() {
        trueButton.isEnabled = false
        falseButton.isEnabled = false
    }
    
    /* Enables true/false buttons */
    func enableTrueFalse() {
        trueButton.isEnabled = true
        falseButton.isEnabled = true
    }
    
}
