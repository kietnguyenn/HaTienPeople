//
//  OTPAuthViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol OTPAuthViewControllerDelegate: AnyObject {
    func didVerifyOTP()
}

class OTPAuthViewController: BaseViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBAction func resendOTPCode(_ sender: UIButton) {
        if let phoneNumber = self.phoneNumber {
            // resetPassword request
            self.sendOtpForResetPassword(with: phoneNumber)
        } else {
            guard let phoneNum = UserInfo.current?.phoneNumber else { return }
            self.sendOTP(with: phoneNum)
        }
    }
    @IBAction func verifyOTPCode(_ sender: UIButton) {
        guard let otpCode = self.textField.text else { return }
        if let phoneNumber = self.phoneNumber {
            self.verify(phone: phoneNumber, otp: otpCode)
        } else {
            guard let phoneNumber = UserInfo.current?.phoneNumber else { return }
            self.verifyOTP(phoneNumber, otpCode)
        }
    }
    
    var delegate: OTPAuthViewControllerDelegate!
    var countTimer : Timer!
    var counter = 60
    var phoneNumber : String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverForTextField()
        self.showDismissButton(title: "Hủy")
        self.verifyButton.isEnabled = false
        self.startTimer()
    }
    
    func addObserverForTextField() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.listeningToTextField(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: self.textField)
        self.textField.resignFirstResponder()
    }
    
    func startTimer() {
        counter = 60
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                               target: self,
                                               selector: #selector(self.changeTitle),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    @objc func changeTitle() {
        if counter != 0 {
            resendButton.setTitle("Gửi lại mã trong \(counter)", for: .normal)
            resendButton.isEnabled = false
            counter -= 1
        } else {
            countTimer.invalidate()
            resendButton.setTitle("Gửi lại mã", for: .normal)
            resendButton.isEnabled = true
        }
    }
    
    fileprivate func sendOTP(with phoneNum: String) {
        self.showHUD()
        guard let url = URL(string: Api.sendOTPCode) else { return }
        Alamofire.request(url, method: .post, parameters: ["phoneNumber": phoneNum], encoding: URLEncoding.default, headers: nil).responseString { [weak self] (response) in
            guard let wSelf = self else { return }
            wSelf.hideHUD()
            guard let statusCode = response.response?.statusCode else { return }
            print("code",  statusCode)
            if 200..<300 ~= statusCode && response.result.isSuccess {
                wSelf.showAlert(title: "Thành công", message: "Đã gửi mã OTP đến số điện thoại \(phoneNum)!", style: .alert) { _ in
                    wSelf.startTimer()
                }
            } else if statusCode == 400 {
                guard let jsonString = response.value
                else { return }
                if jsonString == "Tài khoản đã xác thực" {
                    
                }
            } else {
                wSelf.showAlert(errorMessage: "Hệ thống đang gặp sự cố, xin thử lại trong giây lát!")
            }
        }
    }
    
    func sendOtpForResetPassword(with phoneNumber: String) {
        _newApiRequestWithErrorHandling(url: Api.sendOTPCodeNonVerified,
                                        method: .post,
                                        param: ["phoneNumber" : phoneNumber],
                                        encoding: URLEncoding.queryString) {
            (response, jsondata, status) in
            if 200..<300 ~= status {

            } else {
                self.showAlert(errorMessage: "\(response.value ?? Constant.AlertContent.serverError)")
            }
        }
    }
    
    fileprivate func verifyOTP(_ phoneNum: String, _ code: String) {
        newApiRerequest_responseString(url: Api.verifyOTPCode,
                                       method: .post,
                                       param: ["phoneNumber": phoneNum,
                                               "otp": code],
                                       encoding: JSONEncoding.default) { [weak self] (response, data, status) in
            guard let wSelf = self else { return }
            print("request OTP", status)
            wSelf.showAlert(title: "Thành công", message: "Xác thực OTP thành công!", style: .alert) { _ in
                wSelf.dismiss(animated: true) {
                    wSelf.delegate.didVerifyOTP()
                }
            }
        }
    }
    
    func verify(phone: String, otp: String) {
        _newApiRequestWithErrorHandling(url: Api.verifyOTPForNewPassword,
                                        method: .post,
                                        param: [ "phoneNumber": phone,
                                                 "otp": otp],
                                        encoding: JSONEncoding.default) { res, data, status in
            if 200..<300 ~= status {
                // move to otp auth
                self.showAlert(title: "Thành công", message: "Xác thực số điện thoại thành công!", style: .alert, hasTwoButton: false, actionButtonTitle: "Tạo mật khẩu mới") { action in
                    
                }
            } else if 400..<500 ~= status {
                let error = res.value ?? "Lỗi, code \(status)"
                self.showAlert(errorMessage: error)
            } else if status == 500 {
                self.showAlert(errorMessage: Constant.AlertContent.serverError)
            }
        }
    }
    
    @objc func listeningToTextField(_: NotificationCenter) {
        if textField.text?.count == 6 {
            self.toggleVerifyButton(isEnable: true)
        } else {
            self.toggleVerifyButton(isEnable: false)
        }
    }
    
    func toggleVerifyButton(isEnable: Bool) {
        self.verifyButton.isEnabled = isEnable
        if isEnable {
            self.verifyButton.backgroundColor = accentColor
        } else {
            self.verifyButton.backgroundColor = .lightGray
        }
    }
}

extension OTPAuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {
            return true
        }
        if !string.isEmpty {
            field.text = string
            field.resignFirstResponder()
            field.nextTextFiled?.becomeFirstResponder()
            return true
        }
        return true
    }
}

