//
//  ParkingInstructionsViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/22/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

class ParkingInstructionsViewController: ModalViewController {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var instructionsTextView: UITextView!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var noneButton: UIButton!
  
  @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
  
  var instructions: String?
  var setInstructions: (String?) -> Void = { _ in }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    blurView.tag = 1
    internalView = view
    rootViewFrame = view.frame
    
    currentTextField = instructionsTextView
    constraint = verticalConstraint
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    instructionsTextView.autocorrectionType = .no
    instructionsTextView.text = Constants.Texts.parkingInstructionsText
    instructionsTextView.textColor = UIColor.zentaiGray
    
    if let instructions = instructions {
      instructionsTextView.text = instructions
      instructionsTextView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
    
    addDoneButtonOnKeyboardIn(textView: instructionsTextView)
    
    blurView.makeMeBlur()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    let maskPath2: UIBezierPath = UIBezierPath(roundedRect: self.noneButton.bounds, byRoundingCorners: ([.bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer2: CAShapeLayer = CAShapeLayer()
    maskLayer2.frame = self.noneButton.bounds
    maskLayer2.path = maskPath2.cgPath
    self.noneButton.layer.mask = maskLayer2
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
    
    instructionsTextView.addBottomLine(color: UIColor.zentaiGray)
  }
  
  func viewTapped() {
    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func noneButtonTouched() {
    instructionsTextView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    let instructions = "None"
    
    instructionsTextView.text = instructions
    setInstructions(instructions)
    
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func okButtonTouched(_ sender: AnyObject) {
    let text = instructionsTextView.text.trimmingCharacters(in: CharacterSet.whitespaces)
    if text.isEmpty || text == Constants.Texts.parkingInstructionsText {
      setInstructions(nil)
    } else {
      setInstructions(text)
    }
    
    dismiss(animated: true, completion: nil)
  }
}

extension ParkingInstructionsViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.Texts.parkingInstructionsText {
      textView.text = nil
      textView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = Constants.Texts.parkingInstructionsText
      textView.textColor = UIColor.zentaiGray
    }
    
    textView.resignFirstResponder()
  }
  
  override func addDoneButtonTouched(_ button: UIBarButtonItem) {
    super.addDoneButtonTouched(button)
    
    //    okButtonTouched(okButton)
  }
}

extension UIViewController: UITextFieldDelegate {
  
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  func addDoneButtonOnKeyboardIn(textView: UITextView) {
    textView.inputAccessoryView = createKeyboardToolbar()
  }
  
  func addDoneButtonOnKeyboardIn(textField: UITextField) {
    textField.inputAccessoryView = createKeyboardToolbar()
  }
  
  func createKeyboardToolbar() -> UIToolbar {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let doneBarButton = UIBarButtonItem(title: "▼", style: .plain, target: self, action: #selector(addDoneButtonTouched(_:)))
    
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    
    return keyboardToolbar
  }
  
  func addDoneButtonTouched(_ sender: UIBarButtonItem) {
    self.view.endEditing(true)
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

extension ParkingInstructionsViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}




















