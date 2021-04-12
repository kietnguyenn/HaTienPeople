//
//  AdminstrativeViolationRecords03.swift
//  HTEmployee
//
//  Created by Apple on 01/03/2021.
//
import Foundation

struct Witness: Codable {
    let fullName, job, address: String?
    
    func toDictionary() -> [String : Any]? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self),
              let jsonString = String(data: jsonData, encoding: String.Encoding.utf16),
              let dict = self.convertStringToDictionary(text: jsonString)
        else { return nil }
        return dict
    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    
    init(_ fullName: String, _ job: String, _ address: String) {
        self.fullName = fullName
        self.job = job
        self.address = address
    }
}


struct Violator: Codable {
    let fullName: String?
    let sex: String?
    let birthDate, nation, job, address: String?
    let identityCard, identityCardDate, identityCardProvider, organizationName: String?
    let organizationAddress, businessCode, gcnOrGP, gcnOrGPDate: String?
    let gcnOrGPProvider, representative: String?
    let representativeSex: String?
    let representativeTitle: String?
    
    func toJson() -> [String : Any]? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self),
              let jsonString = String(data: jsonData, encoding: String.Encoding.utf16),
              let dict = self.convertStringToDictionary(text: jsonString)
        else { return nil }
        return dict
    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Violator cant convert to Dict")
            }
        }
        return nil
    }
}

struct RecordMarker: Codable {
    let fullName, position, organization: String?
    
    func toDictionary() -> [String : Any]? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self),
              let jsonString = String(data: jsonData, encoding: String.Encoding.utf16),
              let dict = self.convertStringToDictionary(text: jsonString)
        else { return nil }
        return dict
    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    init(_ fullName: String, _ position: String, _ organization: String) {
        self.fullName = fullName
        self.position = position
        self.organization = organization
    }
}


// MARK: - BienBanViPhamHanhChinh03
struct AdminstrativeViolationRecords03: Codable {
    let title, hour, minute, date: String?
    let baseOn: String?
    let recordMakers: [RecordMaker]?
    let witnesses: [Witness]?
    let violator: Violator?
    let violation, lawAccording, regulationsAt, sufferer: String?
    let violatorComments, suffererComments, witnessesComments, request: String?
    let violatorName, explanationDirectDuration, explanationDocumentDuration, explanationReceiverName: String?
    let doneHour, doneMinute, doneDate: String?
    let pageCount, copyCount: Int?
    let violatorRejectReason: String?
    
    func toDictionary() -> [String : Any]? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self),
              let jsonString = String(data: jsonData, encoding: String.Encoding.utf16),
              let dict = self.convertStringToDictionary(text: jsonString)
        else { return nil }
        return dict
    }
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

// MARK: - RecordMaker
struct RecordMaker: Codable {
    let fullName, position, organization: String?
}

struct AdminstrativeViolationRecords03Response: Codable {
    let id: String?
    let violator, recordMaker: ViolatorClass?
    let event: _Event?
    let formType: FormType?
    let dateCreated: String?
    let formData: AdminstrativeViolationRecords03?
}

// MARK: - ViolatorClass
struct ViolatorClass: Codable {
    let id, userName, phoneNumber, fullName: String?
    let title: String?
    let email: String?
    let phoneAddress: String?
}

// MARK: - FormType
struct FormType: Codable {
    let id: Int?
    let formTypeDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case formTypeDescription = "description"
    }
}
