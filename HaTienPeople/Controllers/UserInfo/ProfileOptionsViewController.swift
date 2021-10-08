//
//  ProfileOptionsViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 29/09/2021.
//

import Foundation
import UIKit
import AudioToolbox
import Alamofire
import Presentr

struct MenuTableViewItem {
    var icon: String
    var title: String
}

class ProfileOptionsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBAction func logOut(_ sender: UIButton) {
        self.logOutButtonHandling()
    }
    
    let items = [MenuTableViewItem(icon: "icon-update-profile", title: "Cập nhật thông tin cá nhân"),
                 MenuTableViewItem(icon: "icon-update-password", title: "Đổi mật khẩu")
//                 MenuTableViewItem(icon: "icon-examination-result", title: "Kết quả xét nghiệm")
    ]
    let cellId = "MenuTableViewCell"
    var customerInfo: CustomerInfo? {
        didSet {
            guard let customerInfo = self.customerInfo else { return }
            self.usernameLabel.text = customerInfo.fullName
            self.phoneNumberLabel.text = customerInfo.phoneNumber
        }
    }
//    var presenter = Presentr(presentationType: .fullScreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tài khoản"
        setup(tableView: self.tableView)
        getInfo()
    }
    
    func getInfo() {
        newApiRerequest_responseString(url: Api.userInfo, method: .get, param: nil, encoding: URLEncoding.default) { (response, data, status) in
            guard let userInfo = try? JSONDecoder().decode(CustomerInfo.self, from: data) else { return }
            self.customerInfo = userInfo
        }
    }
    
    fileprivate func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70.0
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = .none
    }
    
    func showUpdatePasswordView() {
        guard let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "UpdatePasswordViewController" ) as? UpdatePasswordViewController else { return }
        present(vc, animated: true, completion: nil)
    }
    
    func showProfileViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logOutButtonHandling() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc muốn đăng xuất khỏi tài khoản này?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Có", style: .default) { _ in
            self.signOut()
        }
        let cancelAction = UIAlertAction(title: "Không", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showExaminationResultsViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExaminationResultViewController") as! ExaminationResultViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuTableViewCell
        let menutItem = items[indexPath.row]
        cell.setContent(menutItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:// cap nhat thong tin
            self.showProfileViewController()
            break
        case 1:
            self.showUpdatePasswordView()
            break
        case 2:
            self.showExaminationResultsViewController()
            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
        
    }
    
    
}
