//
//  SignInViewController.swift
//  HaTienEmployeeLast
//
//  Created by MacBook on 10/1/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignInViewController: BaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signIn( sender : UIButton) {
        self.login()
    }
    
    @IBAction func signUp( sender: UIButton) {
        // show signup view
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func login() {
        let param: Parameters = ["userName" : self.usernameTextField.text!,
                                 "password" : self.passwordTextField.text!]
        requestNonTokenResponseString(urlString: Api.Auth.login, method: .post, params: param, encoding: JSONEncoding.default) { (responseString) in
            guard let jsonString = responseString.value else { return }
            guard let jsonData = jsonString.data(using: .utf8) else { return }
            // Save user data
            guard let currentUser = try? JSONDecoder().decode(Account.self, from: jsonData) else { return }
            self.setCurrentUser(user: currentUser)
            self.changeRootView()
        }
    }
    
    fileprivate func setCurrentUser(user: Account) {
        Account.current = user
        let jsonEncoder = JSONEncoder()
        if let encodedUserObject = try? jsonEncoder.encode(user) {
            UserDefaults.standard.setValue(encodedUserObject, forKey: "CurrentUser")
        } else {
            print("Can not encode User object")
        }
    }

    fileprivate func changeRootView() {
//        let eventPostingViewController = MyStoryboard.main.instantiateViewController(withIdentifier: "EventPostingViewController") as! EventPostingViewController
//        let mainNav = BaseNavigationController(rootViewController: eventPostingViewController)
        
//        AppDelegate.shared.window?.rootViewController = BaseTabBarController()
//        AppDelegate.shared.window?.makeKeyAndVisible()
        
        let maintab = BaseTabBarController()
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transitionOption: UIWindow.TransitionOptions = .init(direction: .toBottom, style: .easeInOut)
        window.setRootViewController(maintab, options: transitionOption)

    }
}
