//
//  InboxMessage.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/16/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import FirebaseDatabase

struct InboxMessage {
  let chatId: String
  let lastMessage: String
  let profileURL: String
  let username: String
  let userId: String
  let seen: Bool
}

extension InboxMessage {
  init?(json: [String: Any]?) {
    guard
      let json = json,
      let chatId = json["chat-id"] as? String,
      let lastMessage = json["last-message"] as? String,
      let profileURL = json["profile-url"] as? String,
      let username = json["username"] as? String,
      let userId = json["userId"] as? String,
      let seen = json["seen"] as? Bool
      else {
        return nil
    }
    
    self.chatId = chatId
    self.lastMessage = lastMessage
    self.profileURL = profileURL
    self.username = username
    self.userId = userId
    self.seen = seen
  }
}

extension InboxMessage {
  static func removeHandler(userId: String, handlerId: UInt) {
    let ref = ZFirebase.refDatabase
    let refInbox = ref.child("inbox")
    let refUser = refInbox.child(userId)
    let query = refUser.queryOrdered(byChild: "seen")
    
    query.removeObserver(withHandle: handlerId)
  }
  
  static func getMessages(
    userId: String,
    completion: @escaping ([InboxMessage]) -> Void
    ) -> UInt
  {
    let ref = ZFirebase.refDatabase
    let refInbox = ref.child("inbox")
    let refUser = refInbox.child(userId)
    let query = refUser.queryOrdered(byChild: "seen")
    
    return query.observe(.value) { (snap: FIRDataSnapshot) in
      var messages = [InboxMessage]()
      
      if snap.exists() {
        if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
          messages = dictionaries.flatMap {
            return InboxMessage(json: $0.value as? [String: Any])
          }
        }
      }
      
      completion(messages)
    }
  }
}






























