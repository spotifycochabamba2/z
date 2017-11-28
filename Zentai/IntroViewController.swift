//
//  ViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/18/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import Ax

class IntroViewController: UIViewController {
  
  @IBOutlet weak var pageControl: UIPageControl!
  
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var signinButton: UIButton!
  
  // Tutorial properties
  var pageContainer: UIPageViewController!
  var currentIndex = 0
  var pendingIndex = 0
  var tutorialViewControllers = [UIViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pageControl.isUserInteractionEnabled = false
    pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    
    pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    pageContainer.dataSource = self
    pageContainer.delegate = self
    
    let tutorialIntro = self.getTutorialViewController(name: "IntroVC")
    let tutorialOne = self.getTutorialViewController(name: "TutorialOneVC")
    let tutorialTwo = self.getTutorialViewController(name: "TutorialTwoVC")
    let tutorialThree = self.getTutorialViewController(name: "TutorialThreeVC")
    
    tutorialViewControllers.append(tutorialIntro)
    tutorialViewControllers.append(tutorialOne)
    tutorialViewControllers.append(tutorialTwo)
    tutorialViewControllers.append(tutorialThree)
    
    pageContainer.setViewControllers([tutorialIntro], direction: .forward, animated: true, completion: nil)
    
    view.addSubview(pageContainer.view)
    view.sendSubview(toBack: pageContainer.view)
    
    pageControl.numberOfPages = tutorialViewControllers.count
    pageControl.currentPage = 0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    
    configureButtons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    
    //    self.performSegue(withIdentifier: Storyboard.IntroToPractitionerHome, sender: nil)
    
    // remove this code
    //    if FIRAuth.auth()?.currentUser != nil {
    //      // get user from firbase based on FIRAuth uid
    //      // then ask if user has the role of
    //      // - practitioner
    //      // - client
    //      // then go its respective screen
    //      self.performSegue(withIdentifier: Storyboard.IntroToHome, sender: nil)
    //    }
    //
    //    User.logout()
    
    if User.isUserLoggedIn {
      
      //      SVProgressHUD.show(UIImage(named: "logo-ls"), status: "Loading")
      Spinner.showZentaiSpinner(currentViewController: self)
      User.updatePushNotificationField()
      
      
      User.getRole(from: User.currentUserId!, completion: { (role) in
        Spinner.dismiss()
        //        SVProgressHUD.dismiss()
        
        if let role = role {
          
          switch role {
          case .client:
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: Storyboard.IntroToHome, sender: nil)
            }
          case .practitioner:
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: Storyboard.IntroToPractitionerHome, sender: nil)
            }
          }
          
        } else {
          let alert = UIAlertController(title: "Info", message: "Something happened, please log in again.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
          }
        }
      })
    }
  }
  
  
  @IBAction func signupButtonTouched() {
  }
  
  
  @IBAction func signinButtonTouched() {
  }
}



extension IntroViewController {
  func configureButtons() {
    signupButton.makeMeRounded()
    signinButton.makeMeRounded()
  }
}


extension IntroViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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















































