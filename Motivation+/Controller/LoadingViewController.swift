//
//  LoadingViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/10/07.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore

class LoadingViewController: UIViewController {
    
    var uid = String()
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アニメーション開始
        showAnimation()
        
        Auth.auth().signInAnonymously { [self] (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous  // true
            let uidString = user.uid
            print(isAnonymous)
            print(uidString)
            print("匿名ログイン完了")
            self.uid = uidString
            
            db.collection("users").document(uid).updateData([
                "uid": uid,
                "userId":"@" + uid.prefix(5)
            ]) { err in
//                screenActive()
//                アニメーション開始
                
                
                if err != nil {
                    db.collection("users").document(uid).setData([
                        "uid": uid,
                        "userId":"@" + uid.prefix(5),
                        "state": "not studying",
                        "followers": [],
                        "requests": [],
                        "studyTime": []
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    performSegue(withIdentifier: "loadingComplete", sender: nil)
                } else {
                    performSegue(withIdentifier: "loadingComplete", sender: nil)
                    print("Document successfully written!")
                }
            }
        }

    }
    
    func showAnimation() {
        var animationView = AnimationView()
        animationView = AnimationView(name: "loading")
        animationView.loopMode = .loop
        animationView.center = self.view.center
        
        self.view.addSubview(animationView)
        animationView.play()
    }
    
}
