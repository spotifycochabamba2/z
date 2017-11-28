//
//  AppointmentCell.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/13/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

//static let checkedIn = "checkedIn"
//static let cancelledByUser = "cancelledByUser"
//static let cancelledByPractitioner = "cancelledByPractitioner"

enum CellType {
  case client
  case practitioner
}

class AppointmentCell: UITableViewCell {
  @IBOutlet weak var backgroundTimeView: UIView!
  
  @IBOutlet weak var monthLabel: UILabel! {
    didSet {
      monthLabel.text = ""
    }
  }
  
  @IBOutlet weak var dayNumberLabel: UILabel! {
    didSet {
      dayNumberLabel.text = ""
    }
  }
  
  
  @IBOutlet weak var timeLabel: UILabel! {
    didSet {
      timeLabel.text = ""
    }
  }
  
  
  @IBOutlet weak var practitionerNameLabel: UILabel! {
    didSet {
      practitionerNameLabel.text = ""
    }
  }
  
  
  @IBOutlet weak var addressLabel: UILabel! {
    didSet {
      addressLabel.text = ""
    }
  }
  
  @IBOutlet weak var stateStackView: UIStackView! {
    didSet {
      redEyeImageView?.isHidden = true
      grayAcceptImageView?.isHidden = true
      
      whiteAcceptImageView?.isHidden = true
      redAcceptImageView?.isHidden = true
    }
  }
  
  @IBOutlet weak var redEyeImageView: UIImageView!
  @IBOutlet weak var grayAcceptImageView: UIImageView!
  @IBOutlet weak var redAcceptImageView: UIImageView!
  @IBOutlet weak var whiteAcceptImageView: UIImageView!
  
  @IBOutlet weak var view: UIView!
  
  func initFields(session: Session, type: CellType, state: CellState = CellState.invitedNotAccepted) {
    //    state = CellState(rawValue: session.status)
    //    self.type = type
    //
    //    dayNumber = "\(String(describing: Utils.getDayNumber(date: session.firstAvailabilityDate)!))"
    //
    //    month = Utils.getMonth(date: session.firstAvailabilityDate)
    //    time = Utils.format(time: session.firstAvailabilityStart)
    //    practitionerName = session.clientName
    //
    //    view.layer.cornerRadius = 7.0
    //    view.layer.masksToBounds = true
    //
    //    addressLabel.text = session.getCompleteAddress()
    
    
    
    self.state = CellState(rawValue: session.status)
    self.type = type
    
    var date: Date? = session.firstAvailabilityDate
    var start: Date? = session.firstAvailabilityStart
    
    switch type {
    case .client:
      if let name = session.practitionerName {
        practitionerName = name
        practitionerNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
        backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#087E8A")
      } else {
        practitionerName = "Not Assigned yet."
        practitionerNameLabel.textColor = UIColor.zentaiPrimaryColor
        backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6")
      }
    case .practitioner:
      practitionerName = session.clientName
      practitionerNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
    
    switch state {
    case .invitedNotAccepted:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6")
      break
    case .acceptedAndnotCompleted:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6") //087E8A
      date = session.selectedDate
      start = session.selectedStart
      break
    case .cancelledByPractitioner:
      fallthrough
    case .cancelledByUser:
      fallthrough
    case .checkedIn:
      fallthrough
    case .completedAndPaid:
      fallthrough
    case .completedNotPaid:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#087E8A")
      date = session.selectedDate
      start = session.selectedStart
    }
    
    if
      let date = date,
      let start = start {
      dayNumber = "\(String(describing: Utils.getDayNumber(date: date)!))"
      
      month = Utils.getMonth(date: date)
      time = Utils.format(time: start)
    }
    
    //    if let name = session.practitionerName {
    //      practitionerName = name
    //      practitionerNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    //    } else {
    //      practitionerName = "Not Assigned yet."
    //      practitionerNameLabel.textColor = UIColor.zentaiPrimaryColor
    //    }
    
    
    
    view.layer.cornerRadius = 7.0
    view.layer.masksToBounds = true
    
    address = session.getCompleteAddress()
  }
  
  func setUI(type: CellType, date: Date, start: Date, practitionerName: String, address: String) {
    self.type = type
    
    self.dayNumber = "\(String(describing: Utils.getDayNumber(date: date)!))"
    
    self.month = Utils.getMonth(date: date)
    self.time = Utils.format(time: start)
    self.practitionerName = practitionerName
    
    view.layer.cornerRadius = 7.0
    view.layer.masksToBounds = true
    
    addressLabel.text = address
  }
  
  func initFields(session: UserSession, type: CellType, state: CellState = CellState.invitedNotAccepted) {
    
    self.state = CellState(rawValue: session.status)
    self.type = type
    
    var date = session.selectedDate
    var start = session.selectedDate
    
    switch state {
    case .invitedNotAccepted:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6")
      break
    case .acceptedAndnotCompleted:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6")
      date = session.selectedDate
      start = session.selectedStart
      break
    case .cancelledByPractitioner:
      fallthrough
    case .cancelledByUser:
      fallthrough
    case .checkedIn:
      fallthrough
    case .completedAndPaid:
      fallthrough
    case .completedNotPaid:
      backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#087E8A")
      date = session.selectedDate
      start = session.selectedStart
    }
    
    if
      let date = date,
      let start = start {
      dayNumber = "\(String(describing: Utils.getDayNumber(date: date)!))"
      
      month = Utils.getMonth(date: date)
      time = Utils.format(time: start)
    }
    
    switch type {
    case .client:
      if let name = session.practitionerName {
        practitionerName = name
        practitionerNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
        backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#087E8A")
      } else {
        practitionerName = "Not Assigned yet."
        practitionerNameLabel.textColor = UIColor.zentaiPrimaryColor
        backgroundTimeView.backgroundColor = UIColor.hexStringToUIColor(hex: "#5dbdc6")
      }
      break
      
    case .practitioner:
      practitionerName = session.clientName
      practitionerNameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
      break
    }
    
    
    view.layer.cornerRadius = 7.0
    view.layer.masksToBounds = true
    
    address = session.getCompleteAddress()
  }
  
  var type: CellType?
  
  var state: CellState? = .invitedNotAccepted {
    didSet {
      if let state = state {
        switch state {
        case .cancelledByPractitioner:
          fallthrough
        case .cancelledByUser:
          fallthrough
        case .acceptedAndnotCompleted:
          redEyeImageView?.isHidden = false
          grayAcceptImageView?.isHidden = false
          
          whiteAcceptImageView?.isHidden = true
          redAcceptImageView?.isHidden = true
        case .checkedIn:
          fallthrough
        case .completedNotPaid:
          whiteAcceptImageView?.isHidden = false
          
          redAcceptImageView?.isHidden = true
          redEyeImageView?.isHidden = true
          grayAcceptImageView?.isHidden = true
          
        case .completedAndPaid:
          redAcceptImageView?.isHidden = false
          
          whiteAcceptImageView?.isHidden = true
          redEyeImageView?.isHidden = true
          grayAcceptImageView?.isHidden = true
        case .invitedNotAccepted:
          redEyeImageView?.isHidden = false
          
          whiteAcceptImageView?.isHidden = true
          redAcceptImageView?.isHidden = true
          grayAcceptImageView?.isHidden = true
        }
      } else {
        redEyeImageView?.isHidden = false
        
        whiteAcceptImageView?.isHidden = true
        redAcceptImageView?.isHidden = true
        grayAcceptImageView?.isHidden = true
      }
    }
  }
  
  var month: String = "" {
    didSet {
      monthLabel?.text = month
    }
  }
  var dayNumber: String = "" {
    didSet {
      dayNumberLabel?.text = dayNumber
    }
  }
  var time: String = "" {
    didSet {
      timeLabel?.text = time
    }
  }
  
  var practitionerName: String = "" {
    didSet {
      practitionerNameLabel.text = practitionerName
      
      //      if let type = type {
      //        switch type {
      //        case .client:
      //          if practitionerName.isEmpty {
      //            practitionerNameLabel?.text = "Practitioner not assigned yet."
      //          }
      //        case .practitioner:
      //          break
      //        }
      //      }
    }
  }
  
  var address: String = "" {
    didSet {
      addressLabel?.text = address
    }
  }
}
