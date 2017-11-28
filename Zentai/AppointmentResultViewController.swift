//
//  AppointmentResultViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/29/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Ax

class AppointmentResultViewController: ModalViewController {
  
  var session: Session?
  var sessionId: String?
  
  var deselectRowOnAppointmentsViewController: (() -> Void)? = { }
  
  @IBOutlet weak var giveReviewButton: UIButton!
  @IBOutlet weak var viewBox: UIView!
  
  @IBOutlet weak var practitionerStackView: UIStackView!
  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var practitionerNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var scheduleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var creditcardLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  
  @IBOutlet weak var cancelAppointmentButton: UIButton!
  
  @IBOutlet weak var practitionerProfileButton: UIButton!
  
  var currentUser: User?
  var getUserHandler: UInt = 0
  
  func disablePractitionerProfileButton() {
    practitionerProfileButton.isEnabled = false
    practitionerProfileButton.alpha = 0.5
  }
  
  func enablePractitionerProfileButton() {
    practitionerProfileButton.isEnabled = true
    practitionerProfileButton.alpha = 1.0
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    giveReviewButton.isHidden = true
    cancelAppointmentButton.isHidden = true
    
    disablePractitionerProfileButton()
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "APPOINTMENT DETAIL"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    //    practitionerStackView.isHidden = true
  }
  
  deinit {
    if let userId = currentUser?.id {
      User.removeHandler(id: getUserHandler, userId: userId)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //    Spinner.show(currentViewController: self)
    SVProgressHUD.show()
    Ax.serial(
      tasks: [
        {  [weak weakSelf = self]  done in
          weakSelf?.getUserHandler = User.getCurrentUser(once: false, navigationController: weakSelf?.navigationController, completion: {(user) in
            if let user = user {
              weakSelf?.currentUser = user
              
              DispatchQueue.main.async {
                weakSelf?.welcomeLabel.text = "Welcome, \(user.firstName.capitalized)"
                let card = "**** **** **** \(user.last4 ?? "0000")"
                weakSelf?.creditcardLabel.text = card
              }
              done(nil)
            } else {
              done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user found"]))
            }
          })
        },
        { done in
          if let session = self.session {
            DispatchQueue.main.async {
              self.loadSessionInfo(session: session)
            }
            done(nil)
          } else if let sessionId = self.sessionId {
            Session.get(with: sessionId) { session in
              SVProgressHUD.dismiss()
              self.session = session
              
              if let session = session {
                DispatchQueue.main.async {
                  self.loadSessionInfo(session: session)
                }
              }
              
              done(nil)
            }
          }
        }
      ],
      result: { error in
        SVProgressHUD.dismiss()
      }
    )
  }
  
  func updateInfo() {
    
    // loadSessionInfo
    DispatchQueue.main.async {
      if let session = self.session {
        self.loadSessionInfo(session: session)
      }
    }
    
  }
  
  func loadSessionInfo(session: Session) {
    
    let sessionState = CellState(rawValue: session.status)
    
    if
      let selectedStart = session.selectedStart,
      let selectedEnd = session.selectedEnd
    {
      let startTime = Utils.format(time: selectedStart)
      let endTime = Utils.format(time: selectedEnd)
      
      timeLabel.text = "\(startTime) - \(endTime)"
    } else {
      timeLabel.text = Constants.Texts.waitingToBeConfirmed
    }
    
    if let selectedDate = session.selectedDate {
      dateLabel.text = Utils.getCompleteDate(date: selectedDate)
    } else {
      dateLabel.text = Constants.Texts.waitingToBeConfirmed
    }
    
    if let state = sessionState {
      switch state {
      case .invitedNotAccepted:
        statusLabel.text = Constants.Session.WaitingPractitioner
        practitionerStackView.isHidden = true
        disablePractitionerProfileButton()
        cancelAppointmentButton.isHidden = false
      case .acceptedAndnotCompleted:
        statusLabel.text = Constants.Session.AppointmentConfirmed
        practitionerStackView.isHidden = false
        enablePractitionerProfileButton()
        cancelAppointmentButton.isHidden = false
      case .completedAndPaid:
        fallthrough
      case .completedNotPaid:
        fallthrough
      case .checkedIn:
        practitionerStackView.isHidden = false
        
        if let userId = session.assignedTo,
          let sessionId = session.id {
          Review.hasReview(
            userId: userId,
            sessionId: sessionId,
            completion: { [weak self] (error, hasReview) in
              if error === nil {
                DispatchQueue.main.async {
                  self?.giveReviewButton.isHidden = hasReview
                }
              }
            })
          
        }
        
        enablePractitionerProfileButton()
        statusLabel.text = Constants.Session.AppointmentFinished
      case .cancelledByPractitioner:
        statusLabel.text = Constants.Session.AppointmentCancelled
        break
      case .cancelledByUser:
        statusLabel.text = Constants.Session.AppointmentCancelled
        break
      }
    } else {
      statusLabel.text = Constants.Session.WaitingPractitioner
    }
    
    practitionerNameLabel.text = "Practitioner\n\(session.practitionerName ?? "")"


    
    let gender = PracticionerGender(rawValue: session.practitionerGender)?.toString() ?? ""
    let allergies = OilAllergies(rawValue: session.oilAllergy ?? "N")?.toString() ?? ""
    let pets = Pets(rawValue: session.anyPets)?.toString() ?? ""
    scheduleLabel.text = "60-minute Acupuncture Session \n\(gender), \(allergies), \(pets)"
    
    //        address = "\(session.address)\n\(session.city), \(session.state) \(session.zip)"
    //    let address = "\(session.address)\n\(session.state), \(session.zip)"
    //    addressLabel.text = address
    
    addressLabel.text = session.getCompleteAddress()
    
    let card = "**** **** **** \(currentUser!.last4!)"
    creditcardLabel.text = card
    
    totalLabel.text = Utils.format(amount: session.cost)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    viewBox.makeMeRounded()
    practitionerProfileButton.makeMeRounded()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.AppointmentToProfile {
      if let session = session {
        let vc = segue.destination as? ProfilePractitionerViewController
        vc?.practitionerId = session.assignedTo
        vc?.practitionerName = session.practitionerName
      }
    } else if segue.identifier == Storyboard.AppointmentToSearchAddress {
      let vc = segue.destination as? GoogleAddressVC
      vc?.setAddressInfoWith = setAddressInfo
    } else if segue.identifier == Storyboard.AppointmentToPayment {
      let vc = segue.destination as? PaymentViewController
      vc?.updateInfo = updateInfo
    } else if segue.identifier == Storyboard.ViewAppointmentToCancelAppointment {
      let vc = segue.destination as? CancelAppointmentViewController
      vc?.session = session
    } else if segue.identifier == Storyboard.AppointmentResultToReview {
      let vc = segue.destination as? PractitionerReviewVC
      //      vc?.session = session
      
      // from client
      //      var reviewerUsername = ""
      let reviewerUserId = User.currentUserId
      let reviewedUserId = session?.assignedTo
      //      var reviewedUsername = ""
      //      var sessionId = session?.id
      
      vc?.reviewedUserId = reviewedUserId
      vc?.reviewerUserId = reviewerUserId
      vc?.sessionId = sessionId
      vc?.hideCloseButton = false
    }
  }
  
  func setAddressInfo(address: AddressInfo) {
    if let userId = currentUser?.id,
      let sessionId = sessionId
    {
      session?.address = address.address ?? ""
      session?.city = address.city ?? ""
      session?.state = address.state ?? ""
      session?.zip = address.zip ?? ""
      
      DispatchQueue.main.async {
        self.addressLabel.text = self.session?.getCompleteAddress()
      }
      
      Session.updateAddress(userId: userId, sessionId: sessionId, addressInfo: address)
    }
  }
  
  @IBAction func giveReviewButtonTouched() {
    guard let _ = User.currentUserId else {
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
    
    guard let _ = session?.assignedTo else {
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
    
    guard let _ = session?.id else {
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
    
    performSegue(withIdentifier: Storyboard.AppointmentResultToReview, sender: nil)
  }
  
  @IBAction func practitionerProfileButtonTouched() {
    performSegue(withIdentifier: Storyboard.AppointmentToProfile, sender: nil)
  }
  
  @IBAction func addressButtonTouched() {
    performSegue(withIdentifier: Storyboard.AppointmentToSearchAddress, sender: nil)
  }
  
  @IBAction func creditcardButtonTouched() {
    performSegue(withIdentifier: Storyboard.AppointmentToPayment, sender: nil)
  }
  
  @IBAction func close() {
    deselectRowOnAppointmentsViewController?()
    let scheduledViewController = presentingViewController as? ScheduledViewController
    print(presentingViewController)
    print(scheduledViewController)
    
    dismiss(animated: true) {
      print(scheduledViewController)
      scheduledViewController?.goHomeScreen()
    }
  }
  
  @IBAction func cancelAppointmentButtonTouched() {
    performSegue(withIdentifier: Storyboard.ViewAppointmentToCancelAppointment, sender: nil)
  }
  
}



































