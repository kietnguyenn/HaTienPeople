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
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir-Bold", size: 20)!,
            kTextFont: UIFont(name: "Avenir", size: 14)!,
            kButtonFont: UIFont(name: "Avenir-DemiBold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let txt = alertView.addTextField("Nhập số điện thoại")
        alertView.addButton("Ok", target:self, selector:#selector(self.okButtonTapped))
        alertView.addButton("Hủy") {
            print("Second button tapped")
        }
        alertView.showEdit("Xác thực số điện thoại", subTitle: "Nhận mã xác thực OTP qua số điện thoại")
    }

    @objc func okButtonTapped() {
        
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
    
    func showOtpAuthVc() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPAuthViewController") as! OTPAuthViewController
        let nav = BaseNavigationController(rootViewController: vc)
        vc.delegate = self
        self.present(nav, animated: true) {
            vc.modalPresentationStyle = .fullScreen
            vc.showDismissButton(title: "Hủy")
            vc.title = "Xác thực OTP"
        }
    }
    
    fileprivate func sendOTP(with phoneNum: String) {
        self.showHUD()
        guard let url = URL(string: Api.sendOTPCode + "?phoneNumber=\(phoneNum)") else { return }
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseString { [weak self] (response) in
            guard let wSelf = self else { return }
            wSelf.hideHUD()
            guard let statusCode = response.response?.statusCode else { return }
            print("code",  statusCode)
            if 200..<300 ~= statusCode && response.result.isSuccess {
                // show OTP verification vc /  Did not verified
                wSelf.showOtpAuthVc()
            } else if statusCode == 400 {
                guard let jsonString = response.value
                else { return }
                print(jsonString)
                if jsonString == "Tài khoản đã xác thực" || jsonString == "IS_CONFIRMED" {
                    
                }
            } else {
                wSelf.showAlert(errorMessage: Constant.AlertContent.serverError)
            }
        }
    }
}

extension SignInViewController : OTPAuthViewControllerDelegate {
    func didVerifyOTP() {
        // SHOW UPDATE PASSWORD VIEW
        
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
