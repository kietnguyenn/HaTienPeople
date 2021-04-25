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
                self.showAlert(errorMessage: "Không thể tạo tài khoản! \(resString)")
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
              else { return  }
        
        if password == confirm {
            // Check username
            self._newApiRequestWithErrorHandling(url: "https://apindashboard.vkhealth.vn/api/Users/ExistedUsername?username=\(username)&roleName=Customer", method: .get, param: nil, encoding: URLEncoding.default) { (responseString, data, status) in
                if status == 200 {
                    self.showAlert(errorMessage: "Tên đăng nhập đã tồn tại!")
                }
                else if status == 400 {
                    // CHeck phone Number
                    self._newApiRequestWithErrorHandling(url: "https://apindashboard.vkhealth.vn/api/Users/ExistedPhone?username=\(phone)&roleName=Customer", method: .get, param: nil, encoding: URLEncoding.default) { (responseString, data, status) in
                        if status == 200 {
                            self.showAlert(errorMessage: "Số điện thoại đã tồn tại")
                        } else if status == 400 {
                            if email.isEmail {
                                self.signUp(username: username, password: password, phone: phone, fullname: fullname, email: email)
                            } else {
                                self.showAlert(errorMessage: "Email không hợp lệ!")
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert(errorMessage: "Xác nhận mật khẩu không thành công!")
        }
    }
    
//    func existedUserName(_ userName: String) -> Bool {
//        var result = Bool()
//        _newApiRequestWithErrorHandling(url: "https://apindashboard.vkhealth.vn/api/Users/ExistedUsername?username=\(userName)&roleName=Customer", method: .get, param: nil, encoding: URLEncoding.default) { (responseString, data, status) in
//            if status == 200 {
//                result = false
//            } else if status == 400 {
//                result = true
//            }
//        }
//        return true
//    }
//
//    func existedPhone(_ phone: String) -> Bool {
//        var result = Bool()
//        _newApiRequestWithErrorHandling(url: "https://apindashboard.vkhealth.vn/api/Users/ExistedPhone?username=\(phone)&roleName=Customer", method: .get, param: nil, encoding: URLEncoding.default) { (responseString, data, status) in
//            if status == 200 {
//                result = false
//            } else if status == 400 {
//                result = true
//            }
//        }
//        return true
//    }
}
