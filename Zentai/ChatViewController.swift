//
//  ChatViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/15/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Ax
import SVProgressHUD


class ChatViewController: JSQMessagesViewController {
  internal var messages = [JSQMessage]()
  
  var currentUser: User?
  
  let bubbleFactory = JSQMessagesBubbleImageFactory()
  
  var userIdTwo: String?
  var userNameTwo: String?
  var profileURLTwo: String?
  
  var roomId: String?
  var messagesHandlerId: UInt = 0
}

extension ChatViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    Ax.serial(tasks: [
      { anyError in
        _ = User.getCurrentUser(once: true, navigationController: self.navigationController, completion: { (user) in
          if let user = user {
            self.currentUser = user
            self.senderId = user.id
            self.senderDisplayName = user.firstName
            
            anyError(nil)
          } else {
            anyError(NSError(domain: "UserDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user found"]))
          }
        })
      },
      
      { anyError in
        if self.roomId == nil {
          Message.createChatRoom(
            userIdOne: self.senderId,
            usernameOne: self.senderDisplayName,
            photoURLOne: self.currentUser?.profileURL ?? "",
            userIdTwo: self.userIdTwo!,
            usernameTwo: self.userNameTwo!,
            photoURLTwo: self.profileURLTwo ?? "",
            completion: { (roomId) in
              self.roomId = roomId
              anyError(nil)
          })
        } else {
          anyError(nil)
        }
      },
      
      { anyError in
        print("")
        print("monday hey")
        self.messagesHandlerId = self.getMessages(roomId: self.roomId!, completion: { (chatMessages) in
          print("monday from getting messages, self.roomId: \(self.roomId!), self.messagesHandlerId: \(self.messagesHandlerId)")
          print("")
          self.messages = chatMessages
          
          DispatchQueue.main.async {
            //            self.collectionView.reloadData()
            self.finishReceivingMessage(animated: true)
          }
          
          anyError(nil)
        })
      },
      
      { anyError in
        // user id one
        let userIdOne = self.currentUser!.id!
        
        print("userIdOne: \(userIdOne)")
        print("userIdTwo: \(self.userIdTwo!)")
        
        // user id two
        Message.markAsSeenChatRoom(userIdOne: userIdOne, userIdTwo: self.userIdTwo!, completion: { (success) in
          
        })
        
        anyError(nil)
      }
    ]) { (anyError) in
      Spinner.dismiss()
      
      if let error = anyError {
        print(error)
      }
    }
    
    
    print(userIdTwo)
    print(userNameTwo)
    
    self.senderId = ""
    self.senderDisplayName = ""
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "REPLY \(userNameTwo!.uppercased())"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    automaticallyScrollsToMostRecentMessage = true
    
    inputToolbar.contentView.leftBarButtonItem = nil
    
    let buttonWidth = CGFloat(40)
    let buttonHeight = inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
    
    let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
    customButton.setImage(UIImage(named: "send-message"), for: .normal)
    customButton.imageView?.contentMode = .scaleAspectFit
    
    inputToolbar.contentView.rightBarButtonItemWidth = buttonWidth
    inputToolbar.contentView.rightBarButtonItem = customButton
    
    inputToolbar.contentView.textView.font = UIFont(name: "SanFranciscoText-Light", size: 15)
    inputToolbar.contentView.textView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    
    collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
  }
  
  func sendButtonTouched() {
    print("send button touched")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
    
    if let roomId = roomId {
      print("")
      print("monday from view will dissapear, roomId: \(roomId), \(messagesHandlerId)")
      print(roomId)
      print(messagesHandlerId)
      Message.removeObserverAt(chatId: roomId, id: messagesHandlerId)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollToBottom(animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
}

extension ChatViewController {
  @IBAction func backTouched(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

extension ChatViewController {
  internal func getMessages(roomId: String, completion: @escaping ([JSQMessage]) -> Void) -> UInt {
    
    let id = Message.getAll(byChatId: roomId) { (messages) in
      
      let chatMessages = messages.map { (message) -> JSQMessage in
        let chatMessage = JSQMessage(
          senderId: message.fromId,
          senderDisplayName: message.fromUsername,
          date: message.date,
          text: message.text
        )
        
        return chatMessage!
      }
      
      completion(chatMessages)
    }
    
    return id
  }
}






extension ChatViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    
    return messages[indexPath.row]
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.row]
    
    
    let outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: Utils.hexStringToUIColor(hex: "#e6f2f3"))
    let incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: Utils.hexStringToUIColor(hex: "#o( "))
    
    if senderId == message.senderId {
      return outgoingBubble
    } else {
      return incomingBubble
    }
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    
    cell.textView.font = UIFont(name: "SanFranciscoText-Light", size: 15)
    cell.textView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    cell.textView.textAlignment = .center
    
    return cell
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
    let message = messages[indexPath.item]
    
    let attributes = [
      NSFontAttributeName: UIFont(name: "SanFranciscoText-Heavy", size: 13)!,
      NSForegroundColorAttributeName: UIColor.hexStringToUIColor(hex: "#484646")
    ]
    
    switch message.senderId {
    case senderId:
      return NSAttributedString(string: "ME", attributes: attributes)
    default:
      guard let senderDisplayName = message.senderDisplayName else {
        return nil
      }
      return NSAttributedString(string: senderDisplayName.uppercased(), attributes: attributes)
    }
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
    return 13
  }
}



extension ChatViewController {
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    print("did press send")
    
    Message.sendMessage(
      chatId: roomId!,
      fromUsername: senderDisplayName,
      fromId: senderId,
      toId: userIdTwo!,
      toUsername: userNameTwo!,
      text: text) { (error) in
    }
    
    messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
    collectionView.reloadData()
    //    scrollToBottom(animated: true)
    finishSendingMessage(animated: true)
  }
  
}

































