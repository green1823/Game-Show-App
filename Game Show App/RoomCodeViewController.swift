//
//  RoomCodeViewController.swift
//  test game show interfaces
//
//  Created by Bellini, Dan on 11/29/18.
//  Copyright © 2018 Green, Jackie. All rights reserved.
//




/*
 TODO:
 On hold for now. This view controller's interface and purpose may need to be rethought.
 Depending on the how starting a game and allowing others to join with Multipeer we may need to do something other than a room code.
 https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework
 
 https://www.youtube.com/watch?v=H5c4vo6p5Fg
 */
import UIKit
//import multipeer
import MultipeerConnectivity

class RoomCodeViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //multipeer variables
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConnectivity()
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
