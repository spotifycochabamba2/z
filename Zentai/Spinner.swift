//
//  Spinner.swift
//  zentai
//
//  Created by Wilson Balderrama on 4/11/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
// Spinner.show(currentViewController: self)
// Spinner.dismiss()

struct Spinner {
  static var viewController: UIViewController? = {
    if let vc = UIStoryboard(name: "Spinner", bundle: nil).instantiateViewController(withIdentifier: "SpinnerVC") as? SpinnerVC {
      return vc
    } else {
      return nil
    }
  }()
  
  static var viewControllers = [UIViewController]()
  
  static var currentViewController: UIViewController?
  
  
  static func show(currentViewController: UIViewController) {
    //    self.currentViewController = currentViewController
    //    self.viewControllers.append(currentViewController)
    //
    //    if let viewController = viewController {
    //      viewController.modalPresentationStyle = .overCurrentContext
    //      currentViewController.modalPresentationStyle = .overCurrentContext
    //      currentViewController.navigationController?.modalPresentationStyle = .overCurrentContext
    ////      currentViewController.modalPresentationStyle = .currentContext
    //      currentViewController.present(viewController, animated: true, completion: nil)
    //    }
    
    SVProgressHUD.show()
  }
  
  static func showZentaiSpinner(currentViewController: UIViewController) {
    self.currentViewController = currentViewController
    self.viewControllers.append(currentViewController)
    
    if let viewController = viewController {
      viewController.modalPresentationStyle = .overCurrentContext
      currentViewController.modalPresentationStyle = .overCurrentContext
      currentViewController.navigationController?.modalPresentationStyle = .overCurrentContext
      //      currentViewController.modalPresentationStyle = .currentContext
      currentViewController.present(viewController, animated: true, completion: nil)
    }
  }
  
  static func dismiss() {
    //    viewControllers.forEach { vc in
    //      DispatchQueue.main.async {
    //        vc.dismiss(animated: true, completion: nil)
    //      }
    //    }
    
    DispatchQueue.main.async {
      currentViewController?.dismiss(animated: true, completion: nil)
      currentViewController = nil
      SVProgressHUD.dismiss()
    }
  }
}
