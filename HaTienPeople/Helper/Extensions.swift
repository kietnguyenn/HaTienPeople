//
//  Extensions.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/4/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import PhotosUI

//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

extension PHAsset {
    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 300, height: 200), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            guard let image = image else { return }
            thumbnail = image
        })
        return thumbnail
    }
}
