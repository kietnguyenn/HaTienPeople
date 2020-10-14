//
//  SignUpViewControlelr.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireSwiftyJSON

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField:UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBAction func signUpButtonTapped(_: UIButton) {
        self.validate()
    }
    
    @IBAction func cancel(_: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func signUp(username: String, password: String, phone: String, fullname: String) {
        let params: Parameters = [  "userName": username,
                                    "password": password,
                                    "phoneNumber": phone,
                                    "fullName": fullname,
                                    "title": ""]
        requestNonTokenResponseString(urlString: "https://apindashboard.vkhealth.vn/api/Users", method: .post, params: params, encoding: JSONEncoding.default) { (response) in
            self.showAlert(title: "Thành công", message: "Đăng kí tài khoản thành công!", style: .alert, hasTwoButton: false) { (action) in
                self.dismiss(animated: true)
            }
        }
    }
    
    fileprivate func validate() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let confirm = confirmTextField.text,
              let phone = phoneTextField.text,
              let fullname = fullnameTextField.text
              else { return }
        
        if password == confirm {
            self.signUp(username: username, password: password, phone: phone, fullname: fullname)
        } else {
            self.showAlert(errorMessage: "Xác nhận mật khẩu không thành công!")
        }
        
    }
}
