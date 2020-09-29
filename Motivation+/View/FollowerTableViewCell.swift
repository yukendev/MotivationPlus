//
//  FollowerTableViewCell.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/12.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var uid = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContainer.layer.cornerRadius = 5
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        stateLabel.layer.cornerRadius = 5
        stateLabel.clipsToBounds = true
        iconImageView.layer.cornerRadius = 5
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
