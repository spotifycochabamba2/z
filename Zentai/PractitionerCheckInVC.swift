//
//  PractitionerCheckInVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 2/14/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

enum CheckInState {
  case checkedIn
  case finished
}

class PractitionerCheckInVC: UIViewController {
  
  var session: Session?
  var closePractitionerAppointmentVC: () -> Void = {}
  
  var timer = ZentaiTimer()
  var state = CheckInState.checkedIn
  
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var upperView: UIView!
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var finishButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  func close() {
    dismiss(animated: true) {
      self.closePractitionerAppointmentVC()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    backgroundView.backgroundColor = .clear
    
    backgroundView.makeMeBlur()
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
    
    finishButton.makeMeRounded()
    
    timer.start { [weak weakSelf = self] (hours, minutes, seconds) in
      weakSelf?.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Spinner.dismiss()
    timer.stop()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.CheckInToReview {
      let vc = segue.destination as? PractitionerReviewVC
      //      vc?.session = session
      vc?.closePractitionerCheckInVC = close
      
      // from practitioner
      //      var reviewerUsername = ""
      let reviewerUserId = User.currentUserId
      let reviewedUserId = session?.clientId
      //      var reviewedUsername = ""
      let sessionId = session?.id
      
      vc?.reviewerUserId = reviewerUserId
      vc?.reviewedUserId = reviewedUserId
      vc?.sessionId = sessionId
    }
  }
  
  @IBAction func actionButtonTouched() {
    switch state {
    case .checkedIn:
      titleLabel.text = "FINISHED"
      finishButton.setTitle("CHECK OUT", for: .normal)
      state = .finished
      timer.stop()
    case .finished:
      guard let practitionerId = User.currentUserId else {
        let alert = UIAlertController(
          title: "Error",
          message: "Practitioner Id not found.",
          preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default
        ))
        
        present(alert, animated: true)
        return
      }
      
      guard let clientId = session?.clientId else {
        let alert = UIAlertController(
          title: "Error",
          message: "Client Id not found.",
          preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default
        ))
        
        present(alert, animated: true)
        return
      }
      
      guard let sessionId = session?.id else {
        let alert = UIAlertController(
          title: "Error",
          message: "Session Id not found.",
          preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default
        ))
        
        present(alert, animated: true)
        return
      }
      
      Review.sendPushForReview(
        clientId: clientId,
        practitionerId: practitionerId,
        sessionId: sessionId,
        completion: { (error) in
          print(error)
        }
      )
      
      performSegue(withIdentifier: Storyboard.CheckInToReview, sender: nil)
    }
  }
  
}




class ZentaiTimer {
  var timer: Timer!
  var secondsPerformed = 0
  var tick: (_ hours: Int,_ minutes: Int, _ seconds: Int) -> Void = {_,_,_ in }
  
  init() {
    
  }
  
  func start(tick: @escaping (_ hours: Int,_ minutes: Int, _ seconds: Int) -> Void) {
    self.tick = tick
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.notified), userInfo: nil, repeats: true)
    }
    
    //    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.notified), userInfo: nil, repeats: true)
    
  }
  
  
  func stop() {
    timer.invalidate()
  }
  
  @objc func notified() {
    secondsPerformed += 1
    
    let hours = self.secondsPerformed / 3600
    let minutes = (self.secondsPerformed % 3600) / 60
    let seconds = (self.secondsPerformed % 3600) % 60
    
    
    DispatchQueue.main.async {
      self.tick(hours, minutes, seconds)
    }
  }
  
}























