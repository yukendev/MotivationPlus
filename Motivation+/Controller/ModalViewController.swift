//
//  ModalViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/19.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
