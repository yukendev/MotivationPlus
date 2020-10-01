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
        stateLabel.layer.cornerRadius = 5
        stateLabel.clipsToBounds = true
        iconImageView.layer.cornerRadius = 5
        animationContainer.backgroundColor = UIColor.clear
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showAnimation(state: String, speed: Double) {
        print("アニメーション！！！！！")
        animationView.removeFromSuperview()
        switch state {
        case "studying":
            animationView = AnimationView(name: "run")
        case "not studying":
            animationView = AnimationView(name: "sleep")
        case "finish":
            animationView = AnimationView(name: "finish")
        default:
            print("default")
        }
        animationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        animationView.loopMode = .loop
        animationView.animationSpeed = CGFloat(speed)
        animationContainer.addSubview(animationView)
        animationView.play()
    }
    
}
