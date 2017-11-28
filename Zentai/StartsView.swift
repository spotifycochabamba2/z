//
//  StartsView.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/13/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

enum StartsViewState {
  case onlyRead
  case canTouchStars
}

class StartsView: UIView {
  
  var state = StartsViewState.onlyRead {
    didSet {
      if state == .canTouchStars {
        firstStar.isUserInteractionEnabled = true
        secondStar.isUserInteractionEnabled = true
        thirdStar.isUserInteractionEnabled = true
        fourthStar.isUserInteractionEnabled = true
        fifthStar.isUserInteractionEnabled = true
      } else {
        firstStar.isUserInteractionEnabled = false
        secondStar.isUserInteractionEnabled = false
        thirdStar.isUserInteractionEnabled = false
        fourthStar.isUserInteractionEnabled = false
        fifthStar.isUserInteractionEnabled = false
      }
    }
  }
  
  @IBOutlet var view: UIView!
  @IBOutlet weak var firstStar: UIImageView!
  @IBOutlet weak var secondStar: UIImageView!
  @IBOutlet weak var thirdStar: UIImageView!
  @IBOutlet weak var fourthStar: UIImageView!
  @IBOutlet weak var fifthStar: UIImageView!
  
  var rate: UInt = 0 {
    didSet {
      switch rate {
      case 1:
        firstStar.image = UIImage(named: "active-star-icon")
        
        secondStar.image = UIImage(named: "inactive-star-icon")
        thirdStar.image = UIImage(named: "inactive-star-icon")
        fourthStar.image = UIImage(named: "inactive-star-icon")
        fifthStar.image = UIImage(named: "inactive-star-icon")
        
      case 2:
        firstStar.image = UIImage(named: "active-star-icon")
        secondStar.image = UIImage(named: "active-star-icon")
        
        thirdStar.image = UIImage(named: "inactive-star-icon")
        fourthStar.image = UIImage(named: "inactive-star-icon")
        fifthStar.image = UIImage(named: "inactive-star-icon")
        
      case 3:
        firstStar.image = UIImage(named: "active-star-icon")
        secondStar.image = UIImage(named: "active-star-icon")
        thirdStar.image = UIImage(named: "active-star-icon")
        
        fourthStar.image = UIImage(named: "inactive-star-icon")
        fifthStar.image = UIImage(named: "inactive-star-icon")
        
      case 4:
        firstStar.image = UIImage(named: "active-star-icon")
        secondStar.image = UIImage(named: "active-star-icon")
        thirdStar.image = UIImage(named: "active-star-icon")
        fourthStar.image = UIImage(named: "active-star-icon")
        
        fifthStar.image = UIImage(named: "inactive-star-icon")
        
      case 5:
        firstStar.image = UIImage(named: "active-star-icon")
        secondStar.image = UIImage(named: "active-star-icon")
        thirdStar.image = UIImage(named: "active-star-icon")
        fourthStar.image = UIImage(named: "active-star-icon")
        fifthStar.image = UIImage(named: "active-star-icon")
        
      default:
        firstStar.image = UIImage(named: "inactive-star-icon")
        secondStar.image = UIImage(named: "inactive-star-icon")
        thirdStar.image = UIImage(named: "inactive-star-icon")
        fourthStar.image = UIImage(named: "inactive-star-icon")
        fifthStar.image = UIImage(named: "inactive-star-icon")
      }
    }
  }
  
  func firstStartTouched() {
    rate = 1
  }
  
  func secondStartTouched() {
    rate = 2
  }
  
  func thirdStartTouched() {
    rate = 3
  }
  
  func fourthStartTouched() {
    rate = 4
  }
  
  func fifthStartTouched() {
    rate = 5
  }
  
  
  
  func setup() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "StartsView", bundle: bundle)
    view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    
    view.frame = bounds
    
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    let firstStartGestureRecog = UITapGestureRecognizer(target: self, action: #selector(firstStartTouched))
    firstStartGestureRecog.numberOfTapsRequired = 1
    firstStartGestureRecog.numberOfTouchesRequired = 1
    firstStar.addGestureRecognizer(firstStartGestureRecog)
    
    
    let secondStartGestureRecog = UITapGestureRecognizer(target: self, action: #selector(secondStartTouched))
    secondStartGestureRecog.numberOfTouchesRequired = 1
    secondStartGestureRecog.numberOfTapsRequired = 1
    secondStar.addGestureRecognizer(secondStartGestureRecog)
    
    let thirdStartGestureRecog = UITapGestureRecognizer(target: self, action: #selector(thirdStartTouched))
    thirdStartGestureRecog.numberOfTapsRequired = 1
    thirdStartGestureRecog.numberOfTouchesRequired = 1
    thirdStar.addGestureRecognizer(thirdStartGestureRecog)
    
    let fourthStartGestureRecog = UITapGestureRecognizer(target: self, action: #selector(fourthStartTouched))
    fourthStartGestureRecog.numberOfTouchesRequired = 1
    fourthStartGestureRecog.numberOfTapsRequired = 1
    fourthStar.addGestureRecognizer(fourthStartGestureRecog)
    
    let fifthStartGestureRecog = UITapGestureRecognizer(target: self, action: #selector(fifthStartTouched))
    fifthStartGestureRecog.numberOfTapsRequired = 1
    fifthStartGestureRecog.numberOfTouchesRequired = 1
    fifthStar.addGestureRecognizer(fifthStartGestureRecog)
    
    addSubview(view)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setup()
  }
}
