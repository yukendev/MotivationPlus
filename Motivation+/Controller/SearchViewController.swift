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
    
    let nameArray: [String] = ["増山", "春", "けんちゃん", "はるぴー"]
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Search")
        
        searchBar.delegate = self
        
        uid = user!.uid

    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search", for: indexPath) as! SearchTableViewCell
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        
    }
    
    func search(text: String) {
        var userArray = [User]()
        db.collection("users").getDocuments { (snapshot, error) in
            if error != nil {
                print(error!)
            }else{
                guard (snapshot != nil) else {
                    return
                }
                for document in snapshot!.documents {
                    let userData = document.data()
                    let userId = userData["uid"] as! String
                    let userName = userData["name"] as! String
                    let smallUserId = userId.lowercased()
                    
                    if smallUserId.contains(text) {
                        let user = User()
                        user.uid = userId
                        user.name = userName
                        userArray.append(user)
                    }
                }
            }
        }
    }
    

}
