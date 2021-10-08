//
//  MainViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftSignalRClient

class MainViewController: BaseViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var customerInfo : CustomerInfo? {
        didSet {
            UserInfo.current = customerInfo!
            guard let phoneNum = UserInfo.current?.phoneNumber,
                    let name = UserInfo.current?.fullName
            else { return }
            self.currentPhoneNumber = phoneNum
            print("phone", phoneNum)
            self.userNameLabel.text = name
        }
    }
    
    var currentPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func showExaminationResult(_ sender: UIButton) {
        self.sendOTP(with: self.currentPhoneNumber)
    }
    
    @IBAction func showEventPostingView(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventPostingViewController") as! EventPostingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showNotification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotiViewController") as! NotiViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // First get user info
    func getUserInfo() {
        newApiRerequest_responseString(url: Api.userInfo, method: .get, param: nil, encoding: URLEncoding.default) { (response, data, status) in
            guard let userInfo = try? JSONDecoder().decode(CustomerInfo.self, from: data) else { return }
            self.customerInfo = userInfo
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
                    wSelf.showExaminationResultVc()
                }
            } else {
                wSelf.showAlert(errorMessage: Constant.AlertContent.serverError)
            }
        }
    }
    
    @objc func showExaminationResultVc() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExaminationResultViewController") as! ExaminationResultViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func setupSocket() {
        let connection = SignalRCoreService.shared.connection
        connection.delegate = self
        connection.start()
        connection.on(method: "ReceivedLatLong") { (lat: String, long: String, eventId: String) in
            SocketMessage.shared.`init`(lat, long, eventId)
        }
    }
}

extension MainViewController : OTPAuthViewControllerDelegate {
    func didVerifyOTP() {
        Timer.scheduledTimer(timeInterval: 1.5,
                             target: self,
                             selector: #selector(self.showExaminationResultVc),
                             userInfo: nil,
                             repeats: false)
        
    }
}

extension MainViewController: HubConnectionDelegate {
    func connectionDidOpen(hubConnection: HubConnection) {
        print("Connection did Open")
        //        self.send(location: self.currentLocation, connection: hubConnection)
    }
    
    func connectionDidFailToOpen(error: Error) {
        print("Fail To Open")
    }
    
    func connectionDidClose(error: Error?) {
        print("Did Close")
    }
    
    func connectionDidReconnect() {
        print("Did Reconnect")
    }
}
