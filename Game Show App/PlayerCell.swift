//
//  PlayerCell.swift
//  Game Show App
//
//  Created by Green, Jackie on 9/30/19.
//  Copyright © 2019 Green, Jackie. All rights reserved.
//

import Foundation

import UIKit

class PlayerCell: UITableViewCell {
    
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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
