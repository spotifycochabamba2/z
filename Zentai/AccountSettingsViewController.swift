//
//  AccountSettingsViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/14/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class AccountSettingsViewController: UITableViewController {
  
  @IBOutlet weak var emailCell: UITableViewCell!
  @IBOutlet weak var phoneCell: UITableViewCell!
  @IBOutlet weak var addressCell: UITableViewCell!
  @IBOutlet weak var paymentCell: UITableViewCell!
  @IBOutlet weak var notificationsCell: UITableViewCell!
  @IBOutlet weak var updateCell: UITableViewCell!
  
  @IBOutlet weak var apartmentCell: UITableViewCell!
  @IBOutlet weak var cityCell: UITableViewCell!
  @IBOutlet weak var stateCell: UITableViewCell!
  @IBOutlet weak var zipCell: UITableViewCell!
  
  @IBOutlet weak var phoneEditIV: UIImageView!
  @IBOutlet weak var addressEditIV: UIImageView!
  @IBOutlet weak var apartmentEditImageView: UIImageView!
  @IBOutlet weak var cityEditImageView: UIImageView!
  @IBOutlet weak var stateEditImageView: UIImageView!
  @IBOutlet weak var zipEditImageView: UIImageView!
  
  
  @IBOutlet weak var emailTF: UITextField! {
    didSet {
      emailTF.text = ""
    }
  }
  
  @IBOutlet weak var phoneNumberTF: UITextField! {
    didSet {
      phoneNumberTF.text = ""
    }
  }
  
  @IBOutlet weak var addressTF: UITextField! {
    didSet {
      addressTF.text = ""
    }
  }
  
  @IBOutlet weak var paymentTF: UITextField! {
    didSet {
      paymentTF.text = ""
    }
  }
  
  @IBOutlet weak var apartmentTF: UITextField! {
    didSet {
      apartmentTF.text = ""
    }
  }
  
  @IBOutlet weak var cityTF: UITextField! {
    didSet {
      cityTF.text = ""
    }
  }
  
  @IBOutlet weak var stateTF: UITextField! {
    didSet {
      stateTF.text = ""
    }
  }
  
  @IBOutlet weak var zipTF: UITextField! {
    didSet {
      zipTF.text = ""
    }
  }
  
  @IBOutlet weak var updateButton: UIButton!
  
  var currentUser: User!
  
  var latitude: Double = 0
  var longitude: Double = 0
  
  @IBAction func updateButtonTouched() {
    
    let phone = phoneNumberTF.text ?? ""
    let address = addressTF.text ?? ""
    let apartment = apartmentTF.text ?? ""
    let city = cityTF.text ?? ""
    let state = stateTF.text ?? ""
    let zip = zipTF.text ?? ""
    
    SVProgressHUD.show()
    
    User.update(
      userId: currentUser.id!,
      withPhone: phone,
      AndAddress: address,
      AndApartment: apartment,
      AndCity: city,
      AndState: state,
      AndZip: zip,
      AndLatitude: latitude,
      AndLongitude: longitude,
      completion: { (error) in
        SVProgressHUD.dismiss()
        if let _ = error {
          
        } else {
          let alert = UIAlertController(title: "Info", message: "Successfully updated.", preferredStyle: .alert)
          alert.view.tintColor = UIColor.zentaiSecondaryColor
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
    })
  }
  
  private func initTextFields() {
    phoneNumberTF.text = ""
    emailTF.text = ""
    addressTF.text = ""
    paymentTF.text = ""
    
    addressTF.isUserInteractionEnabled = false
  }
  
  private func updateTextFields(_ user: User) {
    phoneNumberTF.text = user.phone
    emailTF.text = user.email
    addressTF.text = user.address
    
    apartmentTF.text = user.aparment
    cityTF.text = user.city
    stateTF.text = user.state
    zipTF.text = user.zip
    
    paymentTF.text = ""
    
    if let last4 = user.last4 {
      paymentTF.text = "XXXX-XXXX-XXXX-\(last4)"
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    updateButton.makeMeRounded()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    SVProgressHUD.show()
    //    Spinner.show(currentViewController: self)
    
    _ = User.getCurrentUser(once: true, navigationController: navigationController) { (user) in
      
      SVProgressHUD.dismiss()
      if let user = user {
        self.currentUser = user
        
        DispatchQueue.main.async {
          self.updateTextFields(user)
        }
      }
    }
  }
  
  func apartmentEditImageViewTapped() {
    apartmentTF.becomeFirstResponder()
  }
  
  func cityEditImageViewTapped() {
    cityTF.becomeFirstResponder()
  }
  
  func stateEditImageViewTapped() {
    stateTF.becomeFirstResponder()
  }
  
  func zipEditImageViewTapped() {
    zipTF.becomeFirstResponder()
  }
  
  func phoneEditIVTapped() {
    phoneNumberTF.becomeFirstResponder()
  }
  
  func addressIVTapped() {
    addressTF.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initTextFields()
    
    addDoneButtonOnKeyboardIn(textField: phoneNumberTF)
    
    let apartmentGesture = UITapGestureRecognizer(target: self, action: #selector(apartmentEditImageViewTapped))
    apartmentGesture.numberOfTapsRequired = 1
    apartmentGesture.numberOfTouchesRequired = 1
    apartmentEditImageView.isUserInteractionEnabled = true
    apartmentEditImageView.addGestureRecognizer(apartmentGesture)
    
    let cityGesture = UITapGestureRecognizer(target: self, action: #selector(cityEditImageViewTapped))
    cityGesture.numberOfTouchesRequired = 1
    cityGesture.numberOfTapsRequired = 1
    cityEditImageView.isUserInteractionEnabled = true
    cityEditImageView.addGestureRecognizer(cityGesture)
    
    let stateGesture = UITapGestureRecognizer(target: self, action: #selector(stateEditImageViewTapped))
    stateGesture.numberOfTapsRequired = 1
    stateGesture.numberOfTouchesRequired = 1
    stateEditImageView.isUserInteractionEnabled = true
    stateEditImageView.addGestureRecognizer(stateGesture)
    
    let zipGesture = UITapGestureRecognizer(target: self, action: #selector(zipEditImageViewTapped))
    zipGesture.numberOfTouchesRequired = 1
    zipGesture.numberOfTapsRequired = 1
    zipEditImageView.isUserInteractionEnabled = true
    zipEditImageView.addGestureRecognizer(zipGesture)
    
    let phoneEditIVGesture = UITapGestureRecognizer(target: self, action: #selector(phoneEditIVTapped))
    phoneEditIVGesture.numberOfTapsRequired = 1
    phoneEditIVGesture.numberOfTouchesRequired = 1
    phoneEditIV.isUserInteractionEnabled = true
    phoneEditIV.addGestureRecognizer(phoneEditIVGesture)
    
    let addressIVGesture = UITapGestureRecognizer(target: self, action: #selector(addressIVTapped))
    addressIVGesture.numberOfTouchesRequired = 1
    addressIVGesture.numberOfTapsRequired = 1
    addressEditIV.isUserInteractionEnabled = true
    //addressEditIV.addGestureRecognizer(addressIVGesture)
    
    phoneCell.selectionStyle = .none
    emailCell.selectionStyle = .none
    addressCell.selectionStyle = .default
    paymentCell.selectionStyle = .none
    updateCell.selectionStyle = .none
    
    tableView.separatorInset = .zero
    tableView.layoutMargins = .zero
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "ACCOUNT SETTINGS"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if cell === notificationsCell {
      performSegue(withIdentifier: Storyboard.SettingsToNotifications, sender: nil)
    } else if cell === addressCell {
      performSegue(withIdentifier: Storyboard.AccountSettingsToGoogleAddress, sender: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.AccountSettingsToGoogleAddress {
      let destinationVC = segue.destination as? GoogleAddressVC
      destinationVC?.setAddressInfo = setAddressInfo
      destinationVC?.didSelectPosition = didSelectPosition
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    //    if cell === notificationsCell {
    //      print(self.navigationController?.navigationBar.frame.height)
    //      height = view.frame.height - (CGFloat(300) + self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
    //
    //    }
    
    return cell.frame.height
  }
  
  func setAddressInfo(
    _ address: String,
    _ city: String,
    _ state: String,
    zip: String
  ) {
    addressTF.text = address
    cityTF.text = city
    stateTF.text = state
  }
  
  func didSelectPosition(
    latitude: Double,
    longitude: Double
  ) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
}































