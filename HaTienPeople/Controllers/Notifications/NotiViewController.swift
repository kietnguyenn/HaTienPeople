//
//  NotiViewController.swift
//  HaTienPeople
//
//  Created by Apple on 12/18/20.
//

import Foundation
import UIKit
import Alamofire
import SwiftUI

class NotiViewController: BaseViewController {
    
    @IBOutlet weak var notiListTableView: UITableView!
    
    let cellId = "NotiCell"
    
    var notiList = [NotificationItem]() {
        didSet {
            print("NotiList.count = \(notiList.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông báo"
        self.setup(notiListTableView)
        self.showBackButton()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadNotiList("", "", "", false)
    }
    
    func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 100.0
        tableView.contentInset.top = 20.0
        tableView.contentInset.bottom = 20.0
    }
    
    fileprivate func loadNotiList(_ title: String, _ from: String, _ to: String, _ dateDescending: Bool) {
        let param : Parameters = [
//            "title": title,
//            "fromDate" : from,
//            "toDate" : to,
//            "dateDescending": true,
            "pageIndex": 1,
            "pageSize": 20
        ]
        _newApiRequestWithErrorHandling(url: Api.notificationFilter,
                                        method: .get,
                                        param: param,
                                        encoding: URLEncoding.default) { res, data, status in
            do {
                let notificationResponse = try JSONDecoder().decode(NotificationsResponse.self, from: data)
                guard let notiList = notificationResponse.data else { return }
                self.notiList = notiList
                self.notiListTableView.reloadData()
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
    }
}

// MARK: UITABLEVIEW DELEGATE & DATASOURCES
extension NotiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotiCell
        cell.selectionStyle = .none
        let notiItem = notiList[indexPath.row]
        
        if let category = notiItem.category?.categoryDescription {
            cell.typeLabel.text = category
        }

        if let title = notiItem.title {
            cell.titleLabel.text = title
        }
        if let description = notiItem.description {
            cell.contentLabel.text = description
        }
        if let date = notiItem.dateCreated {
            let date_ = configDateTimeStringOnServerToDevice(dateString: date)
            cell.dateTimeLabel.text = date_.date
        }
//        if let seen = notiItem.seen {
//            cell.unreadLabel.isHidden = seen
//        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delAction = makeDeleteContextualAction(forRowAt: indexPath)
//
//        return UISwipeActionsConfiguration(actions: [delAction])
//    }
    
    //MARK: - Contextual Actions
//    private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
//        return UIContextualAction(style: .destructive, title: "Xóa") { (action, swipeButtonView, completion) in
//            print("DELETE HERE")
//
//            completion(true)
//        }
//    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let notiCell = cell as? NotiCell else { return }
//        notiCell.collectionViewCellOffset = storeOffsets[indexPath.row] ?? 0
//        notiCell.setupCollectionViewDatasourceDelegate(datasourceDelegate: self, forRow: indexPath.row)
//    }
//
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let notiCell = cell as? NotiCell else { return }
//        storeOffsets[indexPath.row] = notiCell.collectionViewCellOffset
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = notiList[indexPath.row]
        guard let id = selectedItem.id else { return }
        self.seen(selectedItem) { seen in
            if seen {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationDetailsViewController") as! NotificationDetailsViewController
                self.navigationController?.pushViewController(vc, animated: true)
                vc.notificationId = id
            } else {
                //
            }
        }
    }
    
    // call seen APi
    func seen(_ notiItem: NotificationItem, completion: @escaping (_ didSeen: Bool ) -> Void) {
//        guard let notiId = notiItem.id else { return }
//        _newApiRequestWithErrorHandling(url: Api.notificationsForUser,
//                                        method: .put, param: ["id":notiId],
//                                        encoding: JSONEncoding.default) { response, jsonData, statusCode in
//            if 200..<300 ~= statusCode {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
        completion(true)
    }
}


// MARK: - UIDocumentInteractionControllerDelegate
extension NotiViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }
}

