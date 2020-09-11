//
//  HomeViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    
    let nameArray: [String] = ["増山", "春", "けんちゃん", "はるぴー"]
    let stateArray: [String] = ["勉強中", "休憩中", "7時間", "勉強中" ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "Follower")
        
        requestButton.layer.cornerRadius = 5
        
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        print("pushed!!!!")
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    @IBAction func requestAction(_ sender: Any) {
        performSegue(withIdentifier: "request", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Follower", for: indexPath) as! FollowerTableViewCell
        
        cell.selectionStyle = .none
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.stateLabel.text = stateArray[indexPath.row]
        switch stateArray[indexPath.row] {
        case "勉強中":
            cell.stateLabel.backgroundColor = UIColor.orange
        case "休憩中":
            cell.stateLabel.backgroundColor = UIColor.green
        default:
            cell.stateLabel.backgroundColor = UIColor.yellow
        }
    
        
        return cell
    }
    
    

}
