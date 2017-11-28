//
//  UserSession.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/13/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Firebase
import Ax
import Alamofire
import SwiftyJSON

struct UserSession {
  var selectedDate: Date?
  var selectedStart: Date?
  var selectedEnd: Date?
  
  let id: String
  let status: String
  
  var apartment: String = ""
  let address: String
  let state: String
  let city: String
  let zip: String
  
  let clientName: String
  let practitionerName: String?
  
}

enum UserSessionResult {
  case fail(error: Error)
  case success(commited: Bool, message: String)
}

extension UserSession {
  
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
      let address = json["address"] as? String,
      //      let firstAvailabilityDate = json["firstAvailabilityDate"] as? Double,
      //      let firstAvailabilityEnd = json["firstAvailabilityEnd"] as? Double,
      //      let firstAvailabilityStart = json["firstAvailabilityStart"] as? Double,
      let id = json["id"] as? String,
      let status = json["status"] as? String,
      let zip = json["zip"] as? String,
      let clientName = json["clientName"] as? String,
      
      let state = json["state"] as? String,
      let city = json["city"] as? String
      else {
        return nil
    }
    
    //    self.firstAvailabilityEnd = Date(timeIntervalSince1970: firstAvailabilityEnd)
    //    self.firstAvailabilityDate = Date(timeIntervalSince1970: firstAvailabilityDate)
    //    self.firstAvailabilityStart = Date(timeIntervalSince1970: firstAvailabilityStart)
    
    //    self.selectedStart = nil
    //    self.selectedDate = nil
    //    self.selectedEnd = nil
    
    if
      let selectedDate = json["selectedDate"] as? Double,
      let selectedStart = json["selectedStartTime"] as? Double,
      let selectedEnd = json["selectedEndTime"] as? Double
    {
      self.selectedDate = Date(timeIntervalSince1970: selectedDate)
      self.selectedStart = Date(timeIntervalSince1970: selectedStart)
      self.selectedEnd = Date(timeIntervalSince1970: selectedEnd)
    }
    
    self.id = id
    self.status = status
    
    self.zip = zip
    self.address = address
    self.state = state
    self.city = city
    
    self.practitionerName = json["practitionerName"] as? String
    self.apartment = json["apartment"] as? String ?? ""
    
    self.clientName = clientName
  }
}

extension UserSession {
  static let ref = ZFirebase.refDatabase
  static let refSessions = ref.child("sessions")
  
  static func removeListenerOnInvitations(handlerId: UInt, date: Date) {
    //    let ref = FIRDatabase.database().reference()
    let refSessions = ref.child("sessions")
      .queryOrdered(byChild: "firstAvailabilityDate")
      .queryStarting(atValue: date.timeIntervalSince1970)
    
    refSessions.removeObserver(withHandle: handlerId)
  }
  
  static func removeListenerOnPractitionerAppointments(practitionerId: String, handlerId: UInt) {
    //    let ref = FIRDatabase.database().reference()
    let refSessions = ref
      .child("sessions")
      .queryOrdered(byChild: "assignedTo")
      .queryEqual(toValue: practitionerId)
    
    refSessions.removeObserver(withHandle: handlerId)
  }
  
  
  static func getPractitionerAppointments(by practitionerId: String, and state:String, completion: @escaping ([Session]) -> Void) -> UInt {
    let refSessions = ref.child("sessions")
    
    return refSessions
      .queryOrdered(byChild: "assignedTo")
      .queryEqual(toValue: practitionerId)
      .observe(.value) { (snap: FIRDataSnapshot) in
        var practitionerSessions = [Session]()
        
        if snap.exists() {
          if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
            practitionerSessions = dictionaries.flatMap {
              let session = Session(json: $0.value as? [String: Any])
              
              if let session = session {
                
                if session.status != state {
                  return nil
                }
                
                return session
              }
              
              return nil
            }
          }
        }
        
        practitionerSessions.sort(by: { (session1, session2) -> Bool in
          return session1.firstAvailabilityDate.compare(session2.firstAvailabilityDate) == .orderedDescending
        })
        
        completion(practitionerSessions)
    }
  }
  
  //  static func getPractitionerAppointments(by practitionerId: String, completion: @escaping ([Session]) -> Void) -> UInt {
  //    let refSessions = ref.child("sessions")
  //
  //    return refSessions
  //              .queryOrdered(byChild: "assignedTo")
  //              .queryEqual(toValue: practitionerId)
  //              .observe(.value) { (snap: FIRDataSnapshot) in
  //                var practitionerSessions = [Session]()
  //
  //                if snap.exists() {
  //                  if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
  //                    practitionerSessions = dictionaries.flatMap {
  //                      let session = Session(json: $0.value as? [String: Any])
  //
  //                      if let session = session {
  //
  //                        if session.status != CellState.acceptedAndnotCompleted.rawValue {
  //                          return nil
  //                        }
  //
  //                        return session
  //                      }
  //
  //                      return nil
  //                    }
  //                  }
  //                }
  //
  //                practitionerSessions.sort(by: { (session1, session2) -> Bool in
  //                  return session1.firstAvailabilityDate.compare(session2.firstAvailabilityDate) == .orderedDescending
  //                })
  //
  //                completion(practitionerSessions)
  //              }
  //  }
  
  static func sendPushNotificationToClient(
    clientId: String,
    practitionerName: String,
    sessionId: String,
    completion: ((Error?) -> Void)? = nil
    ) {
    var parameters = [String: Any]()
    
    parameters["practitionerName"] = practitionerName
    parameters["clientId"] = clientId
    parameters["sessionId"] = sessionId
    
    let stringURL = Constants.Server.acceptInvitationURL
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let data):
          break
        case .failure(let error):
          break
        }
    }
  }
  
  static func acceptInvitation(
    practitionerId: String,
    practitionerName: String,
    clientId: String,
    sessionId: String,
    selectedDate: Double,
    selectedStartTime: Double,
    selectedEndTime: Double,
    completion: @escaping (UserSessionResult) -> Void) {
    let ref = ZFirebase.refDatabase
    
    // session
    let refSessions = ref.child("sessions")
    let refSession = refSessions.child(sessionId)
    
    // user-session
    let refUserSessions = ref.child("user-sessions")
    let refClient = refUserSessions.child(clientId)
    let refClientSession = refClient.child(sessionId)
    
    var wasCancelled = false
    
    // update refSessions with transaction first
    refSession.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
      if var session = currentData.value as? [String: Any] {
        
        let assignedTo = session["assignedTo"] as? String
        let status = session["status"] as? String ?? ""
        
        if status == "cancelledByUser" {
          wasCancelled = true
          return FIRTransactionResult.success(withValue: currentData)
        } else if status == CellState.invitedNotAccepted.rawValue {
          session["status"] = CellState.acceptedAndnotCompleted.rawValue
          session["assignedTo"] = practitionerId
          session["practitionerName"] = practitionerName
          
          session["selectedDate"] = selectedDate
          session["selectedEndTime"] = selectedEndTime
          session["selectedStartTime"] = selectedStartTime
          
          currentData.value = session
          
          return FIRTransactionResult.success(withValue: currentData)
        } else {
          if assignedTo == practitionerId {
            return FIRTransactionResult.success(withValue: currentData)
          }
          
          return FIRTransactionResult.abort()
        }
      } else {
        return FIRTransactionResult.success(withValue: currentData)
      }
    }) { (error, commited, snap) in
      print("error: \(error?.localizedDescription)")
      print("commited: \(commited)")
      
      if let error = error {
        completion(UserSessionResult.fail(error: error))
      } else {
        
        var values = [String: Any]()
        
        values["status"] = CellState.acceptedAndnotCompleted.rawValue
        values["assignedTo"] = practitionerId
        values["practitionerName"] = practitionerName
        values["selectedDate"] = selectedDate
        values["selectedEndTime"] = selectedEndTime
        values["selectedStartTime"] = selectedStartTime
        
        refClientSession.updateChildValues(values)
        
        var message = "You accepted to help a soul that needs your healing work."
        
        if wasCancelled {
          message = "The session was cancelled by the user."
        } else if !commited {
          message = "Sorry, someone else accepted the session before you, try accepting other sessions."
          //          sendPushNotificationToClient(clientId: clientId, practitionerName: practitionerName)
        } else {
          sendPushNotificationToClient(
            clientId: clientId,
            practitionerName: practitionerName,
            sessionId: sessionId
          )
        }
        
        completion(UserSessionResult.success(commited: commited, message: message))
      }
    }
    
    // only then set refUsersSessions
  }
  
  static func declineInvitation(practitionerId: String, sessionId: String, sessionExpirationDate: Date, completion: @escaping (Error?) -> Void) {
    //    let ref = FIRDatabase.database().reference()
    let refDeclinedSessions = ref.child("declined-sessions")
    let refPractitioner = refDeclinedSessions.child(practitionerId)
    let refSession = refPractitioner.child(sessionId)
    
    refSession.setValue([
      "id": sessionId,
      "expirationDate": sessionExpirationDate.timeIntervalSince1970
    ]) { (error, ref) in
      completion(error)
    }
  }
  
  static func removeListenNewInvitations(
    handlerId: UInt
    ) {
    refSessions.removeObserver(withHandle: handlerId)
  }
  
  static func removeListenChangesOnSessionState(
    handlerId: UInt
    ) {
    let query = refSessions.queryOrdered(byChild: "status")
    query.removeObserver(withHandle: handlerId)
  }
  
  static func listenChangesOnSessionState(
    fromTime time: Date,
    completion: @escaping () -> Void
    ) -> UInt {
    
    let query = refSessions
      .queryOrdered(byChild: "status")
    
    return query.observe(.value) { (snap: FIRDataSnapshot) in
      print("a chane happened.")
      completion()
    }
  }
  
  static func listenNewInvitations(
    fromTime time: Date,
    completion: @escaping () -> Void
    ) -> UInt {
    let query = refSessions
      .queryLimited(toLast: 1)
    
    
    print(query)
    
    return query.observe(.childAdded) { (snap: FIRDataSnapshot) in
      print(snap.childrenCount)
      completion()
    }
    
  }
  
  static func getPractitionerInvitations(
    by practitionerId: String,
    completion: @escaping (NSError?, _ invitedSessions: [Session],
    _ acceptedSessions: [Session]) -> Void
    ) {
    let stringURL = Constants.Server.invitations
    var invitedSessions = [Session]()
    var acceptedSessions = [Session]()
    
    var params = [String: Any]()
    params["practitionerId"] = practitionerId
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: params,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          
          print(json)
          
          if json["error"].boolValue {
            let error = NSError(
              domain: "Invitation",
              code: 0,
              userInfo: [
                NSLocalizedDescriptionKey: json["message"].stringValue
              ]
            )
            
            completion(error, invitedSessions, acceptedSessions)
            return
          }
          
          if let jsonInvitedSessions = json["invitedSessions"].array {
            for jsonSession in jsonInvitedSessions {
              if let session = Session(json: jsonSession.dictionaryObject) {
                invitedSessions.append(session)
              }
            }
          }
          
          if let jsonAcceptedSesions = json["acceptedSessions"].array {
            for jsonSession in jsonAcceptedSesions {
              if let session = Session(json: jsonSession.dictionaryObject) {
                acceptedSessions.append(session)
              }
            }
          }
          
          completion(nil, invitedSessions, acceptedSessions)
          break
        case .failure(let error):
          completion(error as NSError?, invitedSessions, acceptedSessions)
          break
        }
    }
  }
  
  static func removeListenerOnUsersSessions(handlerId: UInt, userId: String) {
    //    let ref = FIRDatabase.database().reference()
    let refUserSessions = ref.child("user-sessions")
    let refSessions = refUserSessions.child(userId).queryOrdered(byChild: "dateUpdated")
    
    refSessions.removeObserver(withHandle: handlerId)
  }
  
  static func get(by userId: String, completion: @escaping ([UserSession]) -> Void) -> UInt {
    
    //    let ref = FIRDatabase.database().reference()
    let refUserSessions = ref.child("user-sessions")
    let refSessions = refUserSessions.child(userId).queryOrdered(byChild: "dateUpdated")
    
    return refSessions.observe(.value) { (snap: FIRDataSnapshot) in
      var sessions = [UserSession]()
      
      if snap.exists() {
        if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
          sessions = dictionaries.flatMap {
            return UserSession(json: $0.value as? [String: Any])
          }
        }
      }
      
      completion(sessions)
    }
    
  }
}



































