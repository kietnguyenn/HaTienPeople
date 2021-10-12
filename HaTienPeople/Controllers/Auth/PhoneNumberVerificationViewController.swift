//
//  PhoneNumberVerificationViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 11/10/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftUI

class PhoneNumberVerificationViewController: BaseViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var textfieldWrapperView: UIView!
    
    let wrongFormattedPhoneNumMessage = "Số điện thoại không đúng!"
    let cancel = "Hủy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quên mật khẩu"
        showDismissButton(title: cancel)
        setShawdowForWrapperView(self.textfieldWrapperView)
    }
    
    @IBAction func verifyButtonTapped(_ : UIButton) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        if phoneNumber.count == 10 {
            self.sendOtpForResetPassword(with: phoneNumber)
        } else {
            self.showAlert(errorMessage: wrongFormattedPhoneNumMessage)
        }
    }
    
    func setShawdowForWrapperView(_ wView: UIView){
        wView.layer.shadowColor = UIColor.lightGray.cgColor
        wView.layer.shadowOpacity = 0.5
        wView.layer.shadowOffset = .zero
        wView.layer.shadowRadius = 5
        wView.layer.masksToBounds = false
        wView.clipsToBounds = true
//        wView.layer.shadowPath = UIBezierPath(rect: wView.bounds).cgPath
//        wView.layer.shouldRasterize = true
//        wView.layer.rasterizationScale = UIScreen.main.scale
        wView.layer.cornerRadius = 8.0
//        wView.layer.masksToBounds = true

    }
    
    func sendOtpForResetPassword(with phoneNumber: String) {
        _newApiRequestWithErrorHandling(url: Api.sendOTPCodeNonVerified,
                                        method: .post,
                                        param: ["phoneNumber" : phoneNumber],
                                        encoding: URLEncoding.queryString) {
            (response, jsondata, status) in
            if 200..<300 ~= status {
                self.showOtpAuthVc(with: phoneNumber)
            } else if 400...500 ~= status {
                let error = response.value ?? Constant.AlertContent.serverError
                self.showAlert(errorMessage: error)
            }
        }
    }
    
    func showOtpAuthVc(with phone: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPAuthViewController") as! OTPAuthViewController
        vc.delegate = self
        vc.phoneNumber = phone
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhoneNumberVerificationViewController: OTPAuthViewControllerDelegate {
    func didVerifyOTP() {
        
    }
}
