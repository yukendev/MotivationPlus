//
//  HomeViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    
//    let nameArray: [String] = ["増山", "春", "けんちゃん", "はるぴー"]
//    let stateArray: [String] = ["勉強中", "休憩中", "7時間", "勉強中" ]
    var followerArray = [User]()
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "Follower")
        
        requestButton.layer.cornerRadius = 5
        
        uid = user!.uid
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showFollower()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        print("pushed!!!!")
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    @IBAction func requestAction(_ sender: Any) {
        performSegue(withIdentifier: "request", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Follower", for: indexPath) as! FollowerTableViewCell
        
        cell.selectionStyle = .none
        cell.nameLabel.text = followerArray[indexPath.row].name
        switch followerArray[indexPath.row].state {
        case "studying":
            cell.stateLabel.isHidden = false
            cell.stateLabel.backgroundColor = UIColor.orange
            cell.stateLabel.text = "勉強中"
        case "not studying":
//            cell.stateLabel.backgroundColor = UIColor.green
            cell.stateLabel.isHidden = true
            
        default:
            cell.stateLabel.backgroundColor = UIColor.yellow
            cell.stateLabel.text = "うんこ"
        }
    
        
        return cell
    }
    
    func showFollower() {
        var uidArray: [String] = []
        followerArray = []
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if snapshot != nil {
                uidArray = snapshot!["followers"] as! [String]
                uidArray.forEach { (id) in
                    let user = User()
                    self.db.collection("users").document(id).getDocument { (document, error) in
                        if document != nil {
                            user.name = document!["name"] as! String
                            user.state = document!["state"] as! String
                            self.followerArray.append(user)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    

}
