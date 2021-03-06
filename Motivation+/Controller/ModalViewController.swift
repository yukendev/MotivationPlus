//
//  ModalViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/19.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import Lottie

class ModalViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var animationContainer2: LottieView!
    @IBOutlet weak var animationContainer3: LottieView!
    
    var timeText = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = timeText
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation2()
        showAnimation3()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAnimation2() {
        var animationView2 = AnimationView()
        animationView2 = AnimationView(name: "cracker2")
        animationView2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 14, height: (self.view.frame.width - 14) * 7 / 20)
        animationView2.loopMode = .loop
        animationContainer2.addSubview(animationView2)
        animationView2.play()
    }
    
    
    func showAnimation3() {
        var animationView3 = AnimationView()
        animationView3 = AnimationView(name: "congratulation")
        animationView3.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 70, height: (self.view.frame.width - 70) * 193 / 344)
        animationContainer3.addSubview(animationView3)
        animationView3.play()
    }
    
    
}
