//
//  CancelAppointmentViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/12/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

enum CancelAppointmentViewType {
  case client
  case practitioner
}

class CancelAppointmentViewController: ModalViewController {
  //  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var okButton: UIButton!
  
  //  @IBOutlet weak var titleLabel: UILabel!
  var type = CancelAppointmentViewType.client
  
  var session: Session?
  var closePractitionerAppointmentView: () -> Void = {}
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true, completion: nil)
  }
  
  func isDate(_ date: Date, between beginDate: Date, and endDate: Date) -> Bool {
    if date.compare(beginDate) == .orderedAscending {
      return false
    }
    
    if date.compare(endDate) == .orderedDescending {
      return false
    }
    
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    switch type {
    //    case .client:
    //      titleLabel.text = "Please keep in mind the practitioner will read this."
    //    case .practitioner:
    //      titleLabel.text = "Please keep in mind your client will read this."
    //    }
    
    //    session.first
    
    if let startDate = session?.selectedStart {
      
    }
    
    internalView = view
    rootViewFrame = view.frame
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    //    currentTextField = textView
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    //    addDoneButtonOnKeyboardIn(textView: textView)
    
    blurView.makeMeBlur()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    //    textView.addBottomLine(color: UIColor.zentaiGray)
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  func viewTapped() {
    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func okButtonTouched() {
    let scheduledViewController = presentingViewController as? ScheduledViewController
    let practitionerAppointmentViewController = presentingViewController as? AppointmentResultViewController
    
    print(scheduledViewController)
    print(practitionerAppointmentViewController)
    
    let userId = User.currentUserId
    let sessionId = session?.id
    //    let reason = textView.text ?? ""
    
    if
      let userId = userId,
      let sessionId = sessionId
    {
      var status = ""
      
      switch type {
      case .client:
        status = CellState.cancelledByUser.rawValue
        
        SVProgressHUD.show()
        Session.getInfoOfCancelSession(
          userId: userId,
          sessionId: sessionId,
          completion: { (error, message) in
            DispatchQueue.main.async {
              SVProgressHUD.dismiss()
            }
            
            if let error = error {
              let errorAlert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert)
              
              errorAlert.addAction(
                UIAlertAction(title: "OK",
                              style: .default)
              )
              
              self.present(errorAlert, animated: true)
            } else {
              let infoAlert = UIAlertController(
                title: "CHARGE",
                message: message,
                preferredStyle: .alert)
              
              infoAlert.addAction(
                UIAlertAction(
                  title: "BACK",
                  style: .default)
              )
              
              infoAlert.addAction(
                UIAlertAction(
                  title: "OK",
                  style: .destructive,
                  handler: { (_) in
                    
                    SVProgressHUD.show()
                    Session.cancelSession(
                      userId: userId,
                      sessionId: sessionId,
                      completion: { (error, message) in
                        
                        DispatchQueue.main.async {
                          SVProgressHUD.dismiss()
                        }
                        
                        let alert = UIAlertController(
                          title: "OK",
                          message: "",
                          preferredStyle: .alert)
                        
                        if let error = error {
                          alert.message = error.localizedDescription
                          
                          alert.addAction(UIAlertAction(title: "OK", style: .default))
                        } else {
                          alert.message = message
                          
                          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            DispatchQueue.main.async {
                              self.dismiss(animated: true) {
                                DispatchQueue.main.async {
                                  
                                  print(scheduledViewController)
                                  print(practitionerAppointmentViewController)
                                  
                                  
                                  scheduledViewController?.goHomeScreen()
                                  practitionerAppointmentViewController?.close()
                                }
                              }
                            }
                          }))
                        }
                        
                        self.present(alert, animated: true)
                    })
                })
              )
              
              self.present(infoAlert, animated: true)
            }
          }
        )
      case .practitioner:
        status = CellState.cancelledByPractitioner.rawValue
      }
    }
    
    
  }
  
}

extension CancelAppointmentViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}






