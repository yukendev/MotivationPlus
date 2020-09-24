//
//  SearchTableViewCell.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/12.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    var uid = String()
    var myUid = String()
    var user = Auth.auth().currentUser
    let db = Firestore.firestore()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellContainer.layer.cornerRadius = 5
        iconImageView.layer.cornerRadius = 5
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        followButton.layer.cornerRadius = 5
        
        myUid = user!.uid
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func followAction(_ sender: Any) {
        
        addFollower()
        
        addRequests()
        
        print("come on!!!!")
    }
    
    func addFollower() {
        var followerArray: [String] = []
        db.collection("users").document(myUid).getDocument { (snapshot, error) in
            if snapshot != nil {
                followerArray = snapshot!["followers"] as! [String]
                followerArray.append(self.uid)
                self.db.collection("users").document(self.myUid).updateData([
                    "followers": followerArray
                ])
            }
        }
    }
    
    func addRequests() {
        var requestsArray: [String] = []
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if snapshot != nil {
                requestsArray = snapshot!["requests"] as! [String]
                requestsArray.append(self.myUid)
                self.db.collection("users").document(self.uid).updateData([
                    "requests": requestsArray
                ])
            }
        }
    }
    
}
