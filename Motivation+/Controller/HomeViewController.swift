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
import RKNotificationHub

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    

    var followerArray = [User]()
    var requestArray = [String]()
    var uidArray = [String]()
    
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    let storage = Storage.storage()
    let hub = RKNotificationHub()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "Follower")
        
        requestButton.layer.cornerRadius = 5
        
        uid = user!.uid
        
        requestButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        requestButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showFollower()
        setBudge()
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        print("pushed!!!!")
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                if snapshot!["name"] == nil {
                    showAlert(title: "名前を設定して下さい")
                }else{
                    performSegue(withIdentifier: "search", sender: nil)
                }
            }
        }
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
        cell.uid = followerArray[indexPath.row].uid
        cell.nameLabel.text = followerArray[indexPath.row].name
        switch followerArray[indexPath.row].state {
        case "studying":
            print("勉強中")
//            cell.stateLabel.backgroundColor = UIColor.orange
//            cell.stateLabel.text = "勉強中"
            cell.showAnimation(state: "studying", speed: 2.5, login: followerArray[indexPath.row].lastLogin)
        case "not studying":
            print("勉強してないよ")
//            cell.stateLabel.backgroundColor = UIColor.green
//            cell.stateLabel.text = "休憩中"
            cell.showAnimation(state: "not studying", speed: 1.0, login: followerArray[indexPath.row].lastLogin)
        case "finish":
            print("勉強終わったよ")
//            cell.stateLabel.backgroundColor = UIColor.white
            cell.stateLabel.text = followerArray[indexPath.row].studyTime.prefix(2) + "時間"
            cell.showAnimation(state: "finish", speed: 1.0, login: followerArray[indexPath.row].lastLogin)
        case "timeout":
            print("タイムアウトです")
//            cell.stateLabel.backgroundColor = UIColor.white
//            cell.loginLabel.text = "うんこ"
//            cell.loginLabel.isHidden = false
            cell.stateLabel.text = followerArray[indexPath.row].studyTime.prefix(2) + "時間"
            cell.showAnimation(state: "finish", speed: 1.0, login: followerArray[indexPath.row].lastLogin)
        default:
            print("例外")
//            cell.loginLabel.isHidden = false
//            cell.loginLabel.text = String(followerArray[indexPath.row].lastLogin) + ""
//            cell.showAnimation(state: "timeout", speed: 0, login: followerArray[indexPath.row].lastLogin)
//            cell.stateLabel.isHidden = false
//            cell.stateLabel.backgroundColor = UIColor.white
//            cell.stateLabel.text = followerArray[indexPath.row].studyTime.prefix(2) + "時間"

        }
        
        downloadPicture(uid: followerArray[indexPath.row].uid, imageView: cell.iconImageView)
    
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title:"フォロー解除") { [self]
            (ctxAction, view, completionHandler) in
            print(indexPath.row)
            showAlert2(title: "フォローを解除しますか", path: indexPath.row)
//            self.deleteFollower(path: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.red
        

        
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
    func showFollower() {
        uidArray = []
        followerArray = []
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                uidArray = snapshot!["followers"] as! [String]
                uidArray = arrayFilter(array: uidArray)
                uidArray.forEach { (id) in
                    let user = User()
                    self.db.collection("users").document(id).getDocument { [self] (document, error) in
                        if document != nil {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                            var lastLogin = 0
                            if snapshot!["lastTime"] != nil {
                                let lastTime = dateFormatter.date(from: snapshot!["lastTime"] as! String)
                                lastLogin = Int(lastTime!.daysFrom())
                                print("こいつ全然ログインしてねぇぞ！　\(lastLogin)日前だ！！")
                            }
                            
                            user.name = document!["name"] as! String
                            user.state = document!["state"] as! String
                            user.uid = document!["uid"] as! String
                            user.studyTime = document!["studyTime"] as! String
                            user.lastLogin = lastLogin
                            self.followerArray.append(user)
                            tableView.reloadData()
                            print("reload!!!!!!!")
                        }
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert2(title: String, path: Int) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "はい", style: .default) { (alert) in
            self.okAction(path: path)
        }
        let cansel = UIAlertAction(title: "いいえ", style: .cancel)
        alertController.addAction(cansel)
        alertController.addAction(action1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func okAction(path: Int) {
        deleteFollower(path: path)
    }
    
    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        })
    }
        
        
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, animations:{ () -> Void in
             sender.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
             sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
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
    
    func setBudge() {
        requestArray = []
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if error != nil {
                print(error!)
            }
            if snapshot != nil {
                requestArray = snapshot!["requests"] as! [String]
                if requestArray.count == 0 {
                    hub.hideCount()
                    hub.setCircleColor(UIColor.clear, label: UIColor.clear)
                }else{
                    hub.setView(requestButton, andCount: Int32(requestArray.count))
                    hub.setCircleColor(UIColor.red, label: UIColor.white)
                    hub.bump()
                }
            }
        }
    }
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
        
        return resultArray
    }
    
    func deleteFollower(path: Int) {
        
        var oldArray: [String] = []
        var newArray: [String] = []
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                oldArray = snapshot!["followers"] as! [String]
                let deletedUid = uidArray[path]
                oldArray.forEach { (uid) in
                    if uid != deletedUid {
                        newArray.append(uid)
                    }
                }
            }
        }
        db.collection("users").document(uid).updateData([
            "followers": newArray
        ])
        
        oldArray = []
        newArray = []
        db.collection("users").document(uidArray[path]).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                oldArray = snapshot!["followers"] as! [String]
                let deletedUid = uid
                oldArray.forEach { (uid) in
                    if uid != deletedUid {
                        newArray.append(uid)
                    }
                }
            }
        }
        db.collection("users").document(uidArray[path]).updateData([
            "followers": newArray
        ]){_ in
            self.showFollower()
        }
    }
    
    
    
}
