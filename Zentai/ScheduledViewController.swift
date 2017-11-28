//
//  ScheduledViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/29/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

class ScheduledViewController: ModalViewController {
  @IBOutlet weak var cancelAppointmentButton: UIButton!
  @IBOutlet weak var firstScheduleStackView: UIStackView!
  @IBOutlet weak var secondScheduleStackView: UIStackView!
  @IBOutlet weak var thirdScheduleStackView: UIStackView!
  
  @IBOutlet weak var firstDateLabel: UILabel!
  @IBOutlet weak var secondDateLabel: UILabel!
  @IBOutlet weak var thirdDateLabel: UILabel!
  
  @IBOutlet weak var firstTimeLabel: UILabel!
  @IBOutlet weak var secondTimeLabel: UILabel!
  @IBOutlet weak var thirdTimeLabel: UILabel!
  
  var session: Session?
  
  @IBOutlet weak var viewAppointmentButton: UIButton!
  
  @IBOutlet weak var middleView: UIView!
  //  @IBOutlet weak var dateView: UIView!
  
  //  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var homeLabel: UILabel!
  @IBOutlet weak var scheduledLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
  
  //  @IBOutlet weak var dayLabel: UILabel!
  //  @IBOutlet weak var dateLabel: UILabel!
  //  @IBOutlet weak var monthLabel: UILabel!
  
  var bookingViewController: BookingViewController?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bookingViewController = presentingViewController as? BookingViewController
    
    if let session = session {
      scheduledLabel.text = "60-minute Acupuncture Session"
      //      timerLabel.text = "\(Utils.format(time: session.firstAvailabilityStart)) - \(Utils.format(time: session.firstAvailabilityEnd))"
      
      //      dayLabel.text = Utils.getDayOfWeek(date: session.firstAvailabilityDate)
      //      monthLabel.text = Utils.getMonth(date: session.firstAvailabilityDate)
      //      dateLabel.text = "\(Utils.getDayNumber(date: session.firstAvailabilityDate)!)"
      print(session.getCompleteAddress())
      homeLabel.text = session.getCompleteAddress()
      //      homeLabel.text = "\(session.address), \(session.state) \(session.zip)"
      userLabel.text = "Waiting for practitioner"
      
      let firstDate = Utils.format(date: session.firstAvailabilityDate)
      let firstStartTime = Utils.format(time: session.firstAvailabilityStart)
      let firstEndTime = Utils.format(time: session.firstAvailabilityEnd)
      
      firstDateLabel.text = firstDate
      firstTimeLabel.text = "\(firstStartTime) - \(firstEndTime)"
      
      if
        let secondAvailabilityDate = session.secondAvailabilityDate,
        let secondAvailabilityStart = session.secondAvailabilityStart,
        let secondAvailabilityEnd = session.secondAvailabilityEnd
      {
        let secondDate = Utils.format(date: secondAvailabilityDate)
        let secondStartTime = Utils.format(time: secondAvailabilityStart)
        let secondEndTime = Utils.format(time: secondAvailabilityEnd)
        
        secondDateLabel.text = secondDate
        secondTimeLabel.text = "\(secondStartTime) - \(secondEndTime)"
        
        secondScheduleStackView.isHidden = false
      } else {
        secondScheduleStackView.isHidden = true
      }
      
      if
        let thirdAvailabilityDate = session.thirdAvailabilityDate,
        let thirdAvailabilityStart = session.thirdAvailabilityStart,
        let thirdAvailabilityEnd = session.thirdAvailabilityEnd
      {
        let thirdDate = Utils.format(date: thirdAvailabilityDate)
        let thirdStartTime = Utils.format(time: thirdAvailabilityStart)
        let thirdEndTime = Utils.format(time: thirdAvailabilityEnd)
        
        thirdDateLabel.text = thirdDate
        thirdTimeLabel.text = "\(thirdStartTime) - \(thirdEndTime)"
        
        thirdScheduleStackView.isHidden = false
      } else {
        thirdScheduleStackView.isHidden = true
      }
    }
    
    print(session)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    middleView.makeMeRounded()
    //    dateView.makeMeRounded()
    
    viewAppointmentButton.makeMeRounded()
  }
  
  func goHomeScreen() {
    dismiss(animated: true) {
      self.bookingViewController?.goBackHome()
    }
  }
  
  override func dismissed() {
    super.dismissed()
    
    //    if let session = session {
    //      bookingViewController?.goBackHome(with: session)
    //    }
    bookingViewController?.goBackHome()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.ScheduledToAppointmentResult {
      let appointmentViewController = segue.destination as? AppointmentResultViewController
      appointmentViewController?.session = sender as? Session
    } else if segue.identifier == Storyboard.ScheduledToCancelAppointment {
      let vc = segue.destination as? CancelAppointmentViewController
      vc?.session = self.session
    }
  }
  
  @IBAction func viewAppointmentTouched() {
    //    dismiss(animated: true) {
    //      if let session = self.session {
    //        self.bookingViewController?.goBackHome(with: session)
    //      }
    //    }
    
    if let session = self.session {
      performSegue(withIdentifier: Storyboard.ScheduledToAppointmentResult, sender: session)
    }
  }
  
  
  @IBAction func cancelAppointmentTouched() {
    performSegue(withIdentifier: Storyboard.ScheduledToCancelAppointment, sender: nil)
  }
  
  @IBAction func close() {
    goHomeScreen()
  }
}































