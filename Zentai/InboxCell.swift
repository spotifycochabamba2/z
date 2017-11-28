//
//  File.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/16/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SDWebImage

class InboxCell: UITableViewCell {
  @IBOutlet internal weak var nameLabel: UILabel!
  @IBOutlet internal weak var messageLabel: UILabel!
  @IBOutlet internal weak var photoImageView: UIImageView! {
    didSet {
      photoImageView.layer.cornerRadius = 70 / 2
      photoImageView.layer.borderColor = UIColor.gray.cgColor
      photoImageView.layer.borderWidth = 1.0
      photoImageView.layer.masksToBounds = true
      
      
    }
  }
  
  var seen = false {
    didSet {
      if seen {
        setSeen()
      } else {
        setUnseen()
      }
    }
  }
  
  public var name: String? {
    didSet {
      nameLabel.text = name
    }
  }
  
  public var message: String? {
    didSet {
      messageLabel.text = message
    }
  }
  
  public var photoURL: String? {
    didSet {
      photoImageView.sd_setImage(with: URL(string: photoURL!), placeholderImage: UIImage(named: "person-default"), options: [], completed: { (image: UIImage?, error: Error?, type: SDImageCacheType, url: URL?) in
        self.seen = self.seen
      })
    }
  }
  
  func setSeen() {
    if let image = photoImageView.image {
      let ciImage = CIImage(image: image)
      let blackImage = ciImage?.applyingFilter("CIColorControls", withInputParameters: [kCIInputSaturationKey: 0.0])
      DispatchQueue.main.async {
        if let blackImage = blackImage {
          self.photoImageView.image = UIImage(ciImage: blackImage)
        }
      }
    }
    
    DispatchQueue.main.async {
      self.nameLabel.textColor = Utils.hexStringToUIColor(hex: "#bbbbbb")
      self.messageLabel.textColor = Utils.hexStringToUIColor(hex: "#bbbbbb")
    }
  }
  
  func setUnseen() {
    if let image = photoImageView.image {
      let ciImage = CIImage(image: image)
      let blackImage = ciImage?.applyingFilter("CIColorControls", withInputParameters: [kCIInputSaturationKey: 1.0])
      DispatchQueue.main.async {
        if let blackImage = blackImage {
          self.photoImageView.image = UIImage(ciImage: blackImage)
        }
      }
    }
    
    DispatchQueue.main.async {
      self.nameLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
      self.messageLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
  }
  
}

extension Bool {
  static func random() -> Bool {
    return arc4random_uniform(2) == 0
  }
}






