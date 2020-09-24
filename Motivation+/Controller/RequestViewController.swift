//
//  RequestViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var requestsArray = [User]()
    var idArray = [String]()
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "Request")
        
        uid = user!.uid

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showRequests()
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Request", for: indexPath) as! RequestTableViewCell
        
        cell.selectionStyle = .none
        
        cell.nameLabel.text = requestsArray[indexPath.row].name
        cell.uid = requestsArray[indexPath.row].uid
        
        return cell
    }
    
    func showRequests() {
        requestsArray = []
        idArray = []
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if snapshot != nil {
                self.idArray = snapshot!["requests"] as! [String]
                self.idArray.forEach { (id) in
                    self.db.collection("users").document(id).getDocument { (document, error) in
                        if document != nil {
                            let user = User()
                            user.uid = document!["uid"] as! String
                            user.name = document!["name"] as! String
                            self.requestsArray.append(user)
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    

}
