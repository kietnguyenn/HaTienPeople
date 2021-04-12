//
//  MyDateFormatter.swift
//  HTEmployee
//
//  Created by Apple on 11/25/20.
//

import Foundation

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
