//
//  ExaminationResultViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct ResultCellItem {
    var profile : Profile?
    var result : String?
    var executedUnit : String?
    var resultDate: String?
    var resultTime: String?
    var examinationResultModel : ExaminationResult?
    init(_ examinationResult: ExaminationResult, _ currentUserPhone: String) {
        self.examinationResultModel = examinationResult
        if let profiles = examinationResult.profiles,
           let result = examinationResult.result,
           let executedUnitName = examinationResult.executedUnit?.name,
           let resultDateString = examinationResult.resultDate {
            for _profile in profiles {
                if let phone = _profile.phone {
                    if phone == currentUserPhone {
                        self.profile = _profile
                        break
                    }
                }
            }
            self.result = result
            self.executedUnit = executedUnitName
            let dateTime = configDateTimeStringOnServerToDevice(dateString: resultDateString)
            self.resultDate = dateTime.date
            self.resultTime = dateTime.time
        }
    }
}

class ExaminationResultViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var results = [ExaminationResult]()
    
    var cellItems = [ResultCellItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    let cellId = "ExaminationResultCell"
    var currentUserPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        title = "Y tế"
        self.setup(tableView)
        guard let phone = UserInfo.current?.phoneNumber else { return }
        self.currentUserPhone = phone
        self.getExaminationResults()
        self.showBackButton()
    }
    
    fileprivate func setup(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 132
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
    }
    
    func getExaminationResults() {
        newApiRerequest_responseString(url: Api.examinationResult,
                                       method: .post,
                                       param: ["phoneNumber":self.currentUserPhone],
                                       encoding: JSONEncoding.default)
        { (response, data, status) in
            guard let resutls = try? JSONDecoder().decode([ExaminationResult].self, from: data) else { return }
            for result in resutls {
                guard let profiles = result.profiles else { return }
                for profile in profiles {
                    guard let phone = profile.phone else { return }
                    if phone == self.currentUserPhone {
                        self.results.append(result)
                    }
                }
            }
            // Make cell Item
            self.cellItems = self.results.map({ result in
                return ResultCellItem(result, self.currentUserPhone)
            })
        }
    }
}

extension ExaminationResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExaminationResultCell
        let item = cellItems[indexPath.row]
        cell.setCellContent(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedItem = self.cellItems[indexPath.row]
        // show detail
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExaminationResultDetailViewController") as! ExaminationResultDetailViewController
        vc.resultItem = selectedItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
