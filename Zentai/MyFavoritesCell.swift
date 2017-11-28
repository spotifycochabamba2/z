//
//  MyFavoritesCell.swift
//  zentai
//
//  Created by Wilson Balderrama on 4/17/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class MyFavoritesCell: UITableViewCell {
  
  static let cellId = "myFavoritesCellId"
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView! {
    didSet {
      userImageView.contentMode = .scaleAspectFit
      userImageView.layer.cornerRadius = 35
      userImageView.layer.borderColor = UIColor.clear.cgColor
      userImageView.layer.borderWidth = 1
      userImageView.layer.masksToBounds = true
    }
  }
  
  
  var username = "" {
    didSet {
      usernameLabel.text = username
    }
  }
  
  var imageURL: String? {
    didSet {
      if let url = URL(string: imageURL ?? "") {
        userImageView.sd_setImage(with: url)
      }
    }
  }
}
