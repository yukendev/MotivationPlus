//
//  FollowerTableViewCell.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/12.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit
import Lottie

class FollowerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var animationContainer: LottieView!
    
    var animationView = AnimationView()
    
    
    var uid = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContainer.layer.cornerRadius = 5
        nameLabel.layer.cornerRadius = 5
        nameLabel.clipsToBounds = true
        nameLabel.tintColor = UIColor.white
        stateLabel.layer.cornerRadius = 5
        stateLabel.clipsToBounds = true
        iconImageView.layer.cornerRadius = 5
        animationContainer.backgroundColor = UIColor.clear
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showAnimation(state: String, speed: Double, login: Int) {
        print("アニメーション！！！！！")
        if login != 0 {
            print("あんまログインしてないやつ")
            animationContainer.isHidden = false
            stateLabel.isHidden = false
            stateLabel.text = String(login) + "日前"
            stateLabel.font = stateLabel.font.withSize(15)
            stateLabel.backgroundColor = UIColor.clear
            print(String(login) + "日前")
            return
        }
        animationView.removeFromSuperview()
        switch state {
        case "initial":
            print("最初です")
            animationContainer.isHidden = true
            stateLabel.text = "勉強中"
            stateLabel.isHidden = true
        case "studying":
            print("勉強しています")
            animationContainer.isHidden = false
            animationView = AnimationView(name: "run")
            stateLabel.backgroundColor = UIColor.orange
            stateLabel.text = "勉強中"
            stateLabel.isHidden = false
        case "not studying":
            print("休憩しています")
            animationContainer.isHidden = false
            animationView = AnimationView(name: "sleep")
            stateLabel.backgroundColor = UIColor.green
            stateLabel.text = "休憩中"
            stateLabel.isHidden = false
        case "finish":
            print("終了しています")
            animationContainer.isHidden = false
            animationView = AnimationView(name: "finish")
            stateLabel.backgroundColor = UIColor.systemYellow
            stateLabel.isHidden = false
        case "timeout":
            print("タイムアウトしています")
            animationContainer.isHidden = true
            stateLabel.isHidden = true
            stateLabel.backgroundColor = UIColor.white
        default:
            print("default")
//            animationContainer.isHidden = true
//            loginLabel.isHidden = true
            
            return
        }
        animationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        animationView.loopMode = .loop
        animationView.animationSpeed = CGFloat(speed)
        animationContainer.addSubview(animationView)
        animationView.play()
    }
    
}
