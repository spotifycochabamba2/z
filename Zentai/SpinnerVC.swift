//
//  SpinnerVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 4/11/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class SpinnerVC: UIViewController {
  var timer = Timer()
  var rotAngle: CGFloat = 0.0
  @IBOutlet weak var blurryView: UIView!
  
  
  deinit {
    timer.invalidate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    activateTimer()
    
    view.backgroundColor = .clear
    blurryView.backgroundColor = .clear
    blurryView.alpha = 1
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    blurEffectView.frame = blurryView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    blurryView.addSubview(blurEffectView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    blurryView.layer.borderWidth = 1
    blurryView.layer.cornerRadius = 10
    blurryView.layer.masksToBounds = true
  }
  
  @IBOutlet weak var imageView: UIImageView!
  
  func activateTimer() {
    //(1)
    timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(updateCounter), userInfo: nil, repeats: true)
  }
  
  func updateCounter() {
    //(2)
    let rotateLeft: Bool = true
    if rotateLeft {
      rotAngle -= 30.0
    } else {
      rotAngle += 30.0
    }
    //(3)
    
    UIView.animate(withDuration: 2.0, animations: {
      self.imageView.transform = CGAffineTransform(rotationAngle: (self.rotAngle * CGFloat(M_PI)) / 180.0)
    })
  }
  
}
