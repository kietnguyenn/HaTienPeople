//
//  BaseTabBarController.swift
//  Garage-admin
//
//  Created by Macbook on 5/3/20.
//  Copyright © 2020 LOU. All rights reserved.
//

import UIKit
import DynamicColor

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()        
        // Main Vieww
        guard let camImage = UIImage(named: "icon-tab-home")  else { return }
        let homeItem = UITabBarItem(title: "Trang chủ",
                                    image: camImage,
                                    selectedImage: nil)
        let homeVc = MyStoryboard.main.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let homeNav = BaseNavigationController(rootViewController: homeVc)
        homeNav.tabBarItem = homeItem
//        
        // event líst
        guard let eventListImage = UIImage(named: "icon-tab-calendar")  else { return }
        let eventListItem = UITabBarItem(title: "Sự kiện đã đăng",
                                         image: eventListImage,
                                         selectedImage: nil)
        let eventListVc = MyStoryboard.main.instantiateViewController(withIdentifier: "EventListViewController") as! EventListViewController
        let eventListNav = BaseNavigationController(rootViewController: eventListVc)
        eventListNav.tabBarItem = eventListItem
        
        // Noti
        guard let notiImage = UIImage(named: "bell-icon-3")  else { return }
        let notiItem = UITabBarItem(title: "Thông báo", image: notiImage, selectedImage: nil)
        let notiVc = MyStoryboard.main.instantiateViewController(withIdentifier: "NotiViewController") as! NotiViewController
        let notiNav = BaseNavigationController(rootViewController: notiVc)
        notiNav.tabBarItem = notiItem
        
        // user info
        guard let userImage = UIImage(named: "icon-tab-account")  else { return }
        let accountItem = UITabBarItem(title: "Tài khoản",
                                         image: userImage,
                                         selectedImage: nil)
        let userVc = MyStoryboard.main.instantiateViewController(withIdentifier: "ProfileOptionsViewController") as! ProfileOptionsViewController
        let userNav = BaseNavigationController(rootViewController: userVc)
        userNav.tabBarItem = accountItem
        
        tabBar.tintColor = accentColor
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
 
        self.viewControllers = [homeNav, eventListNav, userNav]
    }
    
    func resizeImage(_ uiImage: UIImage) -> UIImage {
        uiImage.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        return uiImage.resizeImage(targetSize: CGSize(width: 30, height: 30))
    }
}
