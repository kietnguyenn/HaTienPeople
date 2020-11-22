//
//  UserViewController.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/8/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: BaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBAction func signOut(_:UIButton) {
        let signInVc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transitionOption: UIWindow.TransitionOptions = .init(direction: .toTop, style: .easeInOut)
        UserDefaults.standard.setValue(nil, forKey: "CurrentUser")
        window.setRootViewController(signInVc, options: transitionOption)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tài khoản"
        self.setupUI()
    }
    
    func setupUI() {
        guard let current = Account.current else { return }
        self.nameTextField.text = current.fullname
        self.usernameTextField.text = current.userName
        self.phoneTextField.text = current.roles
    }
}
