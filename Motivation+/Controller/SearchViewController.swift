//
//  SearchViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var userArray = [User]()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Search")
        
        searchBar.delegate = self
        
        uid = user!.uid

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userArray = []
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search", for: indexPath) as! SearchTableViewCell
        
        cell.nameLabel.text = userArray[indexPath.row].name
        cell.uid = userArray[indexPath.row].uid
        cell.selectionStyle = .none
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        if searchBar.text != nil {
            search(text: searchBar.text!)
        }
    }
    
    func search(text: String) {
        print("start")
        userArray = []
        db.collection("users").getDocuments { (snapshot, error) in
            if error != nil {
                print(error!)
            }else{
                guard (snapshot != nil) else {
                    return
                }
                print("wow")
                for document in snapshot!.documents {
                    print("hi")
                    let userData = document.data()
                    let uid = userData["uid"] as! String
                    let userId = "@" + uid.prefix(5)
                    let userName = userData["name"] as! String
                    let smallUserId = userId.lowercased()
                    
                    if userId.contains(text) || smallUserId.contains(text) {
                        print("lol")
                        print(smallUserId)
                        let user = User()
                        user.uid = uid
                        user.name = userName
                        user.userId = userId
                        self.userArray.append(user)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        tableView.reloadData()
        print("end")
    }
    

}
