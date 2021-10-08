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
        // show otp auth vc
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
                    guard let loginFailure = error.value?.loginFailure?[0] else { return }
                    self.showAlert(errorMessage: loginFailure)
                }
            } else if status == 400 {
                self.showAlert(errorMessage: "Lỗi kết nối vui lòng thử lại sau ít phút")
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
    let value: Value?
    let formatters, contentTypes: [JSONNull]?
    let declaredType: JSONNull?
    let statusCode: Int?
}

// MARK: - Value
struct Value: Codable {
    let loginFailure: [String]?
    
    enum CodingKeys: String, CodingKey {
        case loginFailure = "login_failure"
    }
}
