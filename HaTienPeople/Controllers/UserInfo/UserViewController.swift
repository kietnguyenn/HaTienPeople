//
//  UserViewController.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/8/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Presentr
import Alamofire

class UserViewController: BaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func changePasswordButtonTapped(_ : UIButton) {
        self.showUpdatePasswordView()
    }
    
    @IBAction func updateButtonTapped(_ : UIButton) {
        guard let name = nameTextField.text, let phone = phoneTextField.text, let email = emailTextField.text else { return }
        if name.count>0, phone.count>0, email.count>0 {
            let param : Parameters = [  "phoneNumber": phone,
                                        "fullName": name,
                                        "email": email
            ]
            _newApiRequestWithErrorHandling(url: Api.users, method: .put, param: param, encoding: JSONEncoding.default) { (response, data, status) in
                if status == 200 {
                    self.showAlert(title: "Thành công!", message: "Cập nhật thông tin người dùng thành công!", style: .alert) { (ok) in
                        //
                        self.view.endEditing(true)
                    }
                } else if status == 400 {
                    self.showAlert(errorMessage: "Mật khẩu")
                }
            }
        } else {
            self.showAlert(errorMessage: "Vui lòng điền đẩy đủ thông tin!")
        }
    }
    
    var presenter = Presentr(presentationType: .bottomHalf)
    
    var customerInfo: CustomerInfo? {
        didSet {
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cập nhật thông tin cá nhân"
        self.setupUI()
        self.getInfo()
        self.showBackButton()
    }
    
    func setupUI() {
        guard let customerInfo = self.customerInfo else { return }
        self.nameTextField.text = customerInfo.fullName
        self.usernameTextField.text = customerInfo.userName
        self.phoneTextField.text = customerInfo.phoneNumber
        self.emailTextField.text = customerInfo.email
    }
    
    func getInfo() {
        newApiRerequest_responseString(url: Api.userInfo, method: .get, param: nil, encoding: URLEncoding.default) { (response, data, status) in
            guard let userInfo = try? JSONDecoder().decode(CustomerInfo.self, from: data) else { return }
            self.customerInfo = userInfo
        }
    }
    
    func showUpdatePasswordView() {
        guard let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "UpdatePasswordViewController" ) as? UpdatePasswordViewController else { return }
        customPresentViewController(self.presenter, viewController: vc, animated: true)
    }
}
