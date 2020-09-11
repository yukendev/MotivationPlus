//
//  TabBarViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        UITabBarItem.appearance().setTitleTextAttributes([ .foregroundColor : UIColor.white], for: .selected)
        UITabBar.appearance().tintColor = UIColor.white
    }
    


}
