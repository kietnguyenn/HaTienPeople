//
//  EventLogDetailsViewController.swift
//  HTEmployee
//
//  Created by Apple on 2/3/21.
//

import Foundation
import UIKit
import Alamofire
import FSPagerView
import ImageSlideshow

class EventLogDetailsViewController: BaseViewController {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var empNameLabel: UILabel!
    
    var eventLog: EventLog?
    
    var images = [UIImage]() {
        didSet {
//            pagerView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nội dung cập nhật"
        guard let log = eventLog else { return }
        self.setupContent(log)
        self.setupSlideshow()
        self.getImages(by: log.id)
        self.showBackButton()
        self.setupImageSources(with: self.images)
    }
    
    func getImages(by eventLogId: String) {
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
                        self.setupImageSources(with: self.images)
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
    
    func selectPhoto() {
        let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "ImagesSelectingViewController") as! ImagesSelectingViewController
        vc.delegate = self
        vc.imageList = self.images
        present(vc, animated: true)
    }
    
    func setupSlideshow() {
        slideshow.slideshowInterval = 3.0
        slideshow.zoomEnabled = true
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        if #available(iOS 14.0, *) {
            pageIndicator.backgroundStyle = .prominent
        } else {
            // Fallback on earlier versions
        }
        slideshow.pageIndicator = pageIndicator
//        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: -20))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventLogDetailsViewController.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
      slideshow.presentFullScreenController(from: self)
    }
    
    func setupImageSources(with images: [UIImage]) {
        let inputSources = images.map { (image) -> ImageSource in
            ImageSource(image: image)
        }
        slideshow.setImageInputs(inputSources)
    }
    
    func setupContent(_ log: EventLog) {
        if let information = log.information {
            self.contentLabel.text = information
        }
        if let taskMaster = log.taskMaster?.fullName {
            self.empNameLabel.text = "Cán bộ: \(taskMaster)"
        }
    }
}

extension EventLogDetailsViewController: ImagesSelectingViewControllerDelegate {
    func didSelect(images: [UIImage]) {
        self.images = images
    }
}
