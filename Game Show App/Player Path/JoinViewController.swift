//
//  JoinViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 1/7/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//



/*
 TODO:
 Need Multipeer
 If room codes are necessary to join a game they will be entered here. If not anything else needed to join the game will be done.
 Send name to host in ManageGameTableViewController
 */
import UIKit
//import multipeer
import MultipeerConnectivity

class JoinViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //multipeer variables
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateEnterButtonState()
    }
    
    /* Activates the enter button if there is text in nameTextField, deactivates if empty */
    func updateEnterButtonState() {
        if nameTextField.text != "" {
            enterButton.isEnabled = true
        } else {
            enterButton.isEnabled = false
        }
    }
    
    /* Updates the enter button every time the text is edited */
    @IBAction func nameTextEditingChanged(_ sender: UITextField) {
        updateEnterButtonState()
    }
    
    @IBAction func enterButton(_ sender: Any) {
        setUpConnectivity()
        let mcBrowser = MCBrowserViewController(serviceType: "connect", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
    }
    
    func setUpConnectivity() {
        peerID = MCPeerID(displayName: nameTextField.text!)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    /* Methods to conform to multipeer protocols */
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
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        performSegue(withIdentifier: "JoinGame", sender: self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
