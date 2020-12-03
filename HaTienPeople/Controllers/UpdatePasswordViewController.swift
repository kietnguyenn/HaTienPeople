//
//  UpdatePasswordViewController.swift
//  HaTienPeople
//
//  Created by Apple on 12/3/20.
//

import Foundation
import UIKit
import Alamofire

class UpdatePasswordViewController: BaseViewController {
    @IBOutlet weak var oldPasswordTf: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    
    @IBAction func updateButtonTapped(_: UIButton) {
        let tuples = self.unwrapOptionals(old: oldPasswordTf, new: newPasswordTf, confirm: confirmNewPassword)
        if validate(tuples.old, tuples.new, tuples.confirm) {
            self.update(old: tuples.old, new: tuples.new, confirm: tuples.confirm)
        }
    }
    
    let error = "Xác nhận mật khẩu không đúng!"
    let error2 = "Vui lòng điền đẩy đủ 3 trường!"
    let success = "Cập nhật mật khẩu thành công!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validate(_ old: String, _ new: String, _ confirm: String) -> Bool {
        if old.count>0 && new.count>0 && confirm.count>0 {
            if new == confirm {
                return true
            } else {
                self.showAlert(errorMessage: error2)
                return false
            }
        } else {
            self.showAlert(errorMessage: error)
            return false
        }
    }
    
    func update(old: String, new: String, confirm: String) {
        let params: Parameters = [  "oldPassword": old,
                                    "newPassword": confirm
        ]
        newApiRerequest_responseString(url: Api.password,
                                       method: .post,
                                       param: params,
                                       encoding: JSONEncoding.default) { (response, jsondata, status) in
            if status == 200 || status == 201 {
                self.showAlert(title: "Thành công", message: self.success, style: .alert) { (okAction) in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.showAlert(errorMessage: response.error.debugDescription)
            }
        }
    }
    
    func unwrapOptionals(old: UITextField, new: UITextField, confirm: UITextField) -> (old: String, new: String, confirm: String) {
        guard let old = old.text, let new = new.text, let confirm = confirm.text else {return ("", "", "")}
        return (old, new, confirm)
    }
}
