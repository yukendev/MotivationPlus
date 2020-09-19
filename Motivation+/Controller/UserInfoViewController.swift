//
//  UserInfoViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        editButton.layer.cornerRadius = 5
        nameLabel.layer.borderWidth = 2
        nameLabel.layer.cornerRadius = 5
        
        uid = user!.uid
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataArray = document.data()
                if dataArray!["name"] == nil {
                    print("name is nil")
                    self.nameLabel.text = "名前を設定して下さい"
                }else{
                    print("name is not nil")
                    self.nameLabel.text = dataArray!["name"] as? String
                }
              } else {
                print("Document does not exist in cache")
              }
        }
    }
    
    
    
    
    @IBAction func editAction(_ sender: Any) {
        print("編集されました")
        performSegue(withIdentifier: "edit", sender: nil)
    }

    
    
}
