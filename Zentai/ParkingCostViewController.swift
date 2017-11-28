//
//  ParkingCostViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/22/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

class ParkingCostViewController: ModalViewController {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var amountTextField: PLCurrencyTextField!
  @IBOutlet weak var okButton: UIButton!
  
  let numberFomatter = Constants.numberFormatter
  
  var parkingCost: Double?
  var setParkingCost: (Double?) -> Void = { _ in }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    internalView = view
    rootViewFrame = view.frame
    
    currentTextField = amountTextField
    
    if let parkingCost = parkingCost {
      
      if parkingCost <= 0 {
        amountTextField.text = ""
      } else {
        amountTextField.text = String(parkingCost)
      }
      
      amountTextField.initValue()
    } else {
      amountTextField.text = ""
    }
    
    //    numberFomatter.numberStyle = .currency
    //    numberFomatter.locale = Locale(identifier: "en")
    //    numberFomatter.maximumFractionDigits = 0
    
    amountTextField.locale = numberFomatter.locale
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    addDoneButtonOnKeyboardIn(textField: amountTextField)
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    blurView.makeMeBlur()
  }
  
  func viewTapped() {
    view.endEditing(true)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    amountTextField.addBottomLine(color: UIColor.zentaiGray)
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  @IBAction func okButtonTouched() {
    if let parkingCost = amountTextField.numberValue {
      setParkingCost(Double(parkingCost))
    } else {
      setParkingCost(Double(0))
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension ParkingCostViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}


extension ParkingCostViewController {
  //  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
  //    if (parkingCost ?? 0) == 0 {
  //      textField.text = ""
  //    }
  //
  //    return true
  //  }
  
  override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
    //
    //    if newString.characters.first == Character.init("$") {
    //      newString = String(newString.characters.dropFirst(1))
    //    }
    //
    //    if let number = Double(newString) {
    //      textField.text = numberFomatter.string(from: number as NSNumber)
    //    }
    //    
    return true
  }
}




















