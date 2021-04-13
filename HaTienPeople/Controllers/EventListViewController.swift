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
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            let font = UIFont.boldSystemFont(ofSize: 11)
            self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
    
    var acceptedList = [Event]() {
        didSet {
//            eventsTableView.reloadData()
            print("Accepted list = \(acceptedList.count)")

        }
    }
    var newEventList = [Event]() {
        didSet {
//            eventsTableView.reloadData()
            print("new event List = \(newEventList.count)")

        }
    }
    
    var completedList = [Event]() {
        didSet {
            print("Completed list = \(completedList.count)")
        }
    }
    
    var waitForHandlingList = [Event]() {
        didSet {
            print("wait for handling list = \(waitForHandlingList.count)")
        }
    }
    
    let cellId = "EventCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sự cố đã đăng"
        setup(tableView: eventsTableView)
        self.segmentControl.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
        self.segmentControl.selectedSegmentIndex = 0
        SocketMessage.shared.delegate = self
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
                    let array = try JSONDecoder().decode([Event].self, from: jsonData)
                    self.acceptedList.removeAll()
                    self.newEventList.removeAll()
                    self.completedList.removeAll()
                    self.waitForHandlingList.removeAll()
                    for event in array {
                        if event.status == EventStatusId.newEvent.rawValue
                        { // 0
                            self.newEventList.append(event)
                        }
                        else if event.status == EventStatusId.handling.rawValue
                        { // 1
                            self.acceptedList.append(event)
                        }
                        else if event.status == EventStatusId.completed.rawValue
                        { // 3
                            self.completedList.append(event)
                        }
                        else if event.status == EventStatusId.waitingForHandling.rawValue
                        { // 7
                            self.waitForHandlingList.append(event)
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
        if selectedIndex == 1 {
            // chua tiep nhan
            return waitForHandlingList.count
        } else if selectedIndex == 2 {
            // Da tiep nhan
            return acceptedList.count
        } else if selectedIndex == 3 {
            // Hoan thanh
            return completedList.count
        } else if selectedIndex == 0 {
            return newEventList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventCell
        guard let event = filterEventList(with: indexPath) else { return UITableViewCell() }
        cell.eventTypeLabel.text = event.eventTypeName
        cell.dateTimeLabel.text = "Ngày \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime! ).date) lúc \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime! ).time)"
        cell.addressLabel.text = event.address
        cell.contentLabel.text = event.decription
        if event.status! == EventStatusId.handling.rawValue {
            if SocketMessage.shared.eventId == event.id {
                cell.isGoingImage.isHidden = false
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        guard let _event = filterEventList(with: indexPath) else { return }
        vc.event = _event
        vc.delegate = self
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    fileprivate func filterEventList(with indexPath: IndexPath) -> Event? {
        var event: Event?
        switch segmentControl.selectedSegmentIndex {
        case 0:
            event = self.newEventList[indexPath.row]
            break
        case 1:
            event = self.waitForHandlingList[indexPath.row]
            break
        case 2:
            event = self.acceptedList[indexPath.row]
            break
        case 3:
            event = self.completedList[indexPath.row]
            break
        default:
            break
        }
        return event
    }
}

extension EventListViewController: EventDetailsViewControllerDelegate {
    func didAddEventInProcess() {
        
    }
    
    func didPostEventLog() {
        
    }
    
    func didCancel() {
        
    }
    
    func didHandle() {
        
    }
    
    
}

extension EventListViewController: SocketMessageDelegate {
    func didReceiveMessage() {
        self.eventsTableView.reloadData()
    }
}
