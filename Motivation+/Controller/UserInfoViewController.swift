//
//  UserInfoViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
//import FirebaseUI
import SDWebImage

class UserInfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        editButton.layer.cornerRadius = 5
        nameLabel.layer.borderWidth = 2
        nameLabel.layer.cornerRadius = 5
        
        uid = user!.uid
        
        editButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        editButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataArray = document.data()
                let id = dataArray!["uid"] as? String
                let cutId = "@" + id!.prefix(5)
                if dataArray!["name"] == nil {
                    print("name is nil")
                    self.nameLabel.text = "名前を設定して下さい"
                    self.idLabel.text = "\(String(describing: cutId))"
                }else{
                    print("name is not nil")
                    self.nameLabel.text = dataArray!["name"] as? String
                    self.idLabel.text = "\(String(describing: cutId))"
                }
              } else {
                print("Document does not exist in cache")
              }
        }
        
        downloadPicture()
        
        print("viewWillAppear finish")
        
    }
    
    
    
    
    @IBAction func editAction(_ sender: Any) {
        print("編集されました")
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    
    func downloadPicture() {
        print("download start")
        let storageRef = storage.reference(forURL: "gs://motivationplus-e098a.appspot.com/")
        let imageRef = storageRef.child("\(uid).jpg")
        imageRef.downloadURL { (url, error) in
            if url != nil {
                let imageUrl:URL = url!
                print("set start")
                print("\(String(describing: url))")
                self.imageView.sd_setImage(with: imageUrl)
                print("set finish")
            }else{
                self.imageView.image = UIImage(named:"IMG_0509" )
            }
        }
        print("download finish")
    }
    

    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
        
        
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, animations:{ () -> Void in
             sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
             sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
}
