//
//  EventLogsViewController.swift
//  HTEmployee
//
//  Created by Apple on 1/25/21.
//

import Foundation
import UIKit
import Alamofire

class EventLogsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellId = "EventLogRow"
    
    var eventLogs = [EventLog]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var eventId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(tableView: tableView)
        title = "Lịch sử cập nhật sự cố"
        self.showBackButton()
        self.getEventLogs(by: eventId)
    }
    
    func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.0
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = .none
        tableView.verticalScrollIndicatorInsets.left = 20.0
        tableView.verticalScrollIndicatorInsets.right = -20.0
    }
    
    fileprivate func getEventLogs(by eventId: String) {
        requestApiResponseString(urlString: Api.eventLogsById,
                                 method: .get,
                                 params: ["eventId": eventId],
                                 encoding: URLEncoding.default) { (responseString) in
            if let jsonString = responseString.value,
                  let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventLog].self, from: jsonData)
                    self.eventLogs = array
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
            } else {
                print("no jsondata & no jsonString")
            }
        }
    }
}

extension EventLogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventLogRow
        let eventLog = eventLogs[indexPath.row]
        print(eventLog.id)
        if let taskMasterName = eventLog.taskMaster?.fullName {
            cell.usernameLabel.text = taskMasterName
        }
        
        if let content = eventLog.information, let eventLogType = eventLog.eventLogType?.description {
//            cell.informationLabel.text = eventLogType + " với nội dung: " + content
            cell.informationLabel.text = content
        }
        
        let dateTimeString = eventLog.dateTime
        let dateTime = configDateTimeStringOnServerToDevice(dateString: dateTimeString)
        cell.dateTimeLabel.text = dateTime.date + " " + dateTime.time

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(withIdentifier: "EventLogDetailsViewController") as! EventLogDetailsViewController
        let log = eventLogs[indexPath.row]
        details.eventLog = log
        self.navigationController?.pushViewController(details, animated: true)
    }
}
