//
//  AgreeViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/24/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

class AgreeViewController: UIViewController {
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var agreeButton: UIButton!
  
  var agreeRead: () -> Void = { }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    blurView.makeMeBlur()
    
    configureTextView()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.agreeButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.agreeButton.bounds
    maskLayer.path = maskPath.cgPath
    self.agreeButton.layer.mask = maskLayer
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  @IBAction func agreeButtonTouched() {
    dismiss(animated: true, completion: nil)
    agreeRead()
  }
  
  func viewTapped() {
    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
}




extension AgreeViewController {
  
  
  func configureTextView() {
    let paragrahStyle = NSMutableParagraphStyle()
    paragrahStyle.alignment = .center
    
    let attributes = [
      NSParagraphStyleAttributeName: paragrahStyle,
      NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
      ] as [String : Any]
    
    let linkAttributes = [
      NSForegroundColorAttributeName: UIColor.zentaiSecondaryColor
    ]
    
    let string = "By creating a Zentai account, \n you agree to Zentai's Terms of Use \n and \n Privacy Policy."
    
    //    let font = UIFont(name: "SanFranciscoText-Light", size: 19.0)
    
    let attributedString = NSMutableAttributedString(
      string: string,
      attributes: attributes)
    
    attributedString.addAttribute(NSLinkAttributeName, value: "terms://terms", range: (string as NSString).range(of: "Terms of Use"))
    attributedString.addAttribute(NSLinkAttributeName, value: "privacy://privacy", range: (string as NSString).range(of: "Privacy Policy"))
    
    textView.linkTextAttributes = linkAttributes
    textView.attributedText = attributedString
    textView.delegate = self
  }
  
  
}

extension AgreeViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if let scheme = URL.scheme {
      if scheme == "terms" {
        performSegue(withIdentifier: Storyboard.AgreeToTerms, sender: nil)
      } else if scheme == "privacy" {
        performSegue(withIdentifier: Storyboard.AgreeToPrivacy, sender: nil)
      }
    }
    
    return false
  }
}




































