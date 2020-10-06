//
//  TabBarViewController.swift
//  Motivation+
//
//  Created by 手塚友健 on 2020/09/11.
//  Copyright © 2020 手塚友健. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, myTabBarDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        selectedIndex = 1
    }
    

    func tabBerNotEnabled() {
        print("tabBerNotEnabled発動")
        self.tabBar.items![0].isEnabled = false
        self.tabBar.items![0].isEnabled = false
        self.tabBar.items![0].isEnabled = false
    }
    
    func tabBarEnabled() {
        print("tabBerEnabled発動")
        self.tabBar.items![0].isEnabled = true
        self.tabBar.items![0].isEnabled = true
        self.tabBar.items![0].isEnabled = true
    }

}
