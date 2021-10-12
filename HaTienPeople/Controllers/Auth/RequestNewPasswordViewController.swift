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
        if validate(tuples.new, tuples.confirm) {
            self.update(new: tuples.new, id: tuples.confirm)
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    let error = "Xác nhận mật khẩu không đúng!"
    let error2 = "Vui lòng điền đẩy đủ 3 trường!"
    let success = "Cập nhật mật khẩu thành công!"
    
    var phoneNumber : String?
    var id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validate(_ new: String, _ confirm: String) -> Bool {
        if new.count>0 && confirm.count>0 {
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
    
    func update(new: String, id: String) {
        let params: Parameters = [    "phoneNumber": phoneNumber,
                                      "id": id,
                                      "newPassword": new
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
    
    func unwrapOptionals(new: UITextField, confirm: UITextField) -> (new: String, confirm: String) {
        guard let new = new.text, let confirm = confirm.text else {return ("", "")}
        return (new, confirm)
    }
}
