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
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeText = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.text = timeText
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
