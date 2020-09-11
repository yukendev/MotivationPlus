//
//  FollowerViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController {
    
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var timerContainer: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    var timer = Timer()
    var second: Int = 0
    var minute: Int = 0
    var hour: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerContainer.layer.borderWidth = 2.0
        timerContainer.layer.borderColor = UIColor.black.cgColor
        timerContainer.clipsToBounds = true
        timerContainer.layer.cornerRadius = 10
        
        startButton.layer.cornerRadius = 5
        stopButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        
        stopButton.isHidden = true
        resetButton.isHidden = true

    }
    
    
    @IBAction func startAction(_ sender: Any) {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        }
        
        startButton.isHidden = true
        stopButton.isHidden = false
        resetButton.isHidden = true
    }
    
    @IBAction func stopAction(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
        }
        
        startButton.isHidden = false
        stopButton.isHidden = true
        resetButton.isHidden = false
        
    }
    
    @IBAction func resetAction(_ sender: Any) {
        second = 0
        minute = 0
        hour = 0
        timer.invalidate()
        
        let sSecond = String(format:"%02d", second)
        let sMinute = String(format:"%02d", minute)
        let sHour = String(format:"%02d", hour)
        
        hourLabel.text = "\(sHour)"
        minuteLabel.text = "\(sMinute)"
        secondLabel.text = "\(sSecond)"
        
        startButton.isHidden = false
        stopButton.isHidden = true
        resetButton.isHidden = true
    }
    
    @objc func startTimer() {
        second += 1
        if second == 60 {
            second = 0
            minute += 1
            if minute == 60 {
                minute = 0
                hour += 1
                if hour == 24 {
                    if timer.isValid {
                        timer.invalidate()
                    }
                }
            }
        }
        
        let sSecond = String(format:"%02d", second)
        let sMinute = String(format:"%02d", minute)
        let sHour = String(format:"%02d", hour)
        
        hourLabel.text = "\(sHour)"
        minuteLabel.text = "\(sMinute)"
        secondLabel.text = "\(sSecond)"
    }
    

}
