//
//  PractitionerEditProfileTVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 2/15/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class PractitionerEditProfileTVC: UITableViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var clientNameLabel: UILabel!
  @IBOutlet weak var updateButton: UIButton!
  
  @IBOutlet weak var phoneNumberIcon: UIImageView!
  @IBOutlet weak var addressIcon: UIImageView!
  
  @IBOutlet weak var cityIcon: UIImageView!
  @IBOutlet weak var stateIcon: UIImageView!
  @IBOutlet weak var zipIcon: UIImageView!
  
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var zipTextField: UITextField!
  
  @IBOutlet weak var bankInfoTextField: UITextField!
  
  var currentUser: User?
  
  @IBAction func updateButtonTouched() {
    let phone = phoneNumberTextField.text ?? ""
    let address = addressTextField.text ?? ""
    
    let city = cityTextField.text ?? ""
    let state = stateTextField.text ?? ""
    let zip = zipTextField.text ?? ""
    
    if let userId = currentUser?.id {
      User.update(
        userId: userId,
        withPhone: phone,
        AndAddress: address,
        AndApartment: "",
        AndCity: city,
        AndState: state,
        AndZip: zip,
        completion: { (error) in
          if let _ = error {
            
          } else {
            let alert = UIAlertController(title: "Info", message: "Successfully updated", preferredStyle: .alert)
            alert.view.tintColor = UIColor.zentaiSecondaryColor
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
          }
      })
    }
  }
  
  func phoneIconTapped() {
    phoneNumberTextField.becomeFirstResponder()
  }
  
  func emailIconTapped() {
    emailTextField.becomeFirstResponder()
  }
  
  func addressIconTapped() {
    addressTextField.becomeFirstResponder()
  }
  
  func updateTextFields(_ user: User) {
    
    clientNameLabel.text = "\(user.firstName) \(user.lastName)"
    phoneNumberTextField.text = user.phone
    
    emailTextField.text = user.email
    
    addressTextField.text = user.address
    cityTextField.text = user.city
    stateTextField.text = user.state
    zipTextField.text = user.zip
    
    bankInfoTextField.text = ""
    
    let profileURL = user.profileURL
    
    if let profileURL = profileURL, !profileURL.isEmpty {
      imageView.sd_setImage(with: URL(string: profileURL)!, placeholderImage: UIImage(named: "person-default"))
    } else {
      imageView.image = UIImage(named: "person-default")
    }
    
    if let last4 = user.last4 {
      bankInfoTextField.text = "XXXX-XXXX-XXXX-\(last4)"
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    _ = User.getCurrentUser(once: true, navigationController: navigationController, completion: { [weak weakSelf = self] (user) in
      Spinner.dismiss()
      
      if let user = user {
        weakSelf?.currentUser = user
        
        DispatchQueue.main.async {
          self.updateTextFields(user)
        }
      }
      })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let phoneTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(phoneIconTapped))
    phoneTapGestureRecog.numberOfTapsRequired = 1
    phoneTapGestureRecog.numberOfTouchesRequired = 1
    phoneNumberIcon.addGestureRecognizer(phoneTapGestureRecog)
    phoneNumberIcon.isUserInteractionEnabled = true
    
    //    let emailTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(emailIconTapped))
    //    emailTapGestureRecog.numberOfTouchesRequired = 1
    //    emailTapGestureRecog.numberOfTapsRequired = 1
    //    emailIcon.addGestureRecognizer(emailTapGestureRecog)
    //    emailIcon.isUserInteractionEnabled = true
    
    let addressTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(addressIconTapped))
    addressTapGestureRecog.numberOfTapsRequired = 1
    addressTapGestureRecog.numberOfTouchesRequired = 1
    addressIcon.addGestureRecognizer(addressTapGestureRecog)
    addressIcon.isUserInteractionEnabled = true
    
    imageView.layer.cornerRadius = 120 / 2
    imageView.layer.borderColor = UIColor.gray.cgColor
    imageView.layer.borderWidth = 1.0
    imageView.layer.masksToBounds = true
    
    imageView.image = UIImage(named: "person-default")
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "EDIT PROFILE"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    updateButton.makeMeRounded()
  }
  
}
