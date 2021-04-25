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
    let mainColor = UIColor.white
    
//    let textAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18.0),
//                          NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
    
    let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFontSize,
                                                          NSAttributedString.Key.foregroundColor: UIColor.systemBlue]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .systemBlue
        navigationBar.tintColor = .white
        navigationBar.backgroundColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }

}
