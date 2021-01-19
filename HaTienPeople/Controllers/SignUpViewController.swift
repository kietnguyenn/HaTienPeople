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
import PasswordTextField

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func signUpButtonTapped(_: UIButton) {
        self.validate()
    }
    
    @IBAction func cancel(_: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func signUp(username: String, password: String, phone: String, fullname: String, email: String) {
        let params: Parameters = [  "userName": username,
                                    "password": password,
                                    "phoneNumber": phone,
                                    "fullName": fullname,
                                    "title": "",
                                    "email": email]
        _newApiRequestWithErrorHandling(url: Api.users,
                                        method: .post,
                                        param: params,
                                        encoding: JSONEncoding.default) { (res, data, status) in
            print(res)
            if status == 200 || status == 201 {
                self.showAlert(title: "Thành công", message: "Đăng kí tài khoản thành công!", style: .alert, hasTwoButton: false) { (action) in
                    self.dismiss(animated: true)
                }
            } else if status == 400 {
                guard let resString = res.value else { return }
                if resString == "User name 'kiet97' is already taken." {
                    self.showAlert(errorMessage: "Lỗi \(status) \n \(resString)")
                } else {
                    self.showAlert(errorMessage: "Không thể tạo tài khoản! \nCode \(status)")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    print(json as Any)
                } catch {
                    print("Something went wrong")
                }
            } else if status == 500 {
                self.showAlert(errorMessage: "Lỗi server!")
            }
        }
    }
    
    fileprivate func validate() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let confirm = confirmTextField.text,
              let phone = phoneTextField.text,
              let fullname = fullnameTextField.text,
              let email = emailTextField.text
              else { return }
        
        if password == confirm {
            if email.isEmail {
                self.signUp(username: username, password: password, phone: phone, fullname: fullname, email: email)
            } else {
                self.showAlert(errorMessage: "Email không hợp lệ!")
            }
        } else {
            self.showAlert(errorMessage: "Xác nhận mật khẩu không thành công!")
        }
        
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
