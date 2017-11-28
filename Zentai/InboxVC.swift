//
//  InboxVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/16/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import Ax
import SVProgressHUD

class InboxVC: UITableViewController {
  var messages = [InboxMessage]()
  
  var currentUser: User?
  var practitionerId: String?
  
  let cellId = "InboxCell"
  
  var handlerId: UInt  = 0
  
  var comesFromPushNotification = false
  var dataFromPushnotification: [String: Any]?
}

extension InboxVC {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "INBOX"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    // set header right button 17x17 home
    //    let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    //    //    rightButton.setBackgroundImage(UIImage(named: "user-profile"), for: .normal)
    ////    rightButton.setImage(UIImage(named: "user-profile"), for: .normal)
    //    rightButton.setTitleColor(.blue, for: .normal)
    //    rightButton.setTitle("Delete me", for: .normal)
    ////    rightButton.imageView?.contentMode = .scaleAspectFit
    //    rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)
    //    let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
    //    let rightBarButtonItem = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(rightButtonTouched))
    //    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  func rightButtonTouched() {
    print("right button touched")
    
    performSegue(withIdentifier: "InboxToDelete", sender: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Message.clearNotifications(userId: User.currentUserId)
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    if let currentUserId = User.currentUserId {
      handlerId = InboxMessage.getMessages(userId: currentUserId) { (messages) in
        print("friday from get messages")
        Spinner.dismiss()
        
        print("tuesday self.messages.count: \(self.messages.count)")
        self.messages = messages
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if comesFromPushNotification && dataFromPushnotification != nil {
      performSegue(withIdentifier: Storyboard.InboxToChat, sender: nil)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
    
    if let userId = User.currentUserId {
      Message.clearNotifications(userId: userId)
      InboxMessage.removeHandler(userId: userId, handlerId: handlerId)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.InboxToChat {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers.first as? ChatViewController
      
      if !comesFromPushNotification {
        let message = sender as? InboxMessage
        print(message)
        print(message?.userId)
        vc?.roomId = message?.chatId
        vc?.userIdTwo = message?.userId
        vc?.userNameTwo = message?.username
      } else {
        if let data = dataFromPushnotification {
          let chatId = data["chatId"] as? String
          let userIdTwo = data["toId"] as? String
          let userNameTwo = data["toName"] as? String
          
          vc?.roomId = chatId
          vc?.userIdTwo = userIdTwo
          vc?.userNameTwo = userNameTwo
        }
      }
      
      comesFromPushNotification = false
      dataFromPushnotification = nil
    }
  }
}

extension InboxVC {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let message = messages[indexPath.row]
    
    performSegue(withIdentifier: Storyboard.InboxToChat, sender: message)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InboxCell
    
    let message = messages[indexPath.row]
    
    cell.seen = true
    cell.name = message.username
    cell.message = message.lastMessage
    cell.photoURL = message.profileURL
    cell.seen = message.seen
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}




































