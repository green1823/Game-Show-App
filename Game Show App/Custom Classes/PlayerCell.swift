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
    func didRequestSubtractPoints(playerName : String)
    func didRequestAddPoints(playerName : String)
}

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var delegate : PlayerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func subtractPoints(_ sender: Any) {
        delegate?.didRequestSubtractPoints(playerName: playerNameLabel.text ?? "")
    }
    
    
    @IBAction func addPoints(_ sender: Any) {
        delegate?.didRequestAddPoints(playerName: playerNameLabel.text ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
