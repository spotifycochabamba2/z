//
//  PractitionerHomeTBC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/5/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class PractitionerHomeTBC: UITabBarController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print(navigationController)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  func remoteNotificationPassed(notification: Notification) {
    if let data = notification.object as? [String: Any] {
      showChat(data)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.RemoteNotification.id), object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.RemoteNotification.logout), object: nil)
  }
  
  func logout() {
    User.logout()
    _ = navigationController?.popToRootViewController(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(remoteNotificationPassed), name: Notification.Name(Constants.RemoteNotification.id), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(logout), name: Notification.Name(Constants.RemoteNotification.logout), object: nil)
    
    print("PractitionerHomeTVC called")
    
    tabBar.tintColor = UIColor.zentaiPrimaryColor
    tabBar.unselectedItemTintColor = UIColor.hexStringToUIColor(hex: "#bbbbbb")
    tabBar.barTintColor = .white
    tabBar.isTranslucent = true
    
    navigationItem.title = "WTF?"
    
    tabBar.items?.forEach {
      let attributes = [
        NSFontAttributeName: UIFont(name: "SanFranciscoText-Light", size: 13)!//11
      ]
      
      $0.setTitleTextAttributes(attributes, for: .normal)
    }
    
    if let chatItem = tabBar.items?[3] {
      chatItem.title = "Inbox"
      chatItem.image = UIImage(named: "practitioner-inbox-not-selected")
    }
    
    let defaults = UserDefaults.standard
    
    if
      let chatId = defaults.object(forKey: "chatId") as? String,
      let toId = defaults.object(forKey: "toId") as? String,
      let toName = defaults.object(forKey: "toName") as? String
    {
      defaults.set(nil, forKey: "chatId")
      defaults.set(nil, forKey: "toId")
      defaults.set(nil, forKey: "toName")
      defaults.synchronize()
      
      var data = [String: Any]()
      
      data["chatId"] = chatId
      data["toId"] = toId
      data["toName"] = toName
      
      showChat(data)
      //      showChat([
      //        "chatId": chatId,
      //        "toId": toId,
      //        "toName": toName
      //        ])
    }
  }
  
  func showChat(_ data: [String: Any]) {
    DispatchQueue.main.async {
      print(self.tabBarController?.selectedIndex)
      print(self.selectedIndex)
      self.selectedIndex = 3
    }
  }
}


extension PractitionerHomeTBC {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    print(item.tag)
    
    //    if item.tag == 5 {
    //      User.logout()
    //      _ = navigationController?.popToRootViewController(animated: true)
    //    }
  }
}
































