//
//  ReportBugVC.swift
//  Zentai
//
//  Created by Wilson Balderrama on 11/15/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportBugVC: ModalViewController {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  
  @IBOutlet weak var okButton: UIButton!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentTextField = descriptionTextView
    
    blurView.tag = 1
    internalView = view
    rootViewFrame = view.frame
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    descriptionTextView.autocorrectionType = .no
    descriptionTextView.text = Constants.Texts.reportBugPlaceholderText
    descriptionTextView.textColor = UIColor.zentaiGray
    
    addDoneButtonOnKeyboardIn(textView: descriptionTextView)
    
    blurView.makeMeBlur()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
    
    descriptionTextView.addBottomLine(color: UIColor.zentaiGray)
  }
  
  @IBAction func cancelButtonTapped() {
    viewTapped()
  }
  
  func viewTapped() {
    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func sendButtonTouched(_ sender: UIButton) {
    var description = descriptionTextView.text.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if description == Constants.Texts.reportBugPlaceholderText {
      description = ""
    }
    
    guard description.characters.count > 0 else {
      let alert = UIAlertController(title: "Error", message: "Description is empty.", preferredStyle: .alert)
      alert.view.tintColor = UIColor.zentaiSecondaryColor
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    guard let currentUserId = User.currentUserId else {
      let alert = UIAlertController(title: "Error", message: "User Id is empty", preferredStyle: .alert)
      alert.view.tintColor = UIColor.zentaiSecondaryColor
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    SVProgressHUD.show()
    User.reportBug(
      description: description,
      userId: currentUserId) { (error) in
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        if let error = error {
          let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          alert.view.tintColor = UIColor.zentaiSecondaryColor
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
          return
        } else {
          self.viewTapped()
        }
    }
  }
  
}

extension ReportBugVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.Texts.reportBugPlaceholderText {
      textView.text = nil
      textView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = Constants.Texts.reportBugPlaceholderText
      textView.textColor = UIColor.zentaiGray
    }
    
    textView.resignFirstResponder()
  }
  
  override func addDoneButtonTouched(_ button: UIBarButtonItem) {
    super.addDoneButtonTouched(button)
    
  }
}



extension ReportBugVC: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}
















