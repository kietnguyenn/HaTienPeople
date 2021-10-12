//
//  NotificationDetailsViewController.swift
//  HTEmployee
//
//  Created by Apple on 1/24/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class NotificationDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var notification: NotificationItem? {
        didSet {
            guard let files = notification?.files else { return }
            self.files = files
        }
    }
    
    let cellId = "FileCell"
    
    var files = [File]()
    
    var destinationURL: URL? {
        didSet {
            DispatchQueue.main.async {
                guard let destination = self.destinationURL else { return }
                self.showFileWithPath(filePathURL: destination)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nội dung thông báo"
        self.setup(tableView)
        self.showBackButton()
        guard let noti = self.notification else { return }
        self.updateUI(noti)
    }
    
    func updateUI(_ notiItem: NotificationItem) {
            if let title = notiItem.title {
                self.titleLabel.text = "Tiêu đề: " + title
            } else {
                self.titleLabel.text = "Không có tiêu đề"
            }
            if let content = notiItem.description {
                self.contentLabel.text = content
            }
            if let type = notiItem.category?.categoryDescription {
                self.typeLabel.text = type
            }
        if let date = notiItem.dateCreated {
            let date_ = configDateTimeStringOnServerToDevice(dateString: date)
            self.dateLabel.text = date_.date + " lúc " + date_.time
        }
    }
    
    func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40.0
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func downloadFileWithAlamofire(with file: File) {
        self.showHUD()
        guard let fileId = file.id, let fileName = file.fileName else { return }
        var tokenHeader: HTTPHeaders?
        if let _token = Account.current?.access_token {
            tokenHeader = ["Authorization" : "Bearer \(_token)"]
        } else {
            tokenHeader = nil
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        Alamofire.download(URL(string: Api.files + "/\(fileId)")!,
                           method: .get,
                           parameters: nil,
                           encoding: URLEncoding.default,
                           headers: tokenHeader,
                           to: destination)
            .responseData { (response) in
                if let destinationUrl = response.destinationURL {
                    print("destinationUrl \(destinationUrl.absoluteURL)")
                    self.destinationURL = destinationUrl
                }
            }
            .downloadProgress { (progress) in
                print("Progress: ", progress.fractionCompleted*100)
            }
    }
    
    //Show Downloaded File
    func showFileWithPath(filePathURL: URL) {
        let viewer = UIDocumentInteractionController(url: filePathURL)
        viewer.delegate = self
        viewer.presentPreview(animated: true)
        self.hideHUD()
    }
}

extension NotificationDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FileCell
        let file = self.files[indexPath.row]
        cell.updateUI(index: indexPath.row, item: file)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let file = self.files[indexPath.row]
        downloadFileWithAlamofire(with: file)
    }
}

extension NotificationDetailsViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }
}
