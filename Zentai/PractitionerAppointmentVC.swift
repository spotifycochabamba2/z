//
//  PractitionerAppointmentVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 2/9/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftLocation

class PractitionerAppointmentVC: UIViewController {
  
  var session: Session?
  
  @IBOutlet weak var ratingStackView: UIStackView!
  
  
  @IBOutlet weak var cancelAppointmentButton: UIButton!
  @IBOutlet weak var checkinButton: UIButton!
  
  @IBOutlet weak var practitionerProfileButton: UIButton!
  
  var deselectCurrentRow: () -> Void = {}
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var clientNameLabel: UILabel!
  @IBOutlet weak var allergiesLabel: UILabel!
  @IBOutlet weak var parkingInstructionsLabel: UILabel!
  @IBOutlet weak var backgroundView: UIView!
  
  @IBOutlet weak var starsView: StartsView!
  
  func stackViewTapped() {
    performSegue(withIdentifier: Storyboard.PractitionerAppointmentToReviews, sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ratingStackView.isUserInteractionEnabled = true
    
    let stackViewTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
    stackViewTapGestureRecog.numberOfTouchesRequired = 1
    stackViewTapGestureRecog.numberOfTapsRequired = 1
    ratingStackView.addGestureRecognizer(stackViewTapGestureRecog)
    
    addressLabel.text = ""
    dateLabel.text = ""
    timeLabel.text = ""
    clientNameLabel.text = ""
    allergiesLabel.text = ""
    parkingInstructionsLabel.text = ""
    
    modalPresentationCapturesStatusBarAppearance = true
    
    if let userId = session?.clientId {
      Spinner.show(currentViewController: self)
      Review.getTotalReviews(
        userId: userId,
        completion: { (error, rate) in
          Spinner.dismiss()
          
          if error === nil {
            DispatchQueue.main.async {
              self.starsView.rate = rate
            }
          }
      })
    }
    
    loadDataToUI(session)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    practitionerProfileButton.makeMeRounded()
    backgroundView.makeMeRounded()
  }
  
  func loadDataToUI(_ session: Session?) {
    
    guard let session = session else { return }
    
    clientNameLabel.text = session.clientName
    
    let gender = PracticionerGender(rawValue: session.practitionerGender)?.toString() ?? ""
    let allergies = OilAllergies(rawValue: session.oilAllergy ?? "N")?.toString() ?? ""
    let pets = Pets(rawValue: session.anyPets)?.toString() ?? ""
    
    allergiesLabel.text = "60-minute Acupuncture Session \n\(gender), \(allergies), \(pets)"
    
    parkingInstructionsLabel.text = session.parkingInstructions
    
    addressLabel.text = session.getCompleteAddress()
    timeLabel.text = Utils.format(time: session.selectedStart!)
    
    dateLabel.text = Utils.getCompleteDate2(date: session.selectedDate!)
  }
  
  @IBAction func practitionerProfileButtonTouched() {
    
    guard
      let clientId = session?.clientId,
      let sessionId = session?.id
      else {
        
        let alert = UIAlertController(
          title: "Error",
          message: "Client Id or Session Id not found.",
          preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default
        ))
        
        present(alert, animated: true)
        return
    }
    
    SVProgressHUD.show()
    Session.checkinSession(
      sessionId: sessionId,
      userId: clientId) { (error, successMessage) in
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if let error = error {
          alert.title = "Error"
          alert.message = error.localizedDescription
          
          alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
          ))
        } else {
          alert.title = "Info"
          alert.message = successMessage
          
          alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
              self.performSegue(
                withIdentifier: Storyboard.PractitionerAppointmentToCheckIn,
                sender: nil
              )
            }
          ))
        }
        
        self.present(alert, animated: true)
    }
    
    //    let status = CellState.checkedIn.rawValue
    ////    let status = Constants.Session.States.checkedIn
    //
    //    Spinner.show(currentViewController: self)
    ////    SVProgressHUD.show()
    //    Session.updateSessionStatus(userId: clientId, sessionId: sessionId, status: status, reason: "") { error in
    //      Spinner.dismiss()
    //
    //      self.performSegue(withIdentifier: Storyboard.PractitionerAppointmentToCheckIn, sender: nil)
    //    }
    
  }
  
  @IBAction func cancelAppointmentButtonTouched() {
    
    guard
      let clientId = session?.clientId,
      let sessionId = session?.id
      else {
        let alert = UIAlertController(
          title: "Error",
          message: "Client Id or Session Id not found.",
          preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default)
        )
        
        present(alert, animated: true)
        return
    }
    
    var params = [String: Any]()
    params["clientId"] = clientId
    params["sessionId"] = sessionId
    
    performSegue(withIdentifier: Storyboard.PractitionerAppointmentToCancelAppointment, sender: params)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.PractitionerAppointmentToChat {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers.first as? ChatViewController
      
      let clientId = session?.clientId
      let clientName = session?.clientName
      
      vc?.userIdTwo = clientId
      vc?.userNameTwo = clientName
    } else if segue.identifier == Storyboard.PractitionerAppointmentToMap {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers.first as? AddressMapVC
      //      vc?.prefersStatusBarHidden = true
      vc?.modalPresentationCapturesStatusBarAppearance = true
      vc?.sessionLocation = session?.location
    } else if segue.identifier == Storyboard.PractitionerAppointmentToCancelAppointment {
      let vc = segue.destination as? PractitionerCancelAppointmentVC
      
      let params = sender as! [String: Any]
      let clientId = params["clientId"] as! String
      let sessionId = params["sessionId"] as! String
      
      vc?.clientId = clientId
      vc?.sessionId = sessionId
    } else if segue.identifier == Storyboard.PractitionerAppointmentToCheckIn {
      let vc = segue.destination as? PractitionerCheckInVC
      vc?.session = self.session
      vc?.closePractitionerAppointmentVC = close
    } else if segue.identifier == Storyboard.PractitionerAppointmentToReviews {
      let vc = segue.destination as? PractitionerReviewsVC
      
      vc?.session = session
    }
  }
  
  @IBAction func messageClientButtonTouched() {
    performSegue(withIdentifier: Storyboard.PractitionerAppointmentToChat, sender: nil)
  }
  
  @IBAction func takeMeThereButtonTouched() {
    //    performSegue(withIdentifier: Storyboard.PractitionerAppointmentToMap, sender: nil)
    
    if let currentLocation = session?.location {
      Spinner.show(currentViewController: self)
      //      SVProgressHUD.show()
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
  
  @IBAction func close() {
    dismiss(animated: true) {
      self.deselectCurrentRow()
    }
  }
}































