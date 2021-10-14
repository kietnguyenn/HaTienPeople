//
//  UpdatePasswordViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 08/10/2021.
//

import Foundation
import UIKit
import Alamofire

class RequestNewPasswordViewController: BaseViewController {
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    @IBAction func updateButtonTapped(_: UIButton) {
        let tuples = self.unwrapOptionals(new: newPasswordTextField, confirm: confirmNewPasswordTextField)
        guard let phone = self.phoneNumber, let resetId = self.id else { return }
        if validate(tuples.new, tuples.confirm) {
            self.requestNewPassword(newPassword: tuples.new, resetID: resetId, phone: phone)
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    let confirmingError = "Xác nhận mật khẩu không đúng!"
    let missingFieldError = "Vui lòng điền đẩy đủ 3 trường!"
    let success = "Đặt lại mật khẩu thành công!\n Đăng nhập với mật khẩu mới"
    
    var phoneNumber : String? {
        didSet{
            print(phoneNumber!)
        }
    }
    var id : String? {
        didSet{
            print(id!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func validate(_ new: String, _ confirm: String) -> Bool {
        if new.count>0 && confirm.count>0 {
            if new == confirm {
                return true
            } else {
                self.showAlert(errorMessage: confirmingError)
                return false
            }
        } else {
            self.showAlert(errorMessage: missingFieldError)
            return false
        }
    }
    
    func requestNewPassword(newPassword: String, resetID: String, phone: String) {
        let params : Parameters = [    "phoneNumber": phone,
                                       "id": resetID,
                                       "newPassword": newPassword ]
        requestApiResponseJson(urlString: Api.resetPasswordWithPhone,
                               method: .post, params: params,
                               encoding: JSONEncoding.default) { response, data  in
            print(response)
            self.showAlert(title: "Thành công", message: self.success, style: .alert) { (okAction) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func unwrapOptionals(new: UITextField, confirm: UITextField) -> (new: String, confirm: String) {
        guard let new = new.text, let confirm = confirm.text else {return ("", "")}
        return (new, confirm)
    }
}
