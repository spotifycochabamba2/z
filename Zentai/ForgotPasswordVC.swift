//
//  ForgotPasswordVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/29/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UITableViewController {
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var errorMessageLabel: UILabel!
  
  @IBAction func sendButtonTouched() {
    do {
      let email = try getEmail()
      
      Spinner.show(currentViewController: self)
      User.sendResetPasswordTo(email: email, completion: { [unowned self] (error) in
        
        Spinner.dismiss()
        var title = ""
        var message = ""
        
        if let error = error {
          title = "Error"
          message = error.localizedDescription
        } else {
          title = "Success"
          message = Constants.Texts.SendResetPassword
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        })
      
    } catch UserValidationError.invalidField(let errorMessage, let view) {
      view.shake()
      view.addBottomLine(color: UIColor.zentaiPrimaryColor)
      show(errorMessage: errorMessage)
    } catch {
      print(error)
    }
  }
  
  @IBAction func backButtonTouched() {
    _ = navigationController?.popViewController(animated: true)
  }
}

extension ForgotPasswordVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    errorMessageLabel.isHidden = true
    emailTF.text = ""
    
    navigationController?.navigationBar.isHidden = false
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    
    self.navigationController?.navigationBar.backgroundColor = .clear
    self.navigationController?.view.backgroundColor = .clear
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    emailTF.addBottomLine(color: .zentaiGray)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sendButton.makeMeRounded()
    
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    Spinner.dismiss()
  }
  
}


extension ForgotPasswordVC {
  //  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    var height = super.tableView(tableView, heightForRowAt: indexPath)
  //
  //    if indexPath.row == 2 {
  //      height = view.frame.size.height - 340
  //    }
  //
  //    return height
  //  }
  
  func keyboardIsShown(_ notification: Notification) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
      self?.tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .middle, animated: true)
    }
  }
  
  func keyboardIsDimissed(_ notification: Notification) {
    
  }
}

extension ForgotPasswordVC {
  func getEmail() throws -> String {
    let email = emailTF.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if email.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.EmailEmpty, emailTF)
    }
    
    if !email.isValidEmail() {
      throw UserValidationError.invalidField(Constants.ErrorMessages.EmailInvalid, emailTF)
    }
    
    return email
  }
  
  func show(errorMessage: String) {
    self.errorMessageLabel.text = errorMessage
    
    UIView.animate(withDuration: 0.3, animations: {
      self.errorMessageLabel.isHidden = false
    })
  }
}
