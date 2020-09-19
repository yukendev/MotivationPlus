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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad Start")
        
        timerContainer.layer.borderWidth = 2.0
        timerContainer.layer.borderColor = UIColor.black.cgColor
        timerContainer.clipsToBounds = true
        timerContainer.layer.cornerRadius = 10
        
        startButton.layer.cornerRadius = 5
        stopButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        finishButton.layer.cornerRadius = 5
        
        stopButton.isHidden = true
        resetButton.isHidden = true
        finishButton.isHidden = true
        
        Auth.auth().signInAnonymously { [self] (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uidString = user.uid
            print(isAnonymous)
            print(uidString)
            self.uid = uidString
            db.collection("users").document(uid).updateData([
                "uid": uid
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        print("ViewDidLoad Finish")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewWillAppear Start")
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        db.collection("users").document(uid).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let documentArray = document.data()
                print("JK")
                print(documentArray!["uid"]!)
                if documentArray!["name"] == nil {
                    print("name is nil")
                    self.showAlert(title: "ユーザーネームを決めて下さい")
                }else{
                    print("name is not nil")
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
        print("finish!!!!!!")
        let sSecond = String(format:"%02d", second)
        let sMinute = String(format:"%02d", minute)
        let sHour = String(format:"%02d", hour)
        db.collection("users").document(uid).updateData([
            "state": "not studying",
            "studyTime": "\(sHour):\(sMinute):\(sSecond)"
        ])
        performSegue(withIdentifier: "modal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sSecond = String(format:"%02d", second)
        let sMinute = String(format:"%02d", minute)
        let sHour = String(format:"%02d", hour)
        let nextVC = segue.destination as! ModalViewController
        nextVC.timeText = "\(sHour):\(sMinute):\(sSecond)"
    }
    

}
