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
        
    }
    
    @IBAction func signOut(_:UIButton) {
        let signInVc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let transitionOption: UIWindow.TransitionOptions = .init(direction: .toTop, style: .easeInOut)
        UserDefaults.standard.setValue(nil, forKey: "CurrentUser")
        window.setRootViewController(signInVc, options: transitionOption)
    }
    
    var presenter = Presentr(presentationType: .bottomHalf)
    
    var customerInfo: CustomerInfo? {
        didSet {
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tài khoản"
        self.setupUI()
        self.getInfo()
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
