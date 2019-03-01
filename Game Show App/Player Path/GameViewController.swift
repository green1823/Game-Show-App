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
    var name: String = "";
    //Outlet Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var MCView: UIView!
    @IBOutlet weak var TFView: UIView!
    @IBOutlet weak var BZView: UIView!

    
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
    
    //MARK: - Multipeer delegate functions
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //NOTE: I think maybe we need to use the didFinishReceivingResourceWithName method since we're sending strings instead of data
//        do {
//            let info = String(decoding: data, as: UTF8.self)
//        } catch {
//            fatalError()
//        }
//
//
//        var info = String(decoding: data, as: UTF8.self)
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
//            //https://github.com/iamjono/SwiftString/blob/master/README.md
//            //thanks jono this is now installed all the methods in the readme should work as intended
//
//            info.remove(at: info.startIndex)
//            info.remove(at: info.startIndex)
//        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
            var jsonString = "error"
            let typeData = jsonString.data(using: .utf8)
            var info = try! JSONDecoder().decode(String.self, from: localURL?.dataRepresentation ?? typeData!)

    
        
        if info.hasPrefix("Q") {
            print(info)
            info.remove(at: info.startIndex)
            questionLabel.text = info
        } else if (info.hasPrefix("TF")) {
            info.remove(at: info.startIndex)
            info.remove(at: info.startIndex)
            MCView.isHidden = true
            TFView.isHidden = false
            BZView.isHidden = true
        } else if (info.hasPrefix("BZ")) {
            MCView.isHidden = true
            TFView.isHidden = true
            BZView.isHidden = false
            
            info.remove(at: info.startIndex)
            info.remove(at: info.startIndex)
        } else if (info.hasPrefix("MC")) {
            MCView.isHidden = false
            TFView.isHidden = true
            BZView.isHidden = true
            var tempString = info
            
            //https://github.com/iamjono/SwiftString/blob/master/README.md
            //thanks jono this is now installed all the methods in the readme should work as intended
            
            info.remove(at: info.startIndex)
            info.remove(at: info.startIndex)
        }

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
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    //trying to fix connectivity error
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func respond(){
        
    }
    
    @IBAction func a1Pressed(_ sender: Any) {
    }
    @IBAction func a2Pressed(_ sender: Any) {
    }
    @IBAction func a3Pressed(_ sender: Any) {
    }
    @IBAction func a4Pressed(_ sender: Any) {
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
