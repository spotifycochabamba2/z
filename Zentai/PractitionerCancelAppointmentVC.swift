//
//  PractitionerCancelAppointmentVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 8/3/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

public class PractitionerCancelAppointmentVC: UIViewController {
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var cancelButton: UIButton!
  
  var sessionId: String!
  var clientId: String!
}

extension PractitionerCancelAppointmentVC {
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    backgroundView.backgroundColor = .clear
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    backgroundView.makeMeBlur()
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
    cancelButton.makeMeRounded()
  }
}

extension PractitionerCancelAppointmentVC {
  @IBAction func cancelButtonTouched() {
    let appointmentDetailVC = presentingViewController as? PractitionerAppointmentVC
    
    SVProgressHUD.show()
    Session.cancelSession(
      userId: clientId,
      sessionId: sessionId,
      isPractitionerWhoCancelled: true) { (error, _) in
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        if let error = error {
          let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
          ))
          
          self.present(alert, animated: true)
        } else {
          
          self.dismiss(animated: true, completion: {
            appointmentDetailVC?.close()
          })
        }
    }
  }
  
  @IBAction func closeIconTouched() {
    dismiss(animated: true)
  }
}







































