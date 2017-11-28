//
//  PractitionerProfileViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/29/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

class ProfilePractitionerViewController: ModalViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var rebookNowButton: UIButton!
  @IBOutlet weak var messageTitleButton: UIButton!
  
  @IBOutlet weak var starsView: StartsView!
  
  var practitionerId: String?
  var practitionerName: String?
  
  var currentPractitioner: User?
  
  func updateUI(_ practitioner: User) {
    let profileURL = practitioner.profileURL
    let name = practitioner.firstName + " " + practitioner.lastName
    
    descriptionLabel.text = practitioner.bio
    starsView.rate = UInt(practitioner.rating)
    messageTitleButton.setTitle("Message \(practitioner.firstName)", for: .normal)
    
    if let profileURL = profileURL, !profileURL.isEmpty {
      imageView.sd_setImage(with: URL(string: profileURL)!, placeholderImage: UIImage(named: "person-default"))
    } else {
      imageView.image = UIImage(named: "person-default")
    }
    
    imageView.layer.cornerRadius = 120 / 2
    imageView.layer.borderColor = UIColor.gray.cgColor
    imageView.layer.borderWidth = 1.0
    imageView.layer.masksToBounds = true
    
    nameLabel.text = name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = ""
    descriptionLabel.text = ""
    messageTitleButton.setTitle("", for: .normal)
    
    starsView.rate = 0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let practitionerId = practitionerId {
      _ = User.getUser(by: practitionerId, once: true) { [weak weakSelf = self] (user) in
        weakSelf?.currentPractitioner = user
        
        DispatchQueue.main.async {
          if let user = user {
            weakSelf?.updateUI(user)
          }
        }
      }
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    rebookNowButton.makeMeRounded()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.PractitionerToChat {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers[0] as? ChatViewController
      
      vc?.userIdTwo = practitionerId
      vc?.userNameTwo = practitionerName
    } else if segue.identifier == Storyboard.ProfilePractitionerToBooking {
      let vc = segue.destination as? BookingViewController
      vc?.bookingSpecificPractitionerId = sender as? String
    }
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func messageButtonTouched() {
    performSegue(withIdentifier: Storyboard.PractitionerToChat, sender: nil)
  }
  
  @IBAction func rebookNowButtonTouched() {
    guard let practitionerId = practitionerId else {
      let alert = UIAlertController(title: "Error", message: "Practitioner info not found.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
      return
    }
    
    performSegue(withIdentifier: Storyboard.ProfilePractitionerToBooking, sender: practitionerId)
  }
}











