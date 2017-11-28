//
//  InvitationDetailVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/11/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftLocation

enum ScheduleSelected {
  case first, second, third
}

// outlets, properties
class InvitationDetailVC: ModalViewController {
  var currentSession: Session?
  var currentUser: User?
  var getServerDataOnPractitionerHome: () -> Void = { }
  var deselectCurrentRow: () -> Void = { }
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  
  @IBOutlet weak var startsView: StartsView!
  
  @IBOutlet weak var acceptButton: UIButton!
  @IBOutlet weak var declineButton: UIButton!
  
  @IBOutlet weak var clientNameLabel: UILabel!
  
  @IBOutlet weak var firstCalendarImageView: UIImageView! {
    didSet {
      
    }
  }
  
  @IBOutlet weak var firstWatchImageView: UIImageView! {
    didSet {
      
    }
  }
  
  @IBOutlet weak var secondCalendarImageView: UIImageView!
  @IBOutlet weak var secondWatchImageView: UIImageView!
  
  @IBOutlet weak var thirdCalendarImageView: UIImageView!
  @IBOutlet weak var thirdWatchImageView: UIImageView!
  
  @IBOutlet weak var firstScheduleStackView: UIStackView!
  @IBOutlet weak var secondScheduleStackView: UIStackView!
  @IBOutlet weak var thirdScheduleStackView: UIStackView!
  
  @IBOutlet weak var firstDateLabel: UILabel!
  @IBOutlet weak var secondDateLabel: UILabel!
  @IBOutlet weak var thirdDateLabel: UILabel!
  
  @IBOutlet weak var firstTimeLabel: UILabel!
  @IBOutlet weak var secondTimeLabel: UILabel!
  @IBOutlet weak var thirdTimeLabel: UILabel!
  
  var scheduleSelected: ScheduleSelected? {
    didSet {
      if let selection = scheduleSelected {
        switch selection {
        case .first:
          firstCalendarImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
          secondCalendarImageView.backgroundColor = .clear
          thirdCalendarImageView.backgroundColor = .clear
          
          firstWatchImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
          secondWatchImageView.backgroundColor = .clear
          thirdWatchImageView.backgroundColor = .clear
        case .second:
          firstCalendarImageView.backgroundColor = .clear
          secondCalendarImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
          thirdCalendarImageView.backgroundColor = .clear
          
          firstWatchImageView.backgroundColor = .clear
          secondWatchImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
          thirdWatchImageView.backgroundColor = .clear
        case .third:
          firstCalendarImageView.backgroundColor = .clear
          secondCalendarImageView.backgroundColor = .clear
          thirdCalendarImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
          
          
          firstWatchImageView.backgroundColor = .clear
          secondWatchImageView.backgroundColor = .clear
          thirdWatchImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "#E09C32")
        }
      }
    }
  }
  
  
  @IBOutlet weak var detailsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  var maskPathOK: UIBezierPath!
  var maskLayerOK: CAShapeLayer!
  
  @IBOutlet weak var ratingStackView: UIStackView!
  
  var maskPathCancel: UIBezierPath!
  var maskLayerCancel: CAShapeLayer!
}

// Custom Methods
extension InvitationDetailVC {
  
  
  
  func setupSessionInfo() {
    if let currentSession = currentSession {
      
      //      Spinner.show(currentViewController: self)
      ////      SVProgressHUD.show()
      //      _ = User.getUser(by: currentSession.clientId, once: true, completion: { [weak weakSelf = self] (user) in
      //
      //        Spinner.dismiss()
      //        DispatchQueue.main.async {
      ////          weakSelf?.startsView.rate = UInt(user?.rating ?? 0)
      ////          weakSelf?.startsView.rate =
      //
      //        }
      //      })
      
      Spinner.show(currentViewController: self)
      Review.getTotalReviews(
        userId: currentSession.clientId,
        completion: { [weak self] (error, rate) in
          Spinner.dismiss()
          
          if error === nil {
            DispatchQueue.main.async {
              self?.startsView.rate = UInt(rate)
            }
          }
        }
      )
      
      let clientName = currentSession.clientName
      
      //      let date = Utils.format(date: currentSession.firstAvailabilityDate)
      //      let startTime = Utils.format(time: currentSession.firstAvailabilityStart)
      //      let endTime = Utils.format(time: currentSession.firstAvailabilityEnd)
      //
      //      dateLabel.text = date
      //      timeLabel.text = "\(startTime) - \(endTime)"
      
      let firstDate = Utils.format(date: currentSession.firstAvailabilityDate)
      let firstStartTime = Utils.format(time: currentSession.firstAvailabilityStart)
      let firstEndTime = Utils.format(time: currentSession.firstAvailabilityEnd)
      
      firstDateLabel.text = firstDate
      firstTimeLabel.text = "\(firstStartTime) - \(firstEndTime)"
      
      if currentSession.secondAvailabilityDate == nil ||
        currentSession.thirdAvailabilityDate == nil {
        firstScheduleStackView.isUserInteractionEnabled = false
        scheduleSelected = .first
      }
      
      if
        let secondAvailabilityDate = currentSession.secondAvailabilityDate,
        let secondAvailabilityStart = currentSession.secondAvailabilityStart,
        let secondAvailabilityEnd = currentSession.secondAvailabilityEnd
      {
        let secondDate = Utils.format(date: secondAvailabilityDate)
        let secondStartTime = Utils.format(time: secondAvailabilityStart)
        let secondEndTime = Utils.format(time: secondAvailabilityEnd)
        
        secondDateLabel.text = secondDate
        secondTimeLabel.text = "\(secondStartTime) - \(secondEndTime)"
        
        secondScheduleStackView.isHidden = false
      }
      
      if
        let thirdAvailabilityDate = currentSession.thirdAvailabilityDate,
        let thirdAvailabilityStart = currentSession.thirdAvailabilityStart,
        let thirdAvailabilityEnd = currentSession.thirdAvailabilityEnd
      {
        let thirdDate = Utils.format(date: thirdAvailabilityDate)
        let thirdStartTime = Utils.format(time: thirdAvailabilityStart)
        let thirdEndTime = Utils.format(time: thirdAvailabilityEnd)
        
        thirdDateLabel.text = thirdDate
        thirdTimeLabel.text = "\(thirdStartTime) - \(thirdEndTime)"
        
        thirdScheduleStackView.isHidden = false
      }
      
      
      let gender = PracticionerGender(rawValue: currentSession.practitionerGender)?.toString() ?? ""
      let allergies = OilAllergies(rawValue: currentSession.oilAllergy ?? "N")?.toString() ?? ""
      let pets = Pets(rawValue: currentSession.anyPets)?.toString() ?? ""
      
      //      let address = "\(currentSession.address)\n\(currentSession.city), \(currentSession.state) \(currentSession.zip)"
      
      clientNameLabel.text = clientName
      
      detailsLabel.text = "60-minute Acupuncture Session \n\(gender), \(allergies), \(pets)"
      addressLabel.text = currentSession.getCompleteAddress()
    }
  }
}

// Actions
extension InvitationDetailVC {
  @IBAction func okButtonTouched() {
    
    guard
      let scheduleSelected = scheduleSelected else {
        let alert = UIAlertController(title: "Error", message: "Please first select a time tapping on one of them", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak weakSelf = self] _ in
          weakSelf?.deselectCurrentRow()
          }))
        present(alert, animated: true, completion: nil)
        return
    }
    
    guard
      let practitionerId = User.currentUserId,
      let sessionId = currentSession?.id,
      let practitionerFirstName = currentUser?.firstName,
      let clientId = currentSession?.clientId,
      let session = currentSession
      else {
        let alert = UIAlertController(title: "Info", message: "Something happened, unable to get practitioner id or session id or practitioner first name or client id, log in again please.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak weakSelf = self] _ in
          weakSelf?.deselectCurrentRow()
          }))
        present(alert, animated: true, completion: nil)
        return
    }
    
    var selectedDate: Double?
    var selectedEndTime: Double?
    var selectedStartTime: Double?
    
    switch scheduleSelected {
    case .first:
      selectedDate = session.firstAvailabilityDate.timeIntervalSince1970
      selectedStartTime = session.firstAvailabilityStart.timeIntervalSince1970
      selectedEndTime = session.firstAvailabilityEnd.timeIntervalSince1970
    case .second:
      selectedDate = session.secondAvailabilityDate!.timeIntervalSince1970
      selectedStartTime = session.secondAvailabilityStart!.timeIntervalSince1970
      selectedEndTime = session.secondAvailabilityEnd!.timeIntervalSince1970
    case .third:
      selectedDate = session.thirdAvailabilityDate!.timeIntervalSince1970
      selectedStartTime = session.thirdAvailabilityStart!.timeIntervalSince1970
      selectedEndTime = session.thirdAvailabilityEnd!.timeIntervalSince1970
    }
    
    let practitionerName = "\(practitionerFirstName) \(currentUser?.lastName ?? "")"
    
    
    Spinner.show(currentViewController: self)
    //    SVProgressHUD.show()
    
    UserSession.acceptInvitation(
      practitionerId: practitionerId,
      practitionerName: practitionerName,
      clientId: clientId,
      sessionId: sessionId,
      selectedDate: selectedDate!,
      selectedStartTime: selectedStartTime!,
      selectedEndTime: selectedEndTime!
    ) { [weak weakSelf = self] (result) in
      Spinner.dismiss()
      
      switch result {
      case .fail(let error):
        let alert = UIAlertController(title: "Info", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
          weakSelf?.dismiss(animated: true, completion: {
            weakSelf?.deselectCurrentRow()
          })
        }))
        weakSelf?.present(alert, animated: true, completion: nil)
      case .success(let commited, let message):
        //        var message = ""
        //
        //        if commited {
        //          message = "Congratulations, you've just accept the session"
        //        } else {
        //          message = "Sorry, someone else accepted the session before you, try accepting other sessions."
        //        }
        
        var favorite = [String: Any]()
        favorite["id"]  = practitionerId
        favorite["username"] = practitionerName
        favorite["profileURL"] = weakSelf?.currentUser?.profileURL
        
        User.addFavorites(to: favorite, for: clientId, completion: { (error) in
          print(error)
        })
        
        let alert = UIAlertController(title: "Congratulations", message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.zentaiPrimaryColor
        alert.addAction(UIAlertAction(title: "Thanks", style: .default, handler: { _ in
          weakSelf?.dismiss(animated: true, completion: {
            weakSelf?.deselectCurrentRow()
          })
          
          weakSelf?.getServerDataOnPractitionerHome()
        }))
        
        weakSelf?.present(alert, animated: true)
      }
    }
  }
  
  @IBAction func declineButtonTouched() {
    guard
      let practitionerId = User.currentUserId,
      let sessionId = currentSession?.id,
      let sessionExpirationDate = currentSession?.firstAvailabilityDate
      else
    {
      let alert = UIAlertController(title: "Info", message: "Something happened, unable to get practitioner id and session id, log in again please.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak weakSelf = self] _ in
        weakSelf?.deselectCurrentRow()
        }))
      present(alert, animated: true, completion: nil)
      return
    }
    
    UserSession.declineInvitation(
      practitionerId: practitionerId,
      sessionId: sessionId,
      sessionExpirationDate: sessionExpirationDate) { [weak weakSelf = self] (error) in
        if let error = error {
          let alert = UIAlertController(title: "Info", message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak weakSelf = self] _ in
            weakSelf?.deselectCurrentRow()
            }))
          
          weakSelf?.present(alert, animated: true, completion: nil)
        } else {
          weakSelf?.dismiss(animated: true, completion: {
            weakSelf?.deselectCurrentRow()
          })
          
          weakSelf?.getServerDataOnPractitionerHome()
        }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.InvitationDetailToMap {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers.first as? AddressMapVC
      
      vc?.sessionLocation = currentSession?.location
    } else if segue.identifier == Storyboard.InvitationDetailToReviews {
      
      let vc = segue.destination as? PractitionerReviewsVC
      vc?.modalPresentationCapturesStatusBarAppearance = true
      vc?.session = currentSession
    }
  }
  
  @IBAction func locationButtonTouched() {
    //    if let _ = currentSession?.location {
    //      performSegue(withIdentifier: Storyboard.InvitationDetailToMap, sender: nil)
    //    }
    if let currentLocation = currentSession?.location {
      //      SVProgressHUD.show()
      Spinner.show(currentViewController: self)
      DispatchQueue.main.async {
        _ = Location.getLocation(
          withAccuracy: .city,
          frequency: .oneShot,
          onSuccess: { (location) in
            Spinner.dismiss()
            
            print(currentLocation)
            print(location.coordinate)
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
              let urlString = Utils.getGoogleMapURL(
                startLocation: currentLocation,
                endLocation: (
                  latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude
                )
              )
              
              UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            } else {
              let urlString = Utils.getAppleMapURL(
                startLocation: currentLocation,
                endLocation: (
                  latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude
                )
              )
              
              UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            }
        }) { (lastValidationLocation, error) in
          print(error)
        }
      }
    }
  }
  
  @IBAction func closeView() {
    dismiss(animated: true, completion: { [weak weakSelf = self] in
      print(weakSelf)
      weakSelf?.deselectCurrentRow()
      })
  }
}


// View Controller Life cycle events
extension InvitationDetailVC {
  
  func stackViewTapped() {
    performSegue(withIdentifier: Storyboard.InvitationDetailToReviews, sender: nil)
  }
  
  func firstScheduleStackViewTapped() {
    print("firstScheduleStackViewTapped called")
    scheduleSelected = .first
    
  }
  
  func secondScheduleStackViewTapped() {
    print("secondScheduleStackViewTapped called")
    scheduleSelected = .second
  }
  
  func thirdScheduleStackViewTapped() {
    print("thirdScheduleStackViewTapped called")
    scheduleSelected = .third
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let firstScheduleStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstScheduleStackViewTapped))
    firstScheduleStackViewTapGesture.numberOfTapsRequired = 1
    firstScheduleStackViewTapGesture.numberOfTouchesRequired = 1
    firstScheduleStackView.addGestureRecognizer(firstScheduleStackViewTapGesture)
    firstScheduleStackView.isUserInteractionEnabled = true
    
    let secondScheduleStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondScheduleStackViewTapped))
    secondScheduleStackViewTapGesture.numberOfTouchesRequired = 1
    secondScheduleStackViewTapGesture.numberOfTapsRequired = 1
    secondScheduleStackView.addGestureRecognizer(secondScheduleStackViewTapGesture)
    secondScheduleStackView.isUserInteractionEnabled = true
    
    let thirdScheduleStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(thirdScheduleStackViewTapped))
    thirdScheduleStackViewTapGesture.numberOfTapsRequired = 1
    thirdScheduleStackViewTapGesture.numberOfTouchesRequired = 1
    thirdScheduleStackView.addGestureRecognizer(thirdScheduleStackViewTapGesture)
    thirdScheduleStackView.isUserInteractionEnabled = true
    
    secondScheduleStackView.isHidden = true
    thirdScheduleStackView.isHidden = true
    
    let stackViewTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
    stackViewTapGestureRecog.numberOfTapsRequired = 1
    stackViewTapGestureRecog.numberOfTouchesRequired = 1
    ratingStackView.addGestureRecognizer(stackViewTapGestureRecog)
    ratingStackView.isUserInteractionEnabled = true
    
    setupSessionInfo()
    
    _ = User.getCurrentUser(once: true) { (user) in
      self.currentUser = user
    }
    
    internalView = view
    rootViewFrame = view.frame
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    blurView.makeMeBlur()
    
    print(currentSession)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    maskPathOK = UIBezierPath(roundedRect: self.acceptButton.bounds, byRoundingCorners: ([.bottomLeft]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    
    maskLayerOK = CAShapeLayer()
    maskLayerOK.frame = self.acceptButton.bounds
    maskLayerOK.path = maskPathOK.cgPath
    
    
    
    maskPathCancel = UIBezierPath(roundedRect: self.declineButton.bounds, byRoundingCorners: ([.bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    
    maskLayerCancel = CAShapeLayer()
    maskLayerCancel.frame = self.declineButton.bounds
    maskLayerCancel.path = maskPathCancel.cgPath
    
    self.acceptButton.layer.mask = maskLayerOK
    self.declineButton.layer.mask = maskLayerCancel
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
}

























































