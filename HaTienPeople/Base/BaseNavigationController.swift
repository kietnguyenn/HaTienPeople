//
//  BaseNavigationController.swift
//  Garage-admin
//
//  Created by LOU on 4/22/20.
//  Copyright © 2020 LOU. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

class BaseNavigationController: UINavigationController {
    
    let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFontSize,
                                                          NSAttributedString.Key.foregroundColor: UIColor.white]
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // text and content color
        navigationBar.tintColor = accentColor
        
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
//            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .white
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            
        } else {
            navigationBar.barStyle = .black
            // bar color
            navigationBar.barTintColor = .white
            navigationBar.isTranslucent = false
            //background
            navigationBar.backgroundColor = .white
        }
    }
}


