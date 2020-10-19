//
//  EventListViewController.swift
//  HaTienEmployeeLast
//
//  Created by MacBook on 10/2/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EventListViewController: BaseViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var acceptedList = [EventNew]() {
        didSet {
//            eventsTableView.reloadData()
        }
    }
    var notAcceptedList = [EventNew]() {
        didSet {
//            eventsTableView.reloadData()
        }
    }
    
    var completedList = [EventNew]()
    
    let cellId = "EventCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sự cố đã đăng"
        setup(tableView: eventsTableView)
        self.segmentControl.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
        self.segmentControl.selectedSegmentIndex = 0
    }
    
    @objc func didChange(_ segment: UISegmentedControl) {
        self.eventsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getEvents()
    }
    
    func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 140.0
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = .none
        tableView.verticalScrollIndicatorInsets.left = 20.0
        tableView.verticalScrollIndicatorInsets.right = -20.0
    }
    
    func getEvents() {
        // get event posted by user
        requestApiResponseString(urlString: Api.eventPostedByUser, method: .get, encoding: JSONEncoding.default) { (responseString) in
            guard let statusCode = responseString.response?.statusCode else { return }
            print(statusCode)
            if let jsonString = responseString.value,
                  let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventNew].self, from: jsonData)
                    self.acceptedList.removeAll()
                    self.notAcceptedList.removeAll()
                    for event in array {
                        if event.status == 0 {
                            self.notAcceptedList.append(event)
                        } else if event.status == 1 {
                            self.acceptedList.append(event)
                        } else if event.status == 3 {
                            self.completedList.append(event)
                        }
                    }
                    self.eventsTableView.reloadData()
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
                self.showAlert(errorMessage: "error")
            }
        }
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.segmentControl.selectedSegmentIndex
        if selectedIndex == 0 {
            // chua tiep nhan
            return notAcceptedList.count
        } else if selectedIndex == 1  {
            // Da tiep nhan
            return acceptedList.count
        } else if selectedIndex == 2 {
            // Hoan thanh
            return completedList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventCell
        var event: EventNew
        if self.segmentControl.selectedSegmentIndex == 0 {
            event = self.notAcceptedList[indexPath.row]
        } else {
            event = self.acceptedList[indexPath.row]
        }
        cell.eventTypeLabel.text = event.eventTypeName
        cell.dateTimeLabel.text = "Ngày \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime ).date) lúc \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime ).time)"
        cell.addressLabel.text = event.address
        cell.contentLabel.text = event.decription
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        var event: EventNew
        if self.segmentControl.selectedSegmentIndex == 0 {
            event = self.notAcceptedList[indexPath.row]
        } else {
            event = self.acceptedList[indexPath.row]
        }
        vc.event = event
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Config date/time Server to device formatter
struct MyDateFormatter {
    static func convertDateTimeStringOnServerToDevice(dateString: String) -> (time: String, date: String) {
        let subTimeString = dateString.components(separatedBy: ".")
        let myDate = subTimeString[0].convertStringToDate(with: "yyyy-MM-dd'T'HH:mm:ss")
        let dateResult = myDate.convertDateToString(with: "dd-MM-yyyy")
        let timeResult = myDate.convertDateToString(with: "HH:mm")
        
        return (timeResult, dateResult)
    }
}

// MARK: Convert Date to String
extension Date {
    
    func convertDateToString(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

// MARK: Convert String to date
extension String {
    
    func convertStringToDate(with format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "vi_VN")
//        dateFormatter.timeZone = TimeZone.current
        guard let result = dateFormatter.date(from: self) else { return Date() }
        return result
    }
}

