//
//  Message.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/15/16.
//  Copyright © 2016 Zentai. All rights reserved.
//


import Foundation
import FirebaseDatabase
import Ax
import Alamofire
import SwiftyJSON

struct Message {
  let date: Date
  let fromId: String
  let fromUsername: String
  let text: String
}

extension Message {
  init?(json: [String: Any]?) {
    guard
      let json = json,
      let date = json["date"] as? Double,
      let fromId = json["fromId"] as? String,
      let fromUsername = json["fromUsername"] as? String,
      let text = json["text"] as? String
      else {
        return nil
    }
    
    self.date = Date(timeIntervalSince1970: date)
    self.fromUsername = fromUsername
    self.fromId = fromId
    self.text = text
  }
}

extension Message {
  
  static func removeObserverAt(chatId: String, id: UInt) {
    let ref = FIRDatabase
      .database()
      .reference()
      .child("chat")
      .child(chatId)
      .queryOrdered(byChild: "date")
    ref.removeObserver(withHandle: id)
  }
  
  static func markAsSeenChatRoom(userIdOne: String, userIdTwo: String, completion: (Bool) -> Void) {
    let ref = ZFirebase.refDatabase
    let refInbox = ref.child("inbox")
    
    let refFrom = refInbox.child(userIdOne)
    let refFromTo = refFrom.child(userIdTwo)
    
    refFromTo.updateChildValues([
      "seen": true
      ])
  }
  
  static func getNotifications(userId: String?, completion: @escaping (Int) -> Void) {
    if let userId = userId {
      let ref = ZFirebase.refDatabase
      let refUsers = ref.child("users")
      let refUser = refUsers.child(userId)
      let refUserNotifications = refUser.child("notifications")
      print(refUserNotifications)
      //
      //      refUserNotifications.observe(.value, with: { (snap:
      refUserNotifications.observeSingleEvent(of: .value) {(snap: FIRDataSnapshot) in
        let notifications = snap.value as? Int ?? 0
        
        completion(notifications)
      }
      
    }
  }
  
  static func clearNotifications(userId: String?) {
    if let userId = userId {
      let ref = ZFirebase.refDatabase
      let refUsers = ref.child("users")
      let refUser = refUsers.child(userId)
      
      refUser.updateChildValues([
        "notifications": 0
        ])
    }
  }
  
  static func createChatRoom(
    userIdOne: String,
    usernameOne: String,
    photoURLOne: String,
    
    userIdTwo: String,
    usernameTwo: String,
    photoURLTwo: String,
    
    completion: @escaping (String) -> Void
    )
  {
    let ref = ZFirebase.refDatabase
    let refInbox = ref.child("inbox")
    let refUsers = ref.child("users")
    
    let refFrom = refInbox.child(userIdOne)
    let refFromTo = refFrom.child(userIdTwo)
    
    let refTo = refInbox.child(userIdTwo)
    let refToFrom = refTo.child(userIdOne)
    
    var alreadyExists = false
    var roomId: String?
    
    Ax.serial(tasks: [
      
      { done in
        refFromTo.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
          if snap.exists() {
            alreadyExists = true
            roomId = (snap.value as? [String: Any])?["chat-id"] as? String
          } else {
            roomId = refInbox.childByAutoId().key
          }
          
          done(nil)
        }
      },
      
      { done in
        if !alreadyExists {
          
          var values: [String: Any] = [
            "chat-id": roomId!,
            "profile-url": photoURLTwo,
            "username": usernameTwo,
            "userId": userIdTwo,
            "seen": false
          ]
          refFromTo.setValue(values)
          
          values["username"] = usernameOne
          values["profile-url"] = photoURLOne
          values["userId"] = userIdOne
          refToFrom.setValue(values)
        }
        
        done(nil)
      }
    ]) { (anyError) in
      completion(roomId!)
    }
    
  }
  
  static func sendMessage(
    chatId: String,
    fromUsername: String,
    fromId: String,
    toId: String,
    toUsername: String,
    text: String,
    completion: @escaping (NSError?) -> Void
    ) {
    var parameters = [String: Any]()
    parameters["fromId"] = fromId
    parameters["fromUsername"] = fromUsername
    parameters["toId"] = toId
    parameters["toUsername"] = toUsername
    parameters["text"] = text
    
    let stringURL = Constants.Server.sendMessageURL
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          _ = JSON(data)
          break
        case .failure(let error):
          completion(error as NSError?)
        }
    }
    
    //    let ref = FIRDatabase.database().reference()
    //    let refInbox = ref.child("inbox")
    //    let refUsers = ref.child("users")
    //    let refUserFrom = refUsers.child(fromId)
    //    let refUserTo = refUsers.child(toId)
    //
    //    let refFrom = refInbox.child(fromId)
    //    let refFromTo = refFrom.child(toId)
    //
    //    let refTo = refInbox.child(toId)
    //    let refToFrom = refTo.child(fromId)
    //
    //    var chatRoomId: String?
    //
    //    Ax.serial(tasks: [
    //      { done in
    //        refToFrom.observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
    //          if snap.exists() {
    //            if let child = snap.value as? [String: Any] {
    //              chatRoomId = child["chat-id"] as? String
    //              done(nil)
    //            } else {
    //              done(NSError(domain: "ChatDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "no room id found"]))
    //            }
    //          } else {
    //            done(NSError(domain: "ChatDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "no room id found"]))
    //          }
    //        })
    //      },
    //
    //      { done in
    //        let refChat = ref.child("chat")
    //        let refMessages = refChat.child(chatRoomId!)
    //        let refMessage = refMessages.childByAutoId()
    //
    //        refMessage.setValue([
    //          "date": Date().timeIntervalSince1970,
    //          "fromId": fromId,
    //          "fromUsername": fromUsername,
    //          "text": text
    //        ])
    //
    //        done(nil)
    //      },
    //      { done in
    //        refToFrom.updateChildValues([
    //          "last-message": text,
    //          "seen": false
    //        ])
    //
    //        refFromTo.updateChildValues([
    //          "last-message": text,
    //          "seen": false
    //        ])
    //
    //        done(nil)
    //      },
    //      { done in
    //
    //        refUserFrom.runTransactionBlock({ (currentData) -> FIRTransactionResult in
    //          if var user = currentData.value as? [String: AnyObject] {
    //
    //            var notifications = user["notifications"] as? Int ?? 0
    //            notifications += 1
    //            user["notifications"] = notifications as AnyObject?
    //
    //            currentData.value = user
    //
    //            return FIRTransactionResult.success(withValue: currentData)
    //          }
    //
    //          return FIRTransactionResult.success(withValue: currentData)
    //        })
    //
    //
    //        done(nil)
    //      },
    //      { done in
    //
    //        refUserTo.runTransactionBlock({ (currentData) -> FIRTransactionResult in
    //          if var user = currentData.value as? [String: AnyObject] {
    //
    //            var notifications = user["notifications"] as? Int ?? 0
    //            notifications += 1
    //            user["notifications"] = notifications as AnyObject?
    //
    //            currentData.value = user
    //
    //            return FIRTransactionResult.success(withValue: currentData)
    //          }
    //
    //          return FIRTransactionResult.success(withValue: currentData)
    //        })
    //
    //        done(nil)
    //      },
    //      { done in
    //
    //        let data: [String: Any] = [
    //          "fromName": fromUsername,
    //          "toId": toId,
    //          "message": text,
    //          "chatId": chatRoomId,
    //          "toName": toUsername,
    //          "fromId": fromId
    //        ]
    //
    //        sendPushNotification(parameters: data, completion: { (error) in
    //          done(nil)
    //        })
    //      }
    //    ]) { (anyError) in
    //      completion(true)
    //    }
  }
  
  static func sendPushNotification(parameters: [String: Any], completion: @escaping (Error?) -> Void) {
    
    let fromName = parameters["fromName"] as! String
    let toId = parameters["toId"] as! String
    let message = parameters["message"] as! String
    let chatId = parameters["chatId"] as! String
    let toName = parameters["toName"] as! String
    let fromId = parameters["fromId"] as! String
    
    let data: [String: String] = [
      "fromName": fromName,
      "toId": toId,
      "message": message,
      "chatId": chatId,
      "toName": toName,
      "fromId": fromId
    ]
    
    print(data)
    
    let stringURL = Constants.Server.messagesURL
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: data,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          //        let json = JSON(data)
          break
        case .failure(let error):
          break
        }
        
        completion(nil)
    }
  }
  
  static func getAll(byChatId chatId: String, completion: @escaping([Message]) -> Void) -> UInt {
    let ref = ZFirebase.refDatabase
    let refMessages = ref
      .child("chat")
      .child(chatId)
    var id: UInt = 0
    
    print(refMessages)
    let query = refMessages.queryOrdered(byChild: "date")
    
    id = query.observe(.value) { (snap: FIRDataSnapshot) in
      var messages = [Message]()
      
      if snap.exists() {
        if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
          print(dictionaries)
          messages = dictionaries.flatMap {
            print($0)
            return Message(json: $0.value as? [String: Any])
          }
        }
      }
      
      completion(messages)
    }
    
    return id
  }
}




























