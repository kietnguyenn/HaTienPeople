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
import PasswordTextField
import SCLAlertView

let _customer = "Customer"
let _employee = "Employee"
let _admin = "Admin"

class SignInViewController: BaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signIn( sender : UIButton) {
        if validate(username: self.usernameTextField.text!, password: self.passwordTextField.text!) {
            self.login()
        } else {
            showAlert(errorMessage: "Tên đăng nhập hoặc mật khẩu không hợp lệ!")
        }
    }
    
    @IBAction func signUp( sender: UIButton) {
        // show signup view
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func getPassword(_ sender: UIButton) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "PhoneNumberVerificationViewController") as! PhoneNumberVerificationViewController
        let nav = BaseNavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func login() {
        let param: Parameters = ["userName" : self.usernameTextField.text!,
                                 "password" : self.passwordTextField.text!]
        _newApiRequestWithErrorHandling(url: Api.Auth.login,
                                        method: .post,
                                        param: param,
                                        encoding: JSONEncoding.default) { (response, jsondata, status) in
            if 200..<300 ~= status {
                if let currentUser = try? JSONDecoder().decode(Account.self, from: jsondata) {
                    self.setCurrentUser(user: currentUser)
                    self.changeRootView()
                } else if let error = try? JSONDecoder().decode(LogInErrorResponse.self, from: jsondata) {
                    guard let loginFailure = error.loginFailure else { return }
                    if loginFailure.count > 0 {
                        self.showAlert(errorMessage: loginFailure[0])
                    }
                }
            } else {
                if let error = try? JSONDecoder().decode(LogInErrorResponse.self, from: jsondata) {
                    guard let loginFailure = error.loginFailure else { return }
                    if loginFailure.count > 0 {
//                        self.showAlert(errorMessage: loginFailure[0])
                        self.showAlert(errorMessage: "Tên đăng nhập hoặc mật khẩu không đúng!")
                    }
                } else {
                    self.showAlert(errorMessage: response.value ?? "Lỗi kết nối đến server, vui lòng thử lại trong giấy lát!")
                }
            }
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
        let maintab = BaseTabBarController()
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transitionOption: UIWindow.TransitionOptions = .init(direction: .toBottom, style: .easeInOut)
        window.setRootViewController(maintab, options: transitionOption)
    }
    
    fileprivate func validate(username: String, password: String) -> Bool {
        if username.count > 0 && password.count > 0 {
            return true
        } else {
            return false
        }
    }
}

import Foundation
// MARK: - Login error response
struct LogInErrorResponse: Codable {
    let loginFailure: [String]?

    enum CodingKeys: String, CodingKey {
        case loginFailure = "login_failure"
    }
}

