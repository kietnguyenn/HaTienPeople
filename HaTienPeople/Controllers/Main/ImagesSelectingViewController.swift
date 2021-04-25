//
//  ImagesSelectingViewController.swift
//  HaTienEmployeeLast
//
//  Created by MacBook on 10/2/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import ImagePicker

protocol ImagesSelectingViewControllerDelegate: class {
    func didSelect(images: [UIImage])
}

class ImagesSelectingViewController: BaseViewController, PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    @IBOutlet weak var imagesTableView: UITableView!
    @IBAction func addButtonTapped(_ button: UIButton) {
        let configuration = Configuration()
        configuration.doneButtonTitle = "Xong"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        configuration.cancelButtonTitle = "Huỷ"

        let imagePicker = ImagePickerController(configuration: configuration)

        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ button: UIButton) {
        delegate.didSelect(images: self.imageList)
        self.dismiss(animated: true, completion: nil)
    }
    
    var imageList = [UIImage]() {
        didSet {
            print(imageList.count)
        }
    }
    let cellId = "ImageCell"
    var imagePicker = UIImagePickerController()
    weak var delegate:  ImagesSelectingViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(imagesTableView)
    }
    
    fileprivate func setup(_ tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.rowHeight = 120.0
        tv.separatorStyle = .none
        tv.register(UINib(nibName: cellId, bundle: Bundle.main), forCellReuseIdentifier: cellId)
    }
}

// MARK: - UItableview delegate & datasource
extension ImagesSelectingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ImageCell
        let image = imageList[indexPath.row]
        cell.uploadImageView.image = image
        cell.imageNameLabel.text = randomString(length: 8)
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension ImagesSelectingViewController: ImageCellDelegate {
    func didDelete(index: Int) {
        deleteImage(at: index)
    }

    func deleteImage(at index: Int) {
        imagesTableView.beginUpdates()
        self.imageList.remove(at: index)
        self.imagesTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        self.imagesTableView.reloadData()
        imagesTableView.endUpdates()
    }
}


extension ImagesSelectingViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("done")
        self.imageList = self.imageList + images
        self.imagesTableView.reloadData()
        imagePicker.dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("canceled")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

public func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
