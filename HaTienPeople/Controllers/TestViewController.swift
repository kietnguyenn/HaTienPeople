//
//  TestViewController.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/10/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import UIKit

//class TestViewController: BaseViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//extension TestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    //This is the tap gesture added on my UIImageView.
//    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
//        //call Alert function
//        self.showAlert()
//    }
//
//    //Show alert to selected the media source type.
//    private func showAlert() {
//
//        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
//            self.getImage(fromSourceType: .camera)
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
//            self.getImage(fromSourceType: .photoLibrary)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    //get image from source type
//    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
//
//        //Check is source type available
//        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = sourceType
//            self.present(imagePickerController, animated: true, completion: nil)
//        }
//    }
//
//    //MARK:- UIImagePickerViewDelegate.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        self.dismiss(animated: true) { [weak self] in
//
//            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            //Setting image to your image view
//            self?.profileImgView.image = image
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}
