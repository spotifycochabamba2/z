
//  AppDelegate.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/18/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import Stripe
import UserNotifications
import FirebaseMessaging
import GoogleMaps
import SVProgressHUD
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
  
  var window: UIWindow?
  var isTerminatedState = false
  
  func setChatFromPush(userInfo: [String: Any]?) {
    if let userInfo = userInfo {
      if
        let chatId = userInfo["chatId"] as? String,
        let userIdTwo = userInfo["toId"] as? String,
        let userNameTwo = userInfo["toName"] as? String
      {
        let defaults = UserDefaults.standard
        defaults.set(chatId, forKey: "chatId")
        defaults.set(userIdTwo, forKey: "toId")
        defaults.set(userNameTwo, forKey: "toName")
        defaults.synchronize()
      }
    }
  }
  
  // background
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    setChatFromPush(userInfo: userInfo as? [String: Any])
  }
  
  
  
  // terminated
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    Fabric.with([Crashlytics.self, STPAPIClient.self])
    
    let customView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    customView.backgroundColor = .red
    
    UIApplication.shared.keyWindow?.addSubview(customView)
    
    //    customView.
    
    let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
    
    if let userInfo = notification as? [String: Any] {
      isTerminatedState = true
      setChatFromPush(userInfo: userInfo)
    }
    //    let userInfo = notification as? [String: Any]
    //    setChatFromPush(userInfo: userInfo)
    
    UINavigationBar.appearance().tintColor = UIColor.zentaiPrimaryColor
    
    GMSServices.provideAPIKey(Constants.Google.Maps.apiKey)
    
    FIRApp.configure()
    
    logoutIfFirstTimeUse()
    
    FIRDatabase.database().persistenceEnabled = false
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    STPPaymentConfiguration.shared().publishableKey = Constants.Stripe.TestPublisableKey
    
    // Configure push notification
    registerForRemoteNotification(application: application)
    
    NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
    
    
    return true
  }
  
  func logoutIfFirstTimeUse() {
    let userDefaults = UserDefaults.standard
    
    if !userDefaults.bool(forKey: "hasRunBefore") {
      
      let defaults = UserDefaults.standard
      
      defaults.set(nil, forKey: "latitude")
      defaults.set(nil, forKey: "longitude")
      
      defaults.set(nil, forKey: "genderSelected")
      defaults.set(nil, forKey: "allergySelected")
      defaults.set(nil, forKey: "petsSelected")
      
      defaults.set(nil, forKey: "address")
      defaults.set(nil, forKey: "apartment")
      defaults.set(nil, forKey: "city")
      defaults.set(nil, forKey: "state")
      defaults.set(nil, forKey: "zip")
      defaults.set(nil, forKey: "parkingInstructions")
      
      do {
        try FIRAuth.auth()?.signOut()
      } catch {
        
      }
      
      userDefaults.set(true, forKey: "hasRunBefore")
      userDefaults.synchronize()
    }
  }
  
  func registerForRemoteNotification(application: UIApplication) {
    // maybe
    if #available(iOS 10, *) {
      let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_,_ in
          print("hello?")
          User.updateUserDeviceToken()
          //          self.updateDeviceToken()
      })
      
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      // For iOS 10 data message (sent via FCM)
      FIRMessaging.messaging().remoteMessageDelegate = self
      application.registerForRemoteNotifications()
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
  }
  
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    FBSDKAppEvents.activateApp()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
}

extension AppDelegate {
  func tokenRefreshNotification(notification: NSNotification) {
    //    updateDeviceToken()
    User.updateUserDeviceToken()
  }
  
  //  func updateDeviceToken() {
  //    if let refreshedToken = FIRInstanceID.instanceID().token() {
  //      if let userId = User.currentUserId {
  //        User.updateUserWith(token: refreshedToken, userId: userId)
  //      }
  //    }
  //  }
}



extension AppDelegate {
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
  }
  
  @available(iOS 10.0, *)
  private func application(_ application: UIApplication, didRegister notificationSettings: UNNotificationSettings) {
    application.registerForRemoteNotifications()//register for push notif after users granted their permission for showing notification
  }
  
  @available(iOS 10.0, *)
  // background, terminated
  @objc(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("coffee from ios 10 methods b, t: \(response.notification.request.content.userInfo)")
    //    if let chatId = response.notification.request.content.userInfo["chatId"] as? String {
    //      print("coffee chatId: \(chatId)")
    //      NotificationCenter.default.post(name: Notification.Name(Constants.RemoteNotification.id), object: chatId)
    //    }
    print("coffee \(isTerminatedState)")
    if !isTerminatedState {
      //      setChatFromPush(userInfo: response.notification.request.content.userInfo as? [String: Any])
      if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
        if
          let chatId = userInfo["chatId"] as? String,
          let userIdTwo = userInfo["toId"] as? String,
          let userNameTwo = userInfo["toName"] as? String
        {
          let data = [
            "chatId": chatId,
            "toId": userIdTwo,
            "toName": userNameTwo
          ]
          
          NotificationCenter.default.post(name: Notification.Name(Constants.RemoteNotification.id), object: data)
        }
      }
    } else {
      isTerminatedState = false
    }
  }
  
  @available(iOS 10.0, *)
  // foreground
  // Receive displayed notifications for iOS 10 devices.
  @objc(userNotificationCenter:willPresentNotification:withCompletionHandler:) func userNotificationCenter(_ center: UNUserNotificationCenter,
                                                                                                           willPresent notification: UNNotification,
                                                                                                           withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
    //    print("from ios 10 methods f: \(notification.request.content.userInfo)")
    //    if let chatId = notification.request.content.userInfo["chatId"] as? String {
    //      print("coffee chatId: \(chatId)")
    //      NotificationCenter.default.post(name: Notification.Name(Constants.RemoteNotification.id), object: chatId)
    //    }
  }
}




















