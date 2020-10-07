//
//  FollowerViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var timerContainer: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var timer = Timer()
    var second: Int = 0
    var minute: Int = 0
    var hour: Int = 0
    var uid = String()
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerContainer.layer.borderWidth = 2.0
        timerContainer.layer.borderColor = UIColor.gray.cgColor
        timerContainer.clipsToBounds = true
        timerContainer.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 5
        stopButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        finishButton.layer.cornerRadius = 5
        stopButton.isHidden = true
        resetButton.isHidden = true
        finishButton.isHidden = true
        startButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        startButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        stopButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        stopButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        resetButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        finishButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        uid = user!.uid
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.onDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenActive()
    }
    
    
    @objc func onDidBecomeActive() {
        if uid != "" {
            screenActive()
        }else{
            print("uidが空白です")
        }
    }
    
    
    @objc func willResignActiveNotification() {
        saveTimer()
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        db.collection("users").document(uid).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let documentArray = document.data()
                if documentArray!["name"] == nil {
                    self.showAlert(title: "ユーザーネームを決めて下さい")
                }else{
                    db.collection("users").document(uid).updateData([
                        "state": "studying",
                        "studyTime": ""
                    ])
                    if !timer.isValid {
                        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
                    }
                    startButton.isHidden = true
                    stopButton.isHidden = false
                    resetButton.isHidden = true
                    finishButton.isHidden = true
                }
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    
    @IBAction func stopAction(_ sender: Any) {
        db.collection("users").document(uid).updateData([
            "state": "not studying"
        ])
        if timer.isValid {
            timer.invalidate()
        }
        startButton.isHidden = false
        stopButton.isHidden = true
        resetButton.isHidden = false
        finishButton.isHidden = false
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
        finishButton.isHidden = true
    }
    
    
    @objc func startTimer() {
        hour = Int(hourLabel.text!)!
        minute = Int(minuteLabel.text!)!
        second = Int(secondLabel.text!)!
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
        hourChech(hour: hour)
    }
    
    
    @IBAction func finishAction(_ sender: Any) {
        showAlert2(title: "本当に勉強を終了しますか？")
    }
    
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert2(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "はい", style: .default) { (alert) in
            self.okAction()
        }
        let cansel = UIAlertAction(title: "いいえ", style: .cancel)
        alertController.addAction(cansel)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func okAction() {
        var sSecond = String(format:"%02d", second)
        var sMinute = String(format:"%02d", minute)
        var sHour = String(format:"%02d", hour)
        db.collection("users").document(uid).updateData([
            "state": "finish",
            "studyTime": "\(sHour):\(sMinute):\(sSecond)"
        ])
        performSegue(withIdentifier: "modal", sender: nil)
        second = 0
        minute = 0
        hour = 0
        timer.invalidate()
        sSecond = String(format:"%02d", second)
        sMinute = String(format:"%02d", minute)
        sHour = String(format:"%02d", hour)
        hourLabel.text = "\(sHour)"
        minuteLabel.text = "\(sMinute)"
        secondLabel.text = "\(sSecond)"
        startButton.isHidden = false
        stopButton.isHidden = true
        resetButton.isHidden = true
        finishButton.isHidden = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sSecond = String(format:"%02d", second)
        let sMinute = String(format:"%02d", minute)
        let sHour = String(format:"%02d", hour)
        let nextVC = segue.destination as! ModalViewController
        nextVC.timeText = "\(sHour):\(sMinute):\(sSecond)"
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
    
   
    func saveTimer() {
        if Int(hourLabel.text!)! >= 24 {
            hourLabel.text = "00"
            minuteLabel.text = "00"
            secondLabel.text = "00"
        }
        db.collection("users").document(uid).updateData([
            "timer": "\(String(describing: hourLabel.text!)):\(String(describing: minuteLabel.text!)):\(String(describing: secondLabel.text!))"
        ])
    }
    
    
    func showTimer() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if error != nil {
                print(error!)
                return
            }
            if snapshot != nil {
                let timerString = snapshot!["timer"] as! String
                let timerArray = timerString.components(separatedBy: ":")
                let dbSecond = Int(timerArray[2])
                let dbMinute = Int(timerArray[1])
                let dbHour = Int(timerArray[0])
                let lastTime = dateFormatter.date(from: snapshot!["lastTime"] as! String)
                let diffSecond = Int(lastTime!.secondsFrom())
                var timerHour = dbHour!
                var timerMinute = dbMinute!
                var timerSecond = dbSecond! + diffSecond
                if timerSecond > 59 {
                    let toMinute = timerSecond / 60
                    timerMinute += toMinute
                    timerSecond = timerSecond % 60
                }
                if timerMinute > 59 {
                    let toHour = timerMinute / 60
                    timerHour += toHour
                    timerMinute = timerMinute % 60
                    hourChech(hour: timerHour)
                }
                secondLabel.text = String(format:"%02d", timerSecond)
                minuteLabel.text = String(format:"%02d", timerMinute)
                hourLabel.text = String(format:"%02d", timerHour)
                second = timerSecond
                minute = timerMinute
                hour = timerHour
                if !timer.isValid {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    
    func showStopTimer() {
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                let timerString = snapshot!["timer"] as! String
                let timerArray = timerString.components(separatedBy: ":")
                let dbSecond = timerArray[2]
                let dbMinute = timerArray[1]
                let dbHour = timerArray[0]
                
                hourLabel.text = dbHour
                minuteLabel.text = dbMinute
                secondLabel.text = dbSecond
            }
        }
    }
    
    
    func screenActive() {
        db.collection("users").document(uid).getDocument { [self] (snapshot, error) in
            if snapshot != nil {
                switch snapshot!["state"] as! String {
                case "studying":
                    startButton.isHidden = true
                    stopButton.isHidden = false
                    resetButton.isHidden = true
                    finishButton.isHidden = true
                    showTimer()
                case "not studying":
                    startButton.isHidden = false
                    stopButton.isHidden = true
                    resetButton.isHidden = false
                    finishButton.isHidden = false
                    showStopTimer()
                case "finish":
                    startButton.isHidden = false
                    stopButton.isHidden = true
                    resetButton.isHidden = true
                    finishButton.isHidden = true
                default:
                    startButton.isHidden = false
                    stopButton.isHidden = true
                    resetButton.isHidden = true
                    finishButton.isHidden = true
                }
            }
        }
    }
    
    
    func hourChech(hour: Int) {
        if hour >= 24 {
            secondLabel.text = "00"
            minuteLabel.text = "00"
            hourLabel.text = "00"
            
            if timer.isValid {
                timer.invalidate()
            }
            db.collection("users").document(uid).updateData([
                "state": "timeout"
            ])
        }
        return
    }
    
    
}
