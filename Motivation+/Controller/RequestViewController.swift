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

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, myTableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestLabel: UILabel!
    
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
        cell.delegate = self
        downloadPicture(uid: requestsArray[indexPath.row].uid, imageView: cell.iconImageView)
        return cell
    }
    
    
    func showRequests() {
        requestsArray = []
        idArray = []
        print(uid)
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            print("get data")
            if snapshot != nil {
                print("not nil")
                self.idArray = snapshot!["requests"] as! [String]
                if idArray == [] {
                    requestLabel.isHidden = false
                    requestLabel.text = "リクエストはありません"
                    tableView.reloadData()
                    return
                }else{
                    requestLabel.isHidden = true
                    idArray = arrayFilter(array: idArray)
                }
                self.idArray.forEach { (id) in
                    self.db.collection("users").document(id).getDocument { (document, error) in
                        if document != nil {
                            print("not nil 2")
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
    
    
    func tableViewReload() {
        showRequests()
    }
    
    
    func downloadPicture(uid: String, imageView: UIImageView) {
        let storageRef = storage.reference(forURL: "gs://motivationplus-e098a.appspot.com/")
        let imageRef = storageRef.child("\(uid).jpg")
        imageRef.downloadURL { (url, error) in
            if url != nil {
                let imageUrl:URL = url!
                print("\(String(describing: url))")
                imageView.sd_setImage(with: imageUrl)
            }else{
                imageView.image = UIImage(named:"IMG_0509" )
            }
        }
    }
    
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
        return resultArray
    }
    
}
