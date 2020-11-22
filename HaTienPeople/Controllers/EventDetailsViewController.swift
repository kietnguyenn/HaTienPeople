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

class EventDetailsViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
//    @IBOutlet weak var statusView: UIView!
    
    @IBAction func locationButtonTapped(_:UIButton) {
        // present direction map view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DirectionMapViewController") as! DirectionMapViewController
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        guard let event = self.event,
              let lat = Double(event.latitude),
              let lng = Double(event.longitude)
        else { return }
        vc.employeeLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.present(nav, animated: true)
    }
    
    var images = [UIImage]() {
        didSet {
            print("Images: \(images.count)")
        }
    }
    
    var event: EventNew?
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var eventLogs = [EventLog]() {
        didSet {
            self.setupDetailContent(eventLog: self.eventLogs[0])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chi tiết"
        setup(scrollView: scrollView)
        guard let event = self.event else { return }
        getEventLogs(eventId: event.id)
        scrollView.delegate = self
        self.showBackButton()
    }
    
    func setupDetailContent(eventLog: EventLog) {
        guard let event = self.event else { return }
        eventTypeLabel.text = event.eventTypeName
        if event.status == 0 {
            statusLabel.text = "Chờ xử lí"
            employeeLabel.text = "Cán bộ: Không"
            statusLabel.backgroundColor = .lightGray
        } else if event.status == 1 {
            employeeLabel.text = "Không"
            statusLabel.text = "Đang xử lí"
            statusLabel.backgroundColor = .orange
        } else if event.status == 3 {
            employeeLabel.text = "Không"
            statusLabel.text = "Đã hoàn thành"
            statusLabel.backgroundColor = .green
        }
        dateTimeLabel.text = "Ngày \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime ).date) lúc \(MyDateFormatter.convertDateTimeStringOnServerToDevice(dateString: event.dateTime ).time)"
        addressLabel.text = "Tại " + event.address
        contentLabel.text = "Nội dung: " + eventLog.information
        
    }
    
    func setup(scrollView: UIScrollView) {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.isPagingEnabled = true
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[index]
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        self.pageControl.numberOfPages = images.count
    }
    
    fileprivate func getEventLogs(eventId: String) {
        requestApiResponseString(urlString: "https://apindashboard.vkhealth.vn/api/EventsLog/GetByEventId?eventId=\(eventId)", method: .get, encoding: URLEncoding.default) { (responseString) in
            if let jsonString = responseString.value,
                  let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventLog].self, from: jsonData)
                    self.eventLogs = array
                    self.getImages(eventLogId: array[0].id)
                    print(array[0].id)
                    
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
    
    func getImages(eventLogId: String) {
        requestApiResponseString(urlString: "https://apindashboard.vkhealth.vn/\(eventLogId)/Files", method: .get, encoding: URLEncoding.default) { (responseString) in
            if let jsonString = responseString.value,
                let jsonData = jsonString.data(using: .utf8) {
                do {
                    let array = try JSONDecoder().decode([EventLogFile].self, from: jsonData)
                    if array.count > 0 {
                        self.images.removeAll()
                        for file in array {
                            let base64 = file.file
                            let dataDecoded: Data  = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0))!
                            let uiimage: UIImage = UIImage(data: dataDecoded)!
                            self.images.append(uiimage)
                        }
                        self.setup(scrollView: self.scrollView)
                    } else {
                        
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
}

extension EventDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
            pageControl.currentPage = Int(page)
        }
}


