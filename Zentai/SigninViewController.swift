//
//  SigninViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/18/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import Ax

class SigninViewController: UITableViewController {
  
  @IBOutlet weak var errorMessage: UILabel!
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var signinFacebookButton: UIButton!
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    Spinner.dismiss()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    loginButton.delegate = self
    //    signinFacebookButton.readPermissions = ["email"]
    //    signinFacebookButton.delegate = self
    
    errorMessage.isHidden = true
    navigationController?.navigationBar.isHidden = false
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    
    self.navigationController?.navigationBar.backgroundColor = .clear
    self.navigationController?.view.backgroundColor = .clear
  }
  
  func keyboardIsShown(_ notification: Notification) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
      self?.tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .middle, animated: true)
    }
  }
  
  func keyboardIsDimissed(_ notification: Notification) {
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureButtons()
    navigationController?.navigationBar.isHidden = false
    
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
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    configureTextFields()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.SigninToAgree {
      let viewController = segue.destination as? AgreeViewController
      viewController?.agreeRead = agreeFinished
    }
  }
  
  func agreeFinished() {
    performSegue(withIdentifier: Storyboard.SigninToHome, sender: nil)
  }
}



extension SigninViewController {
  func configureButtons() {
    signinButton.makeMeRounded()
    signinFacebookButton.makeMeRounded()
  }
  
  func configureTextFields() {
    emailTextField.addBottomLine(color: UIColor.zentaiGray)
    passwordTextField.addBottomLine(color: UIColor.zentaiGray)
  }
}

extension SigninViewController {
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
}




extension SigninViewController {
  
  @IBAction func forgotPasswordTouched() {
    print("forgot password touched")
    
    performSegue(withIdentifier: Storyboard.SinginToForgotPassword, sender: nil)
  }
  
  @IBAction func goBack() {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func signinButtonTouched() {
    view.endEditing(true)
    signinButton.isEnabled = false
    do {
      configureTextFields()
      errorMessage.isHidden = true
      
      let email = try getEmail()
      let password = try getPassword()
      
      var role: UserRole?
      
      Spinner.show(currentViewController: self)
      //      SVProgressHUD.show()
      Ax.serial(tasks: [
        { done in
          print("calling user sign in method")
          User.signin(email: email, password: password, completion: { (error) in
            
            self.signinButton.isEnabled = true
            print(error)
            done(error)
          })
        },
        { done in
          print(User.currentUserId!)
          User.getRole(from: User.currentUserId!, completion: { (roleFound) in
            role = roleFound
            done(nil)
          })
        }
        ], result: { (error) in
          Spinner.dismiss()
          
          DispatchQueue.main.async {
            if let error = error {
              self.show(errorMessage: error.localizedDescription)
            } else {
              
              User.updatePushNotificationField()
              
              
              
              if let role = role {
                switch role {
                case .client:
                  self.performSegue(withIdentifier: Storyboard.SigninToHome, sender: nil)
                case .practitioner:
                  self.performSegue(withIdentifier: Storyboard.SigninToPractitionerHome, sender: nil)
                }
              } else {
                self.performSegue(withIdentifier: Storyboard.SigninToPractitionerHome, sender: nil)
              }
            }
          }
      })
    } catch UserValidationError.invalidField(let errorMessage, let view) {
      view.shake()
      view.addBottomLine(color: UIColor.zentaiPrimaryColor)
      show(errorMessage: errorMessage)
    } catch {
      print(error)
    }
  }
  
  func show(errorMessage: String) {
    self.errorMessage.text = errorMessage
    
    UIView.animate(withDuration: 0.3, animations: {
      self.errorMessage.isHidden = false
    })
  }
  
  @IBAction func signinFacebookButtonTouched() {
    
    User.connectToFacebook(viewController: self) { (error, isNew, isCancelled) in
      print("is new: \(isNew)")
      
      if isCancelled {
        return
      }
      
      DispatchQueue.main.async {
        if isNew {
          self.performSegue(withIdentifier: Storyboard.SigninToAgree, sender: nil)
        } else {
          
          if let error = error {
            self.show(errorMessage: error.localizedDescription)
          } else {
            self.performSegue(withIdentifier: Storyboard.SigninToHome, sender: nil)
          }
          
        }
      }
      
    }
  }
}


extension SigninViewController {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    signinButton.isEnabled = false
    view.endEditing(true)
    signinButtonTouched()
    return true
  }
}

extension SigninViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var height = super.tableView(tableView, heightForRowAt: indexPath)
    
    if indexPath.row == 0 {
      height = view.frame.size.height - 320
    }
    
    return height
  }
}

























