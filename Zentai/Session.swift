//
//  Session.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/7/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Ax
import Alamofire
import SwiftyJSON

struct AddressInfo {
  var address: String? = nil
  var city: String? = nil
  var state: String? = nil
  var zip: String? = nil
  var latitude: Double? = nil
  var longitude: Double? = nil
}

enum CellState: String {
  case invitedNotAccepted = "invitedNotAccepted"
  case acceptedAndnotCompleted = "acceptedAndnotCompleted"
  // cancelled
  case completedNotPaid = "completedNotPaid"
  case completedAndPaid = "completedAndPaid"
  //  case client
  
  case checkedIn = "checkedIn"
  case cancelledByUser = "cancelledByUser"
  case cancelledByPractitioner = "cancelledByPractitioner"
}

struct Session {
  var id: String?
  var practitionerGender: String
  var oilAllergy: String?
  var anyPets: String
  
  var address: String
  var apartment: String
  var city: String
  var state: String
  var zip: String
  
  var cost: Double
  
  var status: String
  
  var chargeId: String?
  
  var parkingInstructions: String?
  
  var firstAvailabilityDate: Date
  var firstAvailabilityStart: Date
  var firstAvailabilityEnd: Date
  
  var secondAvailabilityDate: Date?
  var secondAvailabilityStart: Date?
  var secondAvailabilityEnd: Date?
  
  var thirdAvailabilityDate: Date?
  var thirdAvailabilityStart: Date?
  var thirdAvailabilityEnd: Date?
  
  var selectedDate: Date?
  var selectedStart: Date?
  var selectedEnd: Date?
  
  let clientName: String
  let clientId: String
  let practitionerName: String?
  let assignedTo: String?
  
  var location: (latitude: Double, longitude: Double)?
}

extension Session {
  
  func getCompleteAddress() -> String {
    let apartment = self.apartment.trimmingCharacters(in: CharacterSet.whitespaces)
    var completeAddress = ""
    
    if apartment.isEmpty {
      completeAddress = "\(address)\n\(city), \(state) \(zip)"
    } else {
      completeAddress = "\(address), APT \(apartment)\n\(city), \(state) \(zip)"
    }
    
    return completeAddress
  }
  
  init?(json: [String: Any]?) {
    guard
      let json = json,
      let id = json["id"] as? String,
      let practitionerGender = json["practitionerGender"] as? String,
      let oilAllergy = json["oilAllergy"] as? String,
      let anyPets = json["anyPets"] as? String,
      let address = json["address"] as? String,
      let city = json["city"] as? String,
      let state = json["state"] as? String,
      let zip = json["zip"] as? String,
      let firstAvailabilityDate = json["firstAvailabilityDate"] as? Double,
      let firstAvailabilityStart = json["firstAvailabilityStart"] as? Double,
      let firstAvailabilityEnd = json["firstAvailabilityEnd"] as? Double,
      let cost = json["cost"] as? Double,
      let status = json["status"] as? String,
      let clientName = json["clientName"] as? String,
      let clientId = json["userId"] as? String
      else {
        return nil
    }
    
    
    self.parkingInstructions = json["parkingInstructions"] as? String
    
    print("weh \(self.parkingInstructions)")
    
    self.firstAvailabilityEnd = Date(timeIntervalSince1970: firstAvailabilityEnd)
    self.firstAvailabilityDate = Date(timeIntervalSince1970: firstAvailabilityDate)
    self.firstAvailabilityStart = Date(timeIntervalSince1970: firstAvailabilityStart)
    
    let latitude = json["latitude"] as? Double
    let longitude = json["longitude"] as? Double
    
    let secondAvailabilityDate = json["secondAvailabilityDate"] as? Double
    let secondAvailabilityStart = json["secondAvailabilityStart"] as? Double
    let secondAvailabilityEnd = json["secondAvailabilityEnd"] as? Double
    
    let thirdAvailabilityDate = json["thirdAvailabilityDate"] as? Double
    let thirdAvailabilityStart = json["thirdAvailabilityStart"] as? Double
    let thirdAvailabilityEnd = json["thirdAvailabilityEnd"] as? Double
    
    let practitionerName = json["practitionerName"] as? String
    let assignedTo = json["assignedTo"] as? String
    
    self.chargeId = json["chargeId"] as? String
    
    if
      let latitude = latitude,
      let longitude = longitude {
      self.location = (latitude, longitude)
    }
    
    self.id = id
    self.practitionerGender = practitionerGender
    self.oilAllergy = oilAllergy
    self.anyPets = anyPets
    
    self.address = address
    self.apartment = json["apartment"] as? String ?? ""
    self.city = city
    self.state = state
    self.zip = zip
    
    self.status = status
    
    self.cost = cost
    
    self.practitionerName = practitionerName
    self.clientName = clientName
    self.assignedTo = assignedTo
    self.clientId = clientId
    
    if
      let selectedDate = json["selectedDate"] as? Double,
      let selectedStart = json["selectedStartTime"] as? Double,
      let selectedEnd = json["selectedEndTime"] as? Double {
      self.selectedDate = Date(timeIntervalSince1970: selectedDate)
      self.selectedStart = Date(timeIntervalSince1970: selectedStart)
      self.selectedEnd = Date(timeIntervalSince1970: selectedEnd)
    }
    
    if
      let secondAvailabilityEnd = secondAvailabilityEnd,
      let secondAvailabilityStart = secondAvailabilityStart,
      let secondAvailabilityDate = secondAvailabilityDate
    {
      self.secondAvailabilityEnd = Date(timeIntervalSince1970: secondAvailabilityEnd)
      self.secondAvailabilityDate = Date(timeIntervalSince1970: secondAvailabilityDate)
      self.secondAvailabilityStart = Date(timeIntervalSince1970: secondAvailabilityStart)
    }
    
    if
      let thirdAvailabilityDate = thirdAvailabilityDate,
      let thirdAvailabilityStart = thirdAvailabilityStart,
      let thirdAvailabilityEnd = thirdAvailabilityEnd
    {
      self.thirdAvailabilityDate = Date(timeIntervalSince1970: thirdAvailabilityDate)
      self.thirdAvailabilityEnd = Date(timeIntervalSince1970: thirdAvailabilityEnd)
      self.thirdAvailabilityStart = Date(timeIntervalSince1970: thirdAvailabilityStart)
    }
  }
  
  init() {
    practitionerGender = ""
    anyPets = ""
    
    address = ""
    apartment = ""
    city = ""
    state = ""
    zip = ""
    
    assignedTo = nil
    practitionerName = nil
    clientName = ""
    clientId = ""
    
    status = CellState.invitedNotAccepted.rawValue
    
    firstAvailabilityEnd = Date()
    firstAvailabilityDate = Date()
    firstAvailabilityStart = Date()
    
    cost = 0
  }
  
  func toJSON() -> [String: Any] {
    var dict = [String:Any]()
    
    dict["practitionerGender"] = practitionerGender
    dict["oilAllergy"] = oilAllergy ?? "N"
    dict["anyPets"] = anyPets
    dict["address"] = address
    dict["apartment"] = apartment
    dict["city"] = city
    dict["state"] = state
    dict["zip"] = zip
    
    dict["cost"] = cost
    
    dict["firstAvailabilityDate"] = firstAvailabilityDate.timeIntervalSince1970
    dict["firstAvailabilityStart"] = firstAvailabilityStart.timeIntervalSince1970
    dict["firstAvailabilityEnd"] = firstAvailabilityEnd.timeIntervalSince1970
    
    dict["parkingInstructions"] = parkingInstructions ?? " "
    
    if
      let secondAvailabilityDate = secondAvailabilityDate,
      let secondAvailabilityStart = secondAvailabilityStart,
      let secondAvailabilityEnd = secondAvailabilityEnd
    {
      dict["secondAvailabilityDate"] = secondAvailabilityDate.timeIntervalSince1970
      dict["secondAvailabilityStart"] = secondAvailabilityStart.timeIntervalSince1970
      dict["secondAvailabilityEnd"] = secondAvailabilityEnd.timeIntervalSince1970
    }
    
    if
      let thirdAvailabilityDate = thirdAvailabilityDate,
      let thirdAvailabilityStart = thirdAvailabilityStart,
      let thirdAvailabilityEnd = thirdAvailabilityEnd
    {
      
      dict["thirdAvailabilityDate"] = thirdAvailabilityDate.timeIntervalSince1970
      dict["thirdAvailabilityStart"] = thirdAvailabilityStart.timeIntervalSince1970
      dict["thirdAvailabilityEnd"] = thirdAvailabilityEnd.timeIntervalSince1970
    }
    
    return dict
  }
}

extension Session {
  
  static let ref = ZFirebase.refDatabase
  
  static func get(with id: String, completion: @escaping (Session?) -> Void) {
    //    let ref = FIRDatabase.database().reference()
    let refSessions = ref.child("sessions")
    let refSession = refSessions.child(id)
    
    refSession.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
      if snap.exists() {
        let session = Session(json: snap.value as? [String: Any])
        completion(session)
      } else {
        completion(nil)
      }
    }
  }
  
  static func test(
    userId: String,
    sessionId: String,
    isPractitionerWhoCancelled: Bool = false,
    completion: @escaping (NSError?, String) -> Void
    ) {
    
    DispatchQueue.global(qos: .background).async {
      let error = NSError(domain: "", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Some error!"
        ])
      
      completion(nil, "Everything went ok dude.")
    }
    
  }
  
  static func cancelSession(
    userId: String,
    sessionId: String,
    isPractitionerWhoCancelled: Bool = false,
    completion: @escaping (NSError?, String) -> Void
    ) {
    let url = Constants.Server.cancelSession
    var postData = [String: Any]()
    
    postData["userId"] = userId
    postData["sessionId"] = sessionId
    postData["isPractitionerWhoCancelled"] = isPractitionerWhoCancelled
    
    Alamofire.request(
      url,
      method: .post,
      parameters: postData,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          let message = json["message"].stringValue
          
          if json["error"].boolValue {
            let error = NSError(domain: "Session Module", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completion(error, "")
          } else {
            completion(nil, message)
          }
        case .failure(let error):
          completion(error as NSError?, "")
          break
        }
    }
  }
  
  static func getInfoOfCancelSession(
    userId: String,
    sessionId: String,
    completion: @escaping (NSError?, String) -> Void
    ) {
    
    let url = Constants.Server.getInfoOfCancelSession
    var postData = [String: Any]()
    
    postData["userId"] = userId
    postData["sessionId"] = sessionId
    
    Alamofire.request(
      url,
      method: .post,
      parameters: postData,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          let message = json["message"].stringValue
          
          if json["error"].boolValue {
            let error = NSError(domain: "Session Module", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completion(error, "")
          } else {
            completion(nil, message)
          }
        case .failure(let error):
          completion(error as NSError?, "")
          break
        }
    }
  }
  
  
  //CellState
  //  case invitedNotAccepted = "invitedNotAccepted"
  //  case acceptedAndnotCompleted = "acceptedAndnotCompleted"
  //  case checkedIn = "checkedIn"  charged
  //  case cancelledByUser = "cancelledByUser"
  //  case cancelledByPractitioner = "cancelledByPractitioner"
  
  
  //  // cancelled
  //  case completedNotPaid = "completedNotPaid"
  //  case completedAndPaid = "completedAndPaid"
  //  //  case client
  static func checkinSession(
    sessionId: String,
    userId: String,
    completion: @escaping (NSError?, String) -> Void
    ) {
    
    let url = Constants.Server.checkinSession
    var postData = [String: Any]()
    
    postData["userId"] = userId
    postData["sessionId"] = sessionId
    
    Alamofire.request(
      url,
      method: .post,
      parameters: postData,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          let message = json["message"].stringValue
          
          if json["error"].boolValue {
            let error = NSError(domain: "Session Module", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completion(error, "")
          } else {
            completion(nil, message)
          }
        case .failure(let error):
          completion(error as NSError?, "")
          break
        }
    }
    
  }
  
  static func updateSessionStatus(userId: String, sessionId: String, status: String, reason: String, completion: ((Error?) -> Void)? = nil) {
    let refSession = ref
      .child("sessions")
      .child(sessionId)
    
    let refUserSession = ref
      .child("user-sessions")
      .child(userId)
      .child(sessionId)
    
    var data = [String: Any]()
    data["status"] = status
    data["cancellationReasonByPractitioner"] = reason
    
    Ax.serial(tasks: [
      
      { done in
        refSession.updateChildValues(data) { (error, ref) in
          done(error as Optional<NSError>)
        }
      },
      
      { done in
        refUserSession.updateChildValues(data) { (error, ref) in
          done(error as Optional<NSError>)
        }
      }
      
    ]) { (error) in
      completion?(error)
    }
  }
  
  static func updateAddress(userId: String, sessionId: String, addressInfo: AddressInfo) {
    
    let address = addressInfo.address ?? ""
    let city = addressInfo.city ?? ""
    let state = addressInfo.state ?? ""
    let zip = addressInfo.zip ?? ""
    let lat = addressInfo.latitude ?? 0.0
    let lng = addressInfo.longitude ?? 0.0
    
    let addressToUpdate = "\(address)\n\(city), \(state) \(zip)"
    
    let refSession = ref
      .child("sessions")
      .child(sessionId)
    
    var dataSession = [String: Any]()
    dataSession["address"] = addressToUpdate
    dataSession["latitude"] = lat
    dataSession["longitude"] = lng
    
    refSession.updateChildValues(dataSession)
    
    
    let refUserSession = ref
      .child("user-sessions")
      .child(userId)
      .child(sessionId)
    
    var dataUserSession = [String: Any]()
    dataUserSession["address"] = addressToUpdate
    
    refUserSession.updateChildValues(dataUserSession)
  }
  
  static func save(session: Session) {
    
  }
}

































