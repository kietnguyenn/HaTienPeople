//
//  NotiViewController.swift
//  HaTienPeople
//
//  Created by Apple on 12/18/20.
//

import Foundation
import UIKit
import Alamofire
import InfiniteLayout

class NotiViewController: BaseViewController {
    
    @IBOutlet weak var notiListTableView: UITableView!
    
    let cellId = "NotiCell"
    
    var notiList = Notification() {
        didSet {
            print("NotiList.count = \(notiList.count)")
        }
    }
    
    var storeOffsets = [Int: CGFloat]()
    
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
        self.title = "Thông báo"
        self.setup(notiListTableView)
        self.loadNotiList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
    }
    
    fileprivate func loadNotiList() {
        newApiRerequest_responseString(url: Api.notifications,
                                       method: .get,
                                       param: nil,
                                       encoding: URLEncoding.default) { (res, data, status) in
            guard let notiList = try? JSONDecoder().decode(Notification.self, from: data) else { return }
            self.notiList = notiList
            self.notiListTableView.reloadData()
        }
    }
    
    //Show Downloaded File
    func showFileWithPath(filePathURL: URL) {
        let viewer = UIDocumentInteractionController(url: filePathURL)
        viewer.delegate = self
        viewer.presentPreview(animated: true)
    }
    
    func downloadFileWithAlamofire(with file: File) {
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


}

// MARK: UITABLEVIEW DELEGATE & DATASOURCES
extension NotiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotiCell
        cell.selectionStyle = .none
        cell.fileLabel.text = "Tệp đính kèm: "
        let notiItem = notiList[indexPath.row]
        if let title = notiItem.title {
            cell.titleLabel.text = title
        }
        if let description = notiItem.category?.categoryDescription?.rawValue {
            cell.contentLabel.text = "Nội dung: " + description
        }
        if let files = notiItem.files {
            cell.items = files
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let notiCell = cell as? NotiCell else { return }
        notiCell.collectionViewCellOffset = storeOffsets[indexPath.row] ?? 0
        notiCell.setupCollectionViewDatasourceDelegate(datasourceDelegate: self, forRow: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let notiCell = cell as? NotiCell else { return }
        storeOffsets[indexPath.row] = notiCell.collectionViewCellOffset
    }
}

// MARK: UICollectionView Delegate & Datasource
extension NotiViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! FileCell
        guard let files = notiList[collectionView.tag].files else { return cell }
        if files.count > 0 {
            let file = files[indexPath.item]
            cell.updateUI(index: indexPath.item, item: file)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let files = notiList[collectionView.tag].files else { return 0 }
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFile = self.getSelectedFile(collectionView.tag, indexPath.item)
        self.downloadFileWithAlamofire(with: selectedFile)
    }
    
    fileprivate func getSelectedFile(_ tag: Int, _ index: Int) -> File {
        guard let files = notiList[tag].files else { return File(id: nil, fileName: nil) }
        return files[index]
    }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension NotiViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }
}
