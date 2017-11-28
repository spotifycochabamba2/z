//
//  ZCellView.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/23/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ZCellView: JTAppleDayCellView {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var circleView: UIView!
  
  let gray = UIColor.hexStringToUIColor(hex: "#bbbbbb")
  let black = UIColor.hexStringToUIColor(hex: "#484646")
  
  var hasAnySession = false {
    didSet {
      circleView.layer.cornerRadius = 3
      
      DispatchQueue.main.async {
        self.circleView.isHidden = !self.hasAnySession
      }
    }
  }
  
  var isWeekDay = false {
    didSet {
      DispatchQueue.main.async {
        if self.isWeekDay {
          self.dayLabel.textColor = self.black
        } else {
          self.dayLabel.textColor = self.gray
        }
      }
    }
  }
  
  var isSelected = false {
    didSet {
      selectedView.layer.cornerRadius = 25
      
      DispatchQueue.main.async {
        if self.isSelected {
          self.selectedView.isHidden = false
          self.dayLabel.textColor = .white
        } else {
          self.selectedView.isHidden = true
        }
      }
    }
  }
  
}

