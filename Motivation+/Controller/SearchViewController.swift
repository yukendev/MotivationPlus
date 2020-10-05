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
import FirebaseStorage

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, myTableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var myUid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var userArray = [User]()
    let storage = Storage.storage()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Search")
        tableView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        myUid = user!.uid

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
        
        cell.delegate = self
        cell.nameLabel.text = userArray[indexPath.row].name
        cell.uid = userArray[indexPath.row].uid
        db.collection("users").document(userArray[indexPath.row].uid).getDocument { (snapshot, error) in
            if snapshot != nil {
                let followerArray: [String] = snapshot!["followers"] as! [String]
                let requestArray: [String] = snapshot!["requests"] as! [String]
                if followerArray.contains(self.myUid) {
//                    「フォロー中」
                    cell.followButton.setTitle("フォロー中", for: .normal)
                    cell.followButton.isEnabled = false
                }else if requestArray.contains(self.myUid){
//                    「承認待ち」
                    cell.followButton.setTitle("承認待ち", for: .normal)
                    cell.followButton.isEnabled = false
                }else{
//                    「フォロー」
                    cell.followButton.setTitle("フォロー", for: .normal)
                    cell.followButton.isEnabled = true
                }
            }
        }
        cell.selectionStyle = .none
        
        downloadPicture(uid: userArray[indexPath.row].uid, imageView: cell.iconImageView)
        
        return cell
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search")
//        if searchBar.text != nil {
//            search(text: searchBar.text!)
//        }
//        searchBar.endEditing(true)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil {
            search(text: searchBar.text!)
        }
    }
    
    func search(text: String) {
        print("start")
        var text = text
        userArray = []
        if searchBar.text == "" || searchBar.text == "@" {
            return
        }
        db.collection("users").getDocuments { [self] (snapshot, error) in
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
                    if userData["name"] as? String != nil {
                        let uid = userData["uid"] as! String
                        let userId = "@" + uid.prefix(5)
                        let userName = userData["name"] as! String
                        let smallUserId = userId.lowercased()
                        
                        if text.prefix(1) != "@" {
                            text = "@" + text
                        }
                        if smallUserId.contains(text.lowercased()) && uid != self.myUid {
                            if userArray.count >= 10 {
                                return
                            }
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
        }
        tableView.reloadData()
        print("end")
    }
    
    func tableViewReload() {
        print("reload!!!!")
        if searchBar.text != nil {
            search(text: searchBar.text!)
        }
        print("after!!!")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func downloadPicture(uid: String, imageView: UIImageView) {
        print("download start")
        let storageRef = storage.reference(forURL: "gs://motivationplus-e098a.appspot.com/")
        let imageRef = storageRef.child("\(uid).jpg")
        imageRef.downloadURL { (url, error) in
            if url != nil {
                let imageUrl:URL = url!
                print("set start")
                print("\(String(describing: url))")
                imageView.sd_setImage(with: imageUrl)
                print("set finish")
            }else{
                imageView.image = UIImage(named:"IMG_0509" )
            }
        }
        print("download finish")
    }

    
}
