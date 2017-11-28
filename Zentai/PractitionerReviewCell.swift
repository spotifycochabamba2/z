//
//  PractitionerReviewCell.swift
//  zentai
//
//  Created by Wilson Balderrama on 3/8/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class PractitionerReviewCell: UITableViewCell {
  
  @IBOutlet weak var reviewerNameLabel: UILabel!
  @IBOutlet weak var dateCreationLabel: UILabel!
  @IBOutlet weak var commentsTextView: UITextView!
  
  
  var reviewerName: String? {
    didSet {
      reviewerNameLabel.text = reviewerName
    }
  }
  
  var dateCreation: Date? {
    didSet {
      if let dateCreation = dateCreation {
        dateCreationLabel.text = Utils.format(date: dateCreation)
      }
    }
  }
  
  var comments: String? {
    didSet {
      commentsTextView.text = comments
    }
  }
  
}
