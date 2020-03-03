//
//  GameViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 1/7/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

/*
 TODO:
 Add images for buttons and buzzer
 Program animations for buttons and buzzer pressing (last priority, images will be provided when we get here)
 */

import UIKit
import MultipeerConnectivity
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
    
    //Information Variables
    var name: String!
    var playerName: SendData!
    var recievedQuestion: SendData!
    
    //Outlet Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buzzerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConnectivity()
        let mcBrowser = MCBrowserViewController(serviceType: "connect", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
        buzzerButton.isEnabled = false
        //TRY??If buzzer is messed up uncomment
        //buzzerButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func displayQuestion(recievedQuestion: SendData) {
        DispatchQueue.main.async {
            self.buzzerButton.isEnabled = true
            //self.buzzerButton.setImage(UIImage(named: "Unpressed"), for: .normal)
            self.questionLabel.text = recievedQuestion.content
        }
    }
    
    //MARK: - Buzzer Actions
    
    // Changes the image of the buzzer when being pressed and sends name to host
    @IBAction func buzzerPushed(_ sender: Any) {
        //buzzerButton.setImage(UIImage(named: "Pressing"), for: .normal)
        DispatchQueue.main.async {
            self.buzzerButton.isEnabled = false
        }
        sendName()
    }
    
    // Changes the image of the buzzer back to unpressed when releasing outside
    @IBAction func buzzerReleasedOutside(_ sender: Any) {
        //buzzerButton.setImage(UIImage(named: "Pressed"), for: .normal)
        //buzzerButton.setImage(UIImage(named: "Blue"), for: .normal)
    }
    
    // Changes the image of the buzzer to pressed when releasing inside
    @IBAction func buzzerReleasedInside(_ sender: Any) {
        //buzzerButton.setImage(UIImage(named: "Pressed"), for: .normal)
        //buzzerButton.setImage(UIImage(named: "Blue"), for: .normal)
    }
    
    //MARK: - Additional Multipeer Functions
    
    func sendName() {
        if mcSession.connectedPeers.count > 0 {
            playerName = SendData(content: name, createdAt: Date(), itemIdentifier: UUID())
            playerName?.saveItem()
            if let nameData = DataManager.loadData((playerName?.itemIdentifier.uuidString)!) {
                do {
                    try mcSession.send(nameData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    fatalError("could not send question item")
                }
            }
            playerName?.deleteItem()
        } else {
            print("you are not connected to another device")
        }
    }
    
    func setUpConnectivity() {
        print(name!);
        peerID = MCPeerID(displayName: name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        mcSession.delegate = self
    }
    
    //MARK: - Multipeer delegate functions
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if (peerID.displayName == "Host" && state == MCSessionState.notConnected) {
            print("connection ended")
            let gameEndedAlertController = UIAlertController(title: nil, message: "Game Ended", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.mcSession.disconnect()
                self.performSegue(withIdentifier: "UnwindToJoin", sender: self)
            }
            gameEndedAlertController.addAction(okAction)
            DispatchQueue.main.async {
                self.present(gameEndedAlertController, animated: true, completion: nil)
            }
        }
    }
    
    /* Recieves and handles the question sent by the host */
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("recieved data")
        
        //Attempt to recieve question object as data
        do {
            recievedQuestion = try JSONDecoder().decode(SendData.self, from: data)
            displayQuestion(recievedQuestion: recievedQuestion)
        } catch {
            fatalError("Unable to process the recieved data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "UnwindToJoin", sender: self)
    }
}
