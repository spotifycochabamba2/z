//
//  PaymentViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/2/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import Validator
import UITextField_Navigation
import Stripe
import Ax
import Just
import SVProgressHUD
import Alamofire
import SwiftyJSON
import FirebaseCrash

struct ValidationError: Error {
  
  public let message: String
  
  public init(message m: String) {
    message = m
  }
}


class PaymentViewController: ModalViewController {
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var payButton: UIButton!
  
  @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var errorMessageLabel: UILabel!
  
  @IBOutlet weak var cardNameTextField: UITextField!
  @IBOutlet weak var cardNumberTextField: UITextField!
  @IBOutlet weak var ccvTextField: UITextField!
  @IBOutlet weak var mmyyTextField: UITextField!
  
  var updateInfo: (() -> Void)?
  
  var currentUser: User?
  
  func getCardName() throws -> String {
    let cardName = cardNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    
    if cardName.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.CardNameEmpty, cardNameTextField)
    }
    
    return cardName
  }
  
  func getCardNumber()  throws -> String {
    let cardNumber = cardNumberTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if cardNumber.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.CardNumberEmpty, cardNumberTextField)
    }
    
    switch STPCardValidator.validationState(forNumber: cardNumber, validatingCardBrand: true) {
    case .invalid:
      throw UserValidationError.invalidField(Constants.ErrorMessages.CardNumberInvalid, cardNumberTextField)
    case .incomplete:
      throw UserValidationError.invalidField(Constants.ErrorMessages.CardNumberIncomplete, cardNumberTextField)
    default:
      break
    }
    
    return cardNumber
  }
  
  func getCCV() throws -> String {
    let cardNumber = try getCardNumber()
    
    let cardBrand = STPCardValidator.brand(forNumber: cardNumber)
    
    let ccv = ccvTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if ccv.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.CCVEmpty, ccvTextField)
    }
    
    switch STPCardValidator.validationState(forCVC: ccv, cardBrand: cardBrand) {
    case .invalid:
      throw UserValidationError.invalidField(Constants.ErrorMessages.CCVInvalid, ccvTextField)
    case .incomplete:
      throw UserValidationError.invalidField(Constants.ErrorMessages.CCVIncomplete, ccvTextField)
    default:
      break
    }
    
    return ccv
  }
  
  func getMMYY() throws -> (UInt, UInt) {
    let mmyy = mmyyTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if mmyy.isEmpty {
      throw UserValidationError.invalidField(Constants.ErrorMessages.MMYYEmpty, mmyyTextField)
    }
    
    guard let month = getMonth(from: mmyy) else {
      throw UserValidationError.invalidField(Constants.ErrorMessages.MonthEmpty, mmyyTextField)
    }
    
    guard let year = getYear(from: mmyy) else {
      throw UserValidationError.invalidField(Constants.ErrorMessages.YearEmpty, mmyyTextField)
    }
    
    switch STPCardValidator.validationState(forExpirationMonth: month) {
    case .invalid:
      throw UserValidationError.invalidField(Constants.ErrorMessages.MonthInvalid, mmyyTextField)
    case .incomplete:
      throw UserValidationError.invalidField(Constants.ErrorMessages.MonthIncomplete, mmyyTextField)
    default:
      break
    }
    
    switch STPCardValidator.validationState(forExpirationYear: year, inMonth: month) {
    case .invalid:
      throw UserValidationError.invalidField(Constants.ErrorMessages.YearInvalid, mmyyTextField)
    case .incomplete:
      throw UserValidationError.invalidField(Constants.ErrorMessages.YearIncomplete, mmyyTextField)
    default:
      break
    }
    
    return (UInt(month) ?? 0, UInt(year) ?? 0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    payButton.isEnabled = true
    
    constraint = verticalConstraint
    internalView = view
    rootViewFrame = view.frame
    
    errorMessageLabel.isHidden = true
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    //    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    blurView.makeMeBlur()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.payButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.payButton.bounds
    maskLayer.path = maskPath.cgPath
    self.payButton.layer.mask = maskLayer
    
    configureTextFields()
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  func configureTextFields() {
    cardNameTextField.addBottomLine(color: UIColor.zentaiGray)
    cardNumberTextField.addBottomLine(color: UIColor.zentaiGray)
    ccvTextField.addBottomLine(color: UIColor.zentaiGray)
    mmyyTextField.addBottomLine(color: UIColor.zentaiGray)
  }
  
  func viewTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  func getMonth(from: String) -> String? {
    let array = from.components(separatedBy: "/")
    let month = array[0]
    
    if month.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
      return nil
    }
    
    return month
  }
  
  func getYear(from: String) -> String? {
    let array = from.components(separatedBy: "/")
    
    if array.count <= 1 {
      return nil
    }
    
    let year = array[1]
    
    if year.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
      return nil
    }
    
    return year
  }
  
  @IBAction func payCardButtonTouched(_ sender: AnyObject) {
    payButton.isEnabled = false
    
    do {
      let cardName = try getCardName()
      let cardNumber = try getCardNumber()
      let ccv = try getCCV()
      let mmyy = try getMMYY()
      
      let cardParams = STPCardParams()
      cardParams.name = cardName
      cardParams.number = cardNumber
      cardParams.expMonth = mmyy.0
      cardParams.expYear = mmyy.1
      cardParams.cvc = ccv
      
      print(cardParams)
      
      var stripeToken: STPToken?
      
      //      SVProgressHUD.show()
      Spinner.show(currentViewController: self)
      
      Ax.serial(
        tasks: [
          { done in
            FIRCrashMessage("2:Creating stripe token")
            STPAPIClient.shared().createToken(withCard: cardParams, completion: { (token, error) in
              if let error = error {
                done(error as? NSError)
                return
              }
              
              if token == nil {
                done(NSError(domain: "PaymentDomain", code: 401, userInfo: [NSLocalizedDescriptionKey: "Stripe token not found."]))
                return
              }
              
              stripeToken = token
              done(nil)
            })
          },
          
          // Add a task here or in viewdidload, think about it, getting the user
          { done in
            FIRCrashMessage("3:Getting User")
            _ = User.getCurrentUser(once: true, navigationController: self.navigationController, completion: { (user) in
              if let user = user {
                self.currentUser = user
                done(nil)
              } else {
                done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user found."]))
              }
            })
          },
          
          
          { done in
            
            guard let currentUser = self.currentUser else {
              done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user found."]))
              return
            }
            
            guard let stripeToken = stripeToken else {
              done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No stripe token found."]))
              return
            }
            
            guard let userEmail = currentUser.email else {
              done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user email found."]))
              return
            }
            
            guard let userId = currentUser.id else {
              done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "No user id found."]))
              return
            }
            
            FIRCrashMessage("4:Updating stripe token to user: \(userEmail)")
            let urlString = Constants.Server.accountsURL
            let data: [String: Any] = [
              "stripeToken": stripeToken.stripeID,
              "email": userEmail,
              "userId": userId
            ]
            print(data)
            
            Alamofire.request(
              urlString,
              method: .post,
              parameters: data,
              encoding: JSONEncoding.default
              )
              .validate()
              .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let data):
                  let json = JSON(data)
                  
                  if json["error"].boolValue {
                    done(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: json["message"].stringValue]))
                  } else {
                    User.current?.stripeId = json["customerId"].stringValue
                    User.current?.last4 = cardParams.last4()
                    done(nil)
                  }
                case .failure(let error):
                  done(error as NSError?)
                }
              })
          }
        ],
        result: { (error) in
          self.payButton.isEnabled = true
          print(error)
          Spinner.dismiss()
          DispatchQueue.main.async {
            if let error = error {
              FIRCrashMessage("5: Error: \(error.localizedDescription)")
              self.show(errorMessage: error.localizedDescription, completion: {_ in})
            } else {
              let temp = self.presentingViewController as? AdditionalPromoViewController
              self.dismiss(animated: true) {
                temp?.dismiss(animated: true, completion: nil)
              }
            }
          }
        }
      )
      
    } catch UserValidationError.invalidField(let errorMessage, let view) {
      payButton.isEnabled = true
      show(errorMessage: errorMessage, completion: { (success) in
        if success {
          DispatchQueue.main.async {
            view.shake()
            view.addBottomLine(color: UIColor.zentaiPrimaryColor)
          }
        }
      })
    } catch {
      show(errorMessage: error.localizedDescription, completion: {_ in})
    }
  }
  
  @IBAction func closeButton() {
    dismiss(animated: true, completion: nil)
  }
  
  func hideError(completion: @escaping (Bool) -> Void) {
    UIView.animate(withDuration: 0.3, animations: {
      self.errorMessageLabel.isHidden = true
      }, completion: completion)
  }
  
  func show(errorMessage: String, completion:  @escaping (Bool) -> Void){
    self.errorMessageLabel.text = errorMessage
    
    UIView.animate(withDuration: 0.3, animations: {
      DispatchQueue.main.async {
        self.errorMessageLabel.isHidden = false
      }
      }, completion: completion)
  }
  
}

extension PaymentViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}


extension PaymentViewController {
  
  override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField === mmyyTextField {
      let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
      print(string)
      print(newString)
      
      if newString.characters.count == 2 {
        let isDelete = string == "" && range.length == 1
        
        if isDelete {
          textField.text = newString
          textField.text?.characters.removeLast()
        } else {
          textField.text = "\(newString)/"
        }
        
        return false
      }
      
      //      if newString.characters.count == 3 {
      //        let isDelete = string == "" && range.length == 1
      //
      //        if isDelete {
      //          textField.text?.characters.removeLast()
      //          textField.text?.characters.removeLast()
      //        }
      //
      //        return false
      //      }
    }
    
    
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    currentTextField = textField
    
    hideError(completion: { success in
      if success {
        self.configureTextFields()
      }
    })
    
    return true
  }
}























































