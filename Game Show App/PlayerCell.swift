//
//  PlayerCell.swift
//  Game Show App
//
//  Created by Green, Jackie on 9/30/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation

import UIKit

protocol PlayerCellDelegate {
    func didRequestDelete(_ cell:PlayerCell)
}

class PlayerCell: UITableViewCell {

    var delegate:PlayerCellDelegate?
    
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func subtractPoints(_ sender: Any) {
    }
    
    
    @IBAction func addPoints(_ sender: Any) {
    }
    
    @IBAction func deletePlayer(_ sender: Any) {
        if let delegateObject = self.delegate {
            delegateObject.didRequestDelete(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
