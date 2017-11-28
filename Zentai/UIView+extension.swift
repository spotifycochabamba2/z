//
//  UIView+extension.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/23/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

extension UIView {
  func shake() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.05
    animation.repeatCount = 5
    animation.autoreverses = false
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }
}
