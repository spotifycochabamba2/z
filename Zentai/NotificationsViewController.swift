//
//  NotificationsViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/14/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotificationsViewController: UITableViewController {
  
  var currentUserId: String?
  
  @IBOutlet weak var pushView: UIView!
  @IBOutlet weak var pushCell: UITableViewCell!
  @IBOutlet weak var smsCell: UITableViewCell!
  
  @IBOutlet weak var pushNotificationSwitch: UISwitch!
  
  //  @IBAction func pushNotificationSwitchAction() {
  //    if let currentUserId = currentUserId {
  //
  ////      SVProgressHUD.show()
  //
  //      print(pushNotificationSwitch.isOn)
  //
  //      pushNotificationSwitch.setOn(false, animated: false)
  ////      pushNotificationSwitch.isOn = false
  //
  ////      if  pushNotificationSwitch.isOn {
  ////        User.isPushNotificationsEnabled(completion: { (isEnabled) in
  ////          User.updateUserWith(isPushEnabled: isEnabled, userId: User.currentUserId!)
  ////        })
  ////      } else {
  ////        User.updateUserWith(isPushEnabled: pushNotificationSwitch.isOn, userId: currentUserId)
  ////      }
  //    }
  //  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  func pushViewWasTapped() {
    
    if let currentUserId = self.currentUserId {
      if pushNotificationSwitch.isOn {
        User.updateUserWith(isPushEnabled: false, userId: currentUserId)
        
        pushNotificationSwitch.setOn(false, animated: true)
      } else {
        
        //        SVProgressHUD.show()
        Spinner.show(currentViewController: self)
        User.isPushNotificationsEnabled(completion: { [weak weakSelf = self] (isEnabled) in
          Spinner.dismiss()
          
          User.updateUserWith(isPushEnabled: isEnabled, userId: currentUserId)
          
          if isEnabled {
            DispatchQueue.main.async {
              weakSelf?.pushNotificationSwitch.setOn(true, animated: true)
            }
          } else {
            let title = "The notifications permission was not authorized."
            let message = "Please enable it in Settings to continue."
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
              UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            weakSelf?.present(alert, animated: true, completion: nil)
          }
          })
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushViewWasTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    pushView.addGestureRecognizer(tapGestureRecognizer)
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    _ = User.getCurrentUser(once: true, navigationController: navigationController, completion: { (user) in
      Spinner.dismiss()
      if let user = user {
        self.currentUserId = user.id
        DispatchQueue.main.async {
          self.pushNotificationSwitch.isOn = user.isPushEnabled
        }
      }
    })
    
    tableView.separatorInset = .zero
    tableView.layoutMargins = .zero
    
    pushCell.selectionStyle = .none
    smsCell.selectionStyle = .none
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "NOTIFICATIONS"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
  }
}
