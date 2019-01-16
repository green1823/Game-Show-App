//
//  HostViewController.swift
//  Game Show App
//
//  Created by Green, Jackie on 1/16/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

/*
 TODO:
 Implement the methods needed to host a multipeer session
 pass session info to next view controller?
 https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework
 
 https://www.youtube.com/watch?v=H5c4vo6p5Fg
 */
import UIKit
//import multipeer
import MultipeerConnectivity

class HostViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //multipeer variables
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
        setUpConnectivity()
        //...
    }
    
    func setUpConnectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
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
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
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
