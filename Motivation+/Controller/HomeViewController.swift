//
//  HomeViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        print("pushed!!!!")
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    @IBAction func requestAction(_ sender: Any) {
        performSegue(withIdentifier: "request", sender: nil)
    }
    

}
