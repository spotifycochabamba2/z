//
//  AdditionalPromoViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/2/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

enum PaymentPromo {
  case none
  case twenty
  case fiftheen
}

class AdditionalPromoViewController: UIViewController {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var okButton: UIButton!
  
  @IBOutlet weak var optionOneButton: UIButton!
  @IBOutlet weak var optionTwoButton: UIButton!
  @IBOutlet weak var optionThreeButton: UIButton!
  
  var setCard: (String?) -> Void = { _ in
    
  }
  
  var promoSelected: PaymentPromo? {
    didSet {
      if let promo = promoSelected {
        switch promo {
        case .none:
          optionOneButton.backgroundColor = UIColor.zentaiSecondaryColor
          optionTwoButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          optionThreeButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          
        case .twenty:
          optionOneButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          optionTwoButton.backgroundColor = UIColor.zentaiSecondaryColor
          optionThreeButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .fiftheen:
          optionOneButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          optionTwoButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          optionThreeButton.backgroundColor = UIColor.zentaiSecondaryColor
        }
      }
    }
  }
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    viewTapGestureRecognizer.delegate = self
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    blurView.makeMeBlur()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    optionOneButton.makeMeCircled()
    optionTwoButton.makeMeCircled()
    optionThreeButton.makeMeCircled()
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  func viewTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func optionOneButtonTouched() {
    promoSelected = PaymentPromo.none
  }
  
  @IBAction func optionTwoButtonTouched() {
    promoSelected = .twenty
  }
  
  @IBAction func optionThreeButtonTouched() {
    promoSelected = .fiftheen
  }
  
  @IBAction func okButtonTouched() {
    
    if let promoSelected = promoSelected {
      print(promoSelected)
      performSegue(withIdentifier: Storyboard.AdditionalToPayment, sender: nil)
    } else {
      optionOneButton.shake()
      optionTwoButton.shake()
      optionThreeButton.shake()
    }
  }
}

extension AdditionalPromoViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view?.isDescendant(of: blurView) ?? false
  }
}



























