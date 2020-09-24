//
//  RequestTableViewCell.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/12.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class RequestTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var canselButton: UIButton!
    var uid = String()
    var myUid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellContainer.layer.cornerRadius = 5
        iconImageView.layer.cornerRadius = 5
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        followButton.layer.cornerRadius = 5
        canselButton.layer.cornerRadius = 5
        
        myUid = user!.uid
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func canselAction(_ sender: Any) {
        print("cansel!!!!!")
        db.collection("users").document(myUid).getDocument { (snapshot, error) in
            <#code#>
        }
    }
    
    @IBAction func followAction(_ sender: Any) {
        print("follow!!!!!")
    }
    
    
}
