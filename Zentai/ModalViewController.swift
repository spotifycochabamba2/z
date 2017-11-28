//
//  ModalViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/22/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit


class ModalViewController: UIViewController {
  var rootViewFrame: CGRect?
  var internalView: UIView?
  
  var currentTextField: UIView?
  
  @IBOutlet weak var constraint: NSLayoutConstraint?
  
  var panGestureRecognizer: UIPanGestureRecognizer?
  var originalPosition: CGPoint?
  var currentPositionTouched: CGPoint?
  
  var areaPannable: CGFloat {
    return view.frame.size.height
  }
  
  func wentUp() {
    
  }
  
  func wentDown() {
    
  }
  
  func dismissed() {
    
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    modalPresentationCapturesStatusBarAppearance = true
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
    view.addGestureRecognizer(panGestureRecognizer!)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }
  
  func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
    let translation = panGesture.translation(in: view)
    
    if panGesture.state == .began {
      originalPosition = view.center
      currentPositionTouched = panGesture.location(in: view)
    } else if panGesture.state == .changed {
      if currentPositionTouched!.y <= areaPannable {
        view.frame.origin = CGPoint(
          x: translation.x,
          y: translation.y
        )
      }
    } else if panGesture.state == .ended {
      let velocity = panGesture.velocity(in: view)
      
      if currentPositionTouched!.y <= areaPannable && velocity.y >= 1500 {
        UIView.animate(withDuration: 0.2
          , animations: {
            self.view.frame.origin = CGPoint(
              x: self.view.frame.origin.x,
              y: self.view.frame.size.height
            )
          }, completion: { (isCompleted) in
            if isCompleted {
              self.dismiss(animated: false, completion: {
                self.dismissed()
              })
            }
        })
      } else if currentPositionTouched!.y >= areaPannable && velocity.y >= 1500 {
        wentDown()
      } else if currentPositionTouched!.y >= areaPannable && velocity.y <= -1500 {
        wentUp()
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.view.center = self.originalPosition!
        })
      }
    }
  }
  
  
  func keyboardWillBeHidden(notification: Notification) {
    if let rootViewFrame = rootViewFrame {
      internalView?.frame = rootViewFrame
    }
  }
  
  func keyboardWillBeShown(notification: Notification) {
    let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    if let textField = currentTextField {
      let newFrame = textField.convert(textField.bounds, to: internalView)
      let keyboardHeight = keyboardRect!.origin.y - 50 //100
      let resultHeight2 = unabs(keyboardHeight - newFrame.origin.y)
      var frame = rootViewFrame!
      frame.origin.y += resultHeight2
      
      //if resultHeight2 < 0 {
        internalView?.frame = frame
      //}
    }
  }
  
  func unabs(_ value: CGFloat) -> CGFloat {
    return value > 0 ? value * -1 : value
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
}













