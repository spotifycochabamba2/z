//
//  HomeViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/25/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import Ax

class HomeViewController: UIViewController {
  @IBOutlet weak var bookButton: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var currentUser: User!
  
  var comesFromPushNotification = false
  var handlerId: UInt = 0
  var label = UILabel(frame: CGRect(x: 10, y: -10, width: 20, height: 20))
  
  // Tutorial properties
  var pageContainer: UIPageViewController!
  var currentIndex = 0
  var pendingIndex = 0
  var tutorialViewControllers = [UIViewController]()
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let userId = currentUser?.id {
      User.removeHandler(id: handlerId, userId: userId)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Spinner.dismiss()
    
    Ax.serial(tasks: [
      { done in
        self.handlerId = User.getCurrentUser(once: false, navigationController: self.navigationController, completion: { (user) in
          if let user = user {
            self.currentUser = user
            done(nil)
          } else{
            done(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user found."]))
          }
        })
      },
      { done in
        Message.getNotifications(userId: self.currentUser.id!) { (notifications) in
          if notifications > 0 {
            DispatchQueue.main.async {
              self.label.isHidden = false
              self.label.text = "\(notifications)"
            }
          } else {
            DispatchQueue.main.async {
              self.label.isHidden = true
            }
          }
        }
      }
    ]) { (error) in
      
    }
  }
  
  func remoteNotificationPassed(notification: Notification) {
    if let data = notification.object as? [String: Any] {
      comesFromPushNotification = true
      showChat(data)
    }
  }
  
  func showChat(_ data: [String: Any]) {
    //    print("coffee showCat method called with \(chatId)")
    
    var currentViewControllerToDismiss = self.presentedViewController
    var viewControllersToDismiss = [UIViewController]()
    
    while(currentViewControllerToDismiss != nil) {
      viewControllersToDismiss.append(currentViewControllerToDismiss!)
      currentViewControllerToDismiss = currentViewControllerToDismiss?.presentedViewController
    }
    
    var vc = viewControllersToDismiss.popLast()
    while(vc != nil) {
      vc?.dismiss(animated: false, completion: nil)
      vc = viewControllersToDismiss.popLast()
    }
    
    _ = self.navigationController?.popToViewController(self, animated: false)
    
    
    performSegue(withIdentifier: Storyboard.HomeToInbox, sender: data)
    
    
    //    let inboxVC = self.storyboard?.instantiateViewController(withIdentifier: "InboxVC")
    //    let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController")
    ////    let chatNVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatNavigationViewController")
    //    let chatNVC = UINavigationController(rootViewController: chatVC!)
    //
    //    print(inboxVC)
    //    print(chatNVC)
    //
    //    navigationController?.pushViewController(inboxVC!, animated: false)
    //    inboxVC?.present(chatNVC, animated: true, completion: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.RemoteNotification.id), object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pageControl.isUserInteractionEnabled = false
    pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    //    pageControl.pageIndicatorTintColor = UIColor.hexStringToUIColor(hex: "#9f1a39")
    
    pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    pageContainer.dataSource = self
    pageContainer.delegate = self
    
    let tutorialOne = self.getTutorialViewController(name: "TutorialOneVC")
    let tutorialTwo = self.getTutorialViewController(name: "TutorialTwoVC")
    let tutorialThree = self.getTutorialViewController(name: "TutorialThreeVC")
    
    tutorialViewControllers.append(tutorialOne)
    tutorialViewControllers.append(tutorialTwo)
    tutorialViewControllers.append(tutorialThree)
    
    pageContainer.setViewControllers([tutorialOne], direction: .forward, animated: true, completion: nil)
    
    view.addSubview(pageContainer.view)
    view.bringSubview(toFront: pageControl)
    view.bringSubview(toFront: bookButton)
    
    pageControl.numberOfPages = tutorialViewControllers.count
    pageControl.currentPage = 0
    
    self.label.isHidden = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(remoteNotificationPassed), name: Notification.Name(Constants.RemoteNotification.id), object: nil)
    
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
      comesFromPushNotification = true
      showChat([
        "chatId": chatId,
        "toId": toId,
        "toName": toName
        ])
    }
    
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.isTranslucent = true
    
    //    self.navigationController?.navigationBar.backgroundColor = .clear
    //    self.navigationController?.view.backgroundColor = .clear
    
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.isHidden = false
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = ""
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    // badge for right button
    //    label = UILabel(frame: CGRect(x: 10, y: -10, width: 20, height: 20))
    label.layer.borderColor = UIColor.clear.cgColor
    label.layer.borderWidth = 2
    label.layer.cornerRadius = label.bounds.size.height / 2
    label.textAlignment = .center
    label.layer.masksToBounds = true
    label.font = UIFont(name: "SanFranciscoText-Light", size: 13)
    label.textColor = .white
    label.backgroundColor = Utils.hexStringToUIColor(hex: "#ff5a60")
    label.text = "80"
    
    
    // set header right button 18x16
    let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 23))
    rightButton.setImage(UIImage(named: "inbox"), for: .normal)
    //    rightButton.setBackgroundImage(UIImage(named: "inbox"), for: .normal)
    rightButton.imageView?.contentMode = .scaleAspectFit
    rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)
    rightButton.addSubview(label)
    
    let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
    navigationItem.rightBarButtonItem = rightBarButtomItem
    
    
    // set header left button
    let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 17)) //38x26
    leftButton.setBackgroundImage(UIImage(named: "user-profile"), for: .normal)
    leftButton.addTarget(self, action: #selector(leftButtonTouched), for: .touchUpInside)
    let leftBarButtonItem = UIBarButtonItem()
    leftBarButtonItem.customView = leftButton
    navigationItem.leftBarButtonItem = leftBarButtonItem
    
    bookButton.makeMeRounded()
  }
  
  func rightButtonTouched() {
    print("right button touched")
    performSegue(withIdentifier: Storyboard.HomeToInbox, sender: nil)
  }
  
  func leftButtonTouched() {
    print("left button touched")
    performSegue(withIdentifier: Storyboard.HomeToProfile, sender: nil)
  }
  
  func viewAppointment(with session: Session) {
    performSegue(withIdentifier: Storyboard.HomeToAppointment, sender: session)
  }
  
  func dismiss() {
    //    self.dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.HomeToAppointment {
      let appointmentViewController = segue.destination as? AppointmentResultViewController
      appointmentViewController?.session = sender as? Session
    } else if segue.identifier == Storyboard.HomeToBooking {
      let bookingViewController = segue.destination as? BookingViewController
      bookingViewController?.viewAppointmentViewController = viewAppointment
    } else if segue.identifier == Storyboard.HomeToInbox {
      let vc = segue.destination as? InboxVC
      vc?.comesFromPushNotification = comesFromPushNotification
      vc?.dataFromPushnotification = sender as? [String: Any]
    }
    
    comesFromPushNotification = false
  }
  
  @IBAction func bookButtonTouched() {
    //    if let vc = UIStoryboard(name: "Booking", bundle: nil).instantiateViewController(withIdentifier: "BookingViewController") as? InteractiveViewController {
    //
    //      vc.allowedDismissDirection = .bottom
    //      vc.directionLock = false
    //
    //      vc.showInteractive()
    //    }
    performSegue(withIdentifier: Storyboard.HomeToBooking, sender: nil)
  }
  
  
  //    showIn
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func getTutorialViewController(name: String) -> UIViewController {
    return UIStoryboard(name: "Tutorials", bundle: nil) .
      instantiateViewController(withIdentifier: "\(name)")
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    pendingIndex = tutorialViewControllers.index(of: pendingViewControllers.first!)!
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      pageControl.currentPage = pendingIndex
    }
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return tutorialViewControllers.count
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let currentIndex = tutorialViewControllers.index(of: viewController)
    
    if currentIndex == 0 {
      return nil
    }
    
    let previousIndex = abs((currentIndex! - 1) % tutorialViewControllers.count)
    return tutorialViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let currentIndex = tutorialViewControllers.index(of: viewController)
    
    if currentIndex == (tutorialViewControllers.count - 1) {
      return nil
    }
    
    let nextIndex = abs((currentIndex! + 1) % tutorialViewControllers.count)
    return tutorialViewControllers[nextIndex]
  }
}































