//
//  UITextFieldExtension.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/21/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit

extension UITextField {
  //  func addBottomLine(color: UIColor) {
  //
  //    let line = CALayer()
  //    let borderWidth = CGFloat(3.0)
  //    line.borderColor = color.cgColor
  //    line.frame = CGRect(
  //      x: 0,
  //      y: self.frame.size.height - borderWidth,
  //      width: self.frame.size.width,
  //      height: self.frame.size.height)
  //    line.borderWidth = borderWidth
  //
  //    self.layer.addSublayer(line)
  //    self.layer.masksToBounds = true
  //  }
}

extension UIView {
  func addBottomLine(color: UIColor) {
    
    let line = CALayer()
    let borderWidth = CGFloat(1.0)
    line.borderColor = color.cgColor
    line.frame = CGRect(
      x: 0,
      y: self.frame.size.height - borderWidth,
      width: self.frame.size.width,
      height: self.frame.size.height)
    line.borderWidth = borderWidth
    
    self.layer.addSublayer(line)
    self.layer.masksToBounds = true
  }
}

extension UIColor {
  static var zentaiPrimaryColor: UIColor {
    return hexStringToUIColor(hex: "#ff5a60")
  }
  
  static var zentaiSecondaryColor: UIColor {
    return hexStringToUIColor(hex: "#087e8a")
  }
  
  static var zentaiSecondaryColorOpaque: UIColor {
    return hexStringToUIColor(hex: "#B5D8DC")
  }
  
  static var zentaiGray: UIColor {
    return hexStringToUIColor(hex: "#bbbbbb")
  }
  
  static func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}

