//
//  SignupViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/18/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import Ax
import SVProgressHUD
import FirebaseCrash

class SignupViewController: UITableViewController {
  
  @IBOutlet weak var errorMessage: UILabel!
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  
  @IBOutlet weak var signupFacebookButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    Spinner.dismiss()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = false
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    
    self.navigationController?.navigationBar.backgroundColor = .clear
    self.navigationController?.view.backgroundColor = .clear
    
    errorMessage.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureButtons()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardIsShown(_:)),
      name: NSNotification.Name.UIKeyboardDidShow,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardIsDimissed(_:)),
      name: Notification.Name.UIKeyboardWillHide,
      object: nil)
    
  }
  
  func keyboardIsShown(_ notification: Notification) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
      self?.tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .bottom, animated: true)
    }
  }
  
  func keyboardIsDimissed(_ notification: Notification) {
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    configureTextFields()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.SignupToAgree {
      let viewController = segue.destination as? AgreeViewController
      viewController?.agreeRead = agreeFinished
    }
  }
}


extension SignupViewController {
  func configureTextFields() {
    firstNameTextField.addBottomLine(color: UIColor.zentaiGray)
    lastNameTextField.addBottomLine(color: UIColor.zentaiGray)
    emailTextField.addBottomLine(color: UIColor.zentaiGray)
    phoneTextField.addBottomLine(color: UIColor.zentaiGray)
    passwordTextField.addBottomLine(color: UIColor.zentaiGray)
    repeatPasswordTextField.addBottomLine(color: UIColor.zentaiGray)
  }
  
  func configureButtons() {
    signupFacebookButton.makeMeRounded()
    signupButton.makeMeRounded()
  }
}

extension SignupViewController {
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    signupButtonTouched()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    errorMessage.isHidden = true
    configureTextFields()
    return true
  }
  
  //  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
  //    if textField === emailTextField {
  //      if textField.text!.isValidEmail() {
  //
  //        User.exist(email: textField.text!.trimmingCharacters(in: CharacterSet.whitespaces)) { exist in
  //          if exist {
  //            DispatchQueue.main.async {
  //              self.emailTextField.shake()
  //              self.emailTextField.addBottomLine(color: UIColor.zentaiPrimaryColor)
  //              self.show(errorMessage: Constants.ErrorMessages.EmailAlreadyExist)
  //            }
  //          }
  //        }
  //
  //      }
  //    }
  //
  //    return true
  //  }
}


extension SignupViewController {
  @IBAction func signupButtonTouched() {
    FIRCrashMessage("1:Signup button touched")
    view.endEditing(true)
    do {
      configureTextFields()
      errorMessage.isHidden = true
      
      let firstName = try getFirstName()
      let lastName = try getLastName()
      let email = try getEmail()
      let phone = try getPhone()
      try validatePasswords()
      
      let password = try getPassword()
      
      FIRCrashMessage("2:It was got name, email, phone, etc from UI")
      
      //      var user = User(id: nil, firstName: firstName, lastName: lastName, email: email, stripeId: nil, phone: phone)
      var user = User(id: nil, firstName: firstName, lastName: lastName, email: email, phone: phone)
      
      Spinner.show(currentViewController: self)
      //      SVProgressHUD.show()
      Ax.serial(tasks: [
        { done in
          FIRCrashMessage("3:Signing user to Firebase Auth")
          User.signup(user: user, password: password, completion: { (error, resultUser) in
            user = resultUser
            done(error)
          })
        },
        { done in
          FIRCrashMessage("4:Saving user to Firebase Database")
          User.save(user: user, completion: { (error) in
            done(error)
          })
        }
        ], result: { (error) in
          Spinner.dismiss()
          DispatchQueue.main.async {
            if let error = error {
              FIRCrashMessage("5:Error: \(error.localizedDescription)")
              self.show(errorMessage: error.localizedDescription)
            } else {
              
              User.updatePushNotificationField()
              
              
              
              self.performSegue(withIdentifier: Storyboard.SignupToAgree, sender: nil)
            }
          }
      })
      
    } catch UserValidationError.invalidField(let errorMessage, let view) {
      view.shake()
      view.addBottomLine(color: UIColor.zentaiPrimaryColor)
      
      show(errorMessage: errorMessage)
    } catch {
      show(errorMessage: error.localizedDescription)
    }
  }
  
  func show(errorMessage: String) {
    self.errorMessage.text = errorMessage
    
    UIView.animate(withDuration: 0.3, animations: {
      self.errorMessage.isHidden = false
    })
  }
  
  @IBAction func signupFacebookButtonTouched() {
    
    User.connectToFacebook(viewController: self) { (error, isNew, isCancelled) in
      if isCancelled {
        return
      }
      
      DispatchQueue.main.async {
        if isNew {
          self.performSegue(withIdentifier: Storyboard.SignupToAgree, sender: nil)
        } else {
          
          if let error = error {
            self.show(errorMessage: error.localizedDescription)
          } else {
            self.performSegue(withIdentifier: Storyboard.SignupToHome, sender: nil)
          }
          
        }
      }
      
    }
  }
  
  @IBAction func goBack() {
    _ = navigationController?.popViewController(animated: true)
  }
}

extension SignupViewController {
  func agreeFinished() {
    performSegue(withIdentifier: Storyboard.SignupToHome, sender: nil)
  }
}

extension SignupViewController {
  func getFirstName() throws -> String {
    let firstName = firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if firstName.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.FirstNameEmpty, firstNameTextField)
    }
    
    return firstName
  }
  
  func getLastName() throws -> String {
    let lastName = lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if lastName.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.LastNameEmpty, lastNameTextField)
    }
    
    return lastName
  }
  
  func getEmail() throws -> String {
    let email = emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if email.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.EmailEmpty, emailTextField)
    }
    
    if !email.isValidEmail() {
      throw UserValidationError.invalidField(Constants.ErrorMessages.EmailInvalid, emailTextField)
    }
    
    return email
  }
  
  func getPhone() throws -> String {
    let phone = phoneTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if phone.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.PhoneEmpty, phoneTextField)
    }
    
    return phone
  }
  
  func getPassword() throws -> String {
    let password = passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if password.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.PasswordEmpty, passwordTextField)
    }
    
    if password.characters.count < 6 {
      throw UserValidationError.invalidField(Constants.ErrorMessages.PasswordShort, passwordTextField)
    }
    
    return password
  }
  
  func validatePasswords() throws {
    let password = try getPassword()
    let repeatedPassword = repeatPasswordTextField.text!
    
    if password != repeatedPassword {
      throw UserValidationError.invalidField(Constants.ErrorMessages.PasswordRepeatNotEqual, repeatPasswordTextField)
    }
  }
}

enum UserValidationError: Error {
  case invalidField(String, UIView)
}

extension String {
  func isValidEmail() -> Bool {
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: self)
    return result
  }
}


extension SignupViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var height = super.tableView(tableView, heightForRowAt: indexPath)
    
    if indexPath.row == 0 {
      height = view.frame.size.height - CGFloat(400) //400
    }
    
    return height
  }
}

























