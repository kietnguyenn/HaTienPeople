//
//  ExaminationResult.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import Foundation


// MARK: - Datum
struct ExaminationResult: Codable {
    let id: String?
    let profiles: [Profile]?
    let assigmentUnit: Unit?
    let assignmentDate, assigmentSource: String?
    let takenUnit: Unit?
    let dateTaken: String?
    let isGroup: Bool?
    let code, examinationType: String?
    let sampleCount: Int?
    let testTechnique, feeType, diseaseSample, samplingPlace: String?
    let executedUnit: Unit?
    let resultDate, result: String?
    let cTE: Double?
    let cTN, cTRDRp: String?
    let orF1Ab: Double?
    let dateTesting: String?
    let lastTransport: LastTransport?
    let importantValue: Int?
    let dateCreated, dateUpdated: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id, profiles, assigmentUnit, assignmentDate, assigmentSource, takenUnit, dateTaken, isGroup, code, examinationType, sampleCount, testTechnique, feeType, diseaseSample, samplingPlace, executedUnit, resultDate, result
        case cTE = "cT_E"
        case cTN = "cT_N"
        case cTRDRp = "cT_RdRp"
        case orF1Ab = "orF1ab"
        case dateTesting, lastTransport, importantValue, dateCreated, dateUpdated, location
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.unitTask(with: url) { unit, response, error in
//     if let unit = unit {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Unit
struct Unit: Codable {
    let id: String?
    let name: String?
    let samplingFunctionType: String?
    let isCollector, isReceiver, isTester: Bool?
    let province: String?
    let district, ward: String?
    let unitType: UnitType?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.unitTypeTask(with: url) { unitType, response, error in
//     if let unitType = unitType {
//       ...
//     }
//   }
//   task.resume()

// MARK: - UnitType
struct UnitType: Codable {
    let code: String?
    let name: String?
}

// MARK: - LastTransport
struct LastTransport: Codable {
    let fromUnit, toUnit, receivedUnit: Unit?
    let createdTime, sentDate, receivedDate: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.profileTask(with: url) { profile, response, error in
//     if let profile = profile {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Profile
struct Profile: Codable {
    let profileID: Int?
    let name: String?
    let gender: Int?
    let dateOfBirth, phone: String?
    let cccd: String?
    let cmnd, houseNumber: String?
    let province: String?
    let district: String?
    let ward: String?
    let quarter, quarterGroup, houseAddressCombination, quarterGroupAddressCombination: String?
    let reason: String?
    let relationObject: JSONNull?

    enum CodingKeys: String, CodingKey {
        case profileID = "profileId"
        case name, gender, dateOfBirth, phone, cccd, cmnd, houseNumber, province, district, ward, quarter, quarterGroup, houseAddressCombination, quarterGroupAddressCombination, reason, relationObject
    }
}

