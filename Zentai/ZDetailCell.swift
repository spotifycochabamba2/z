//
//  ZDetailCell.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/24/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class ZDetailCell: UITableViewCell {
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var clientNameLabel: UILabel!
  
  var time = "" {
    didSet {
      timeLabel.text = time
    }
  }
  
  var clientName = "" {
    didSet {
      clientNameLabel.text = "\(clientName) 60-Mins Session"
    }
  }
  
}
