//
//  EventDetailsViewController.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/8/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Floaty
import FSPagerView

enum Directions: String {
    case invitation = "Mời"
    case forwarding = "Chuyển"
}

protocol EventDetailsViewControllerDelegate: class {
    
//    func didAccept()
    
    func didAddEventInProcess()
    
    func didPostEventLog()
    
    func didCancel()
    
    func didHandle()
}

class EventDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView : UITableView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var acceptedEmployeeLabel: UILabel!
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
        
    var delegate: EventDetailsViewControllerDelegate!
    
    var eventLogs = [EventLog]() {
        didSet {
            print("event logs = \(eventLogs.count)")
        }
    }
        
    var event: Event? {
        didSet {
            print("eventId: ", event!.id!)
        }
    }
    
    var images = [UIImage]() {
        didSet {
            print("Images: \(images.count)")
//            self.setup(scrollView: self.scrollView)
            self.pagerView.reloadData()
        }
    }
    
    var empList = [Owner]() {
        didSet {
            // setup emp List
            print("Employees: ", empList.count)
            if empList.count == 0 {
                self.acceptedEmployeeLabel.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    var existingRecords = [AdminstrativeViolationRecords03Response]() {
        didSet {
            print("exsiting records = \(existingRecords.count)" )
            if existingRecords.count > 0 {
                self.setupFloatingButton()
            }
        }
    }
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let cellId = "EventHandlingUserCell"

    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chi tiết"
        self.setup(self.pagerView)
        self.setup(tableView: self.tableView)
        self.showDismissButton(title: "Xong")
        self.showRightBarButtonWithImage(image: "history", action: #selector(showEventLogs), isEnable: true)
        self.loadData()
    }
    
    // MARK: Setup pager View
    func setup(_ pagerView: FSPagerView) {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval = 3.0
        pagerView.decelerationDistance = 2
        pagerView.itemSize = CGSize(width: 340, height: 200)
        pagerView.interitemSpacing = 10
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    @objc func showEventLogs() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLogsViewController") as? EventLogsViewController else { return }
        vc.eventId = (self.event?.id)!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    override func dismissButtonTapped(_ button: UIBarButtonItem) {
        self.delegate.didPostEventLog()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
        guard let eventId = self.event?.id else { return }
        getEventLogs(eventId: eventId)
        self.setupFloatingButton()
    }
    
//    func setup(scrollView: UIScrollView) {
//        scrollView.delegate = self
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.alwaysBounceVertical = false
//        scrollView.isPagingEnabled = true
//
//        for index in 0..<images.count {
//            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
//            frame.size = scrollView.frame.size
//
//            let imageView = UIImageView(frame: frame)
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = images[index]
//            self.scrollView.addSubview(imageView)
//        }
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
//        self.pageControl.numberOfPages = images.count
//    }
    
    func setupDetailContent() {
        guard let event = self.event,
              let eventId = event.id else { return }
        
        self.getHandlingEmployee(id: eventId)

        eventTypeLabel.text = event.eventTypeName
        
        // status
        if let status = event.status {
            self.configStatusLabel(statusId: status, statusLabel: self.statusLabel)
        }
        
        if let dateTime = event.dateTime {
            self.dateTimeLabel.text = self.generateToDateTimeString(dateTime)
        }
        
        if let address = event.address {
            addressLabel.text = "Tại " + address
        }
        if let description = event.decription {
            contentLabel.text = "Nội dung: " + description
        }

        if eventLogs.count > 0 {
            guard let eventLog = eventLogs.last else { return }
            if let user = eventLog.user {
                postedByUserLabel.text = "Đăng bởi người dùng \(user.fullName!)"
            }
        }
    }
    
    func configStatusLabel(statusId: Int, statusLabel: UILabel) {

        switch statusId {
        case 1:
            // đang xử lý
            statusLabel.text = " ●  Đang xử lý  "
            statusLabel.backgroundColor = .systemYellow
        case 2:
            // da den noi
            statusLabel.text = " ●  Đã đến nơi xử lý  "
            statusLabel.backgroundColor = .orange

        case 3:
            // hoan thanh
            statusLabel.text = " ●  Đã hoàn thành  "
            statusLabel.backgroundColor = .systemBlue

        case 4:
            // huy yeu cau
            statusLabel.text = " ●  Đã hủy  "
            statusLabel.backgroundColor = .lightGray
            
        case 6:
            // bat dau di
            statusLabel.text = " ●  Đang di chuyển  "
            statusLabel.backgroundColor = .systemGreen
            
        case 0:
            // Chờ tiếp Nhận
            statusLabel.text = " ●  Chờ tiếp nhận  "
            statusLabel.backgroundColor = .systemRed
            
        case 7:
            statusLabel.text = " ●  Chờ xử lý  "
            statusLabel.backgroundColor = .cyan

        default:
            break
        }
    }
    
    func generateToDateTimeString(_ rawString: String, format: Int = 1) -> String {
        switch format {
        case 1:
            return "Ngày \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: rawString ).date) lúc \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: rawString ).time)"
        case 2:
            return "\(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: rawString ).date) \n\(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: rawString ).time)"

        default:
            return ""
        }
    }
    
    func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
//        tableView.register(EventHandlingUserCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: cellId, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func getEventLogs(eventId: String) {
        requestApiResponseString(urlString: Api.eventLogsById,
                                 method: .get,
                                 params: ["eventId": eventId],
                                 encoding: URLEncoding.default) { (responseString) in
            if let jsonString = responseString.value,
                  let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventLog].self, from: jsonData)
                    self.eventLogs = array
                    if self.eventLogs.count > 0 {
//                        self.event = eventLogs[0].event
                        let eventLogId = array.last!.id
                        self.getImages(eventLogId: eventLogId)
                        print("last eventlog id : \(eventLogId)")
                        self.setupDetailContent()
                        self.getExistedRecords()
                    }
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
    
    // Floaty
    func setupFloatingButton() {
        let floaty = Floaty()
        floaty.paddingY = 40
        guard let image = UIImage(named: "handle")?.resizeImage(targetSize: CGSize(width: 40, height: 40)) else { return }
        floaty.buttonImage = image
        floaty.buttonColor = .systemBlue
        guard let event = self.event else { return }

        let showEmpLocation = FloatyItem()
        showEmpLocation.makeFloatingItem(imageName: "handle", color: .systemGreen, title: "Theo dõi cán bộ") { (floaty) in
            self.showEventLocation()
        }
        
        if event.status! == EventStatusId.handling.rawValue {
            if SocketMessage.shared.eventId == event.id {
                floaty.addItem(item: showEmpLocation)
            }
        }
        self.view.addSubview(floaty)
    }
    
    /// Get Images
    func getImages(eventLogId: String) {
        requestApiResponseString(urlString: ApiDomain.new + "\(eventLogId)/Files", method: .get, encoding: URLEncoding.queryString) { (responseString) in
            if let jsonString = responseString.value,
                let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventLogFile].self, from: jsonData)
                    if array.count > 0 {
                        self.images.removeAll()
                        for file in array {
                            let base64 = file.file
                            let dataDecoded: Data  = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0))!
                            guard let uiimage: UIImage = UIImage(data: dataDecoded) else { return }
                            self.images.append(uiimage)
                        }
                    } else {
                        print("Images: ", array.count)
                    }
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
                
            }
        }
    }
    
    // MARK: - Show directions
    fileprivate func showEventLocation() {
        // present direction map view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectionMapViewController") as! EmployeeLocationViewController
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        guard let event = self.event,
              let lat = event.latitude,
              let lng = event.longitude
        else { return }
        vc.eventLocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
        self.present(nav, animated: true)
    }
        
    // MARK:  Get event Handling by id
    func getHandlingEmployee(id: String) {
        _newApiRequestWithErrorHandling(url: Api.eventsRelatedUser + "/\(id)",
                                        method: .get,
                                        encoding: URLEncoding.default) { (res, data, status) in
            do {
                let model = try JSONDecoder().decode(EventHandlingUsers.self, from: data)
                guard let empList = model.employees else { return }
                self.empList = empList
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
    
    // MARK:  get existed records
    func getExistedRecords() {
        guard let eventId = self.event?.id else { return }
        _newApiRequestWithErrorHandling(url: Api.eventFormFilter + "/\(eventId)?formTypeId=6", method: .get) { (response, data, status) in
            do {
                let model = try JSONDecoder().decode([AdminstrativeViolationRecords03Response].self, from: data)
                self.existingRecords = model
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

// MARK: - FSpager view delegate & datasource
extension EventDetailsViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        cell.imageView?.contentMode = .scaleAspectFit
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        vc.image = self.images[index]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventHandlingUserCell
        let currentValue = self.empList[indexPath.row]
        cell.updateUI(currentValue, index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension EventDetailsViewController : EventHandlingUserCellDelegate {
    func didTapCallButton(with index: Int) {
        
    }
}



extension FloatyItem {
    func makeFloatingItem(imageName: String, color: UIColor, title: String, _ handler: ((FloatyItem) -> Void)? = nil) {
        self.buttonColor = color
        self.handler = handler
        self.title = title
        guard let icon = UIImage(named: imageName) else { return }
        self.icon = icon
    }
}
