//
//  PractitionerReviews.swift
//  zentai
//
//  Created by Wilson Balderrama on 2/15/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Ax

class PractitionerReviewsVC: UIViewController {
  
  var cellId = "CellReviewId"
  var session: Session?
  
  @IBOutlet weak var clientNameLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  var commentsHelpView: UIView?
  
  @IBOutlet weak var starsView: StartsView!
  
  @IBOutlet weak var commentsInfoButton: UIButton!
  
  var reviews = [Review]() {
    didSet {
      
      DispatchQueue.main.async { [unowned self] in
        self.tableView.reloadData()
      }
      
    }
  }
  
  
  var deselectRowOnPractitionerCalendarVC: () -> () = {}
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let userName = session?.clientName {
      clientNameLabel.text = userName
    }
    
    if let userId = session?.clientId {
      
      //      SVProgressHUD.show()
      Spinner.show(currentViewController: self)
      
      Ax.parallel(tasks: [
        { done in
          User.getReviews(fromUserId: userId, completion: { [unowned self] (reviews) in
            print(reviews)
            
            self.reviews = reviews
            done(nil)
            })
        },
        
        { done in
          Review.getTotalReviews(
            userId: userId,
            completion: { (error, rate) in
              
              if error === nil {
                DispatchQueue.main.async {
                  self.starsView.rate = UInt(rate)
                }
              }
              
              done(nil)
          })
        }
        ], result: { (error) in
          Spinner.dismiss()
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
    
    clientNameLabel.text = ""
    
    let viewTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecog.numberOfTapsRequired = 1
    viewTapGestureRecog.numberOfTouchesRequired = 1
    view.addGestureRecognizer(viewTapGestureRecog)
  }
  
  func createInfoPopup(root: UIView, item: UIView, witdh: Double, height: Double) -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: witdh, height: height))
    view.alpha = 0
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.applyBlackTransparentShadow()
    view.makeMeRounded()
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: witdh, height: height))
    label.font = UIFont(name: "SanFranciscoText-Light", size: 15)
    label.text = "Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text "
    label.backgroundColor = .white
    //    label.adjustsFontSizeToFitWidth = true
    label.numberOfLines = 6
    //    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    
    //    root.addConstraint(NSLayoutConstraint(
    //      item: view,
    //      attribute: .top,
    //      relatedBy: .equal,
    //      toItem: item,
    //      attribute: .bottom,
    //      multiplier: 1.0,
    //      constant: 10)
    //    )
    
    view.addSubview(label)
    
    let verticalConstraint = "V:|-10-[label]-10-|"
    let horizontalConstraint = "H:|-10-[label]-10-|"
    
    view.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: verticalConstraint,
        options: [],
        metrics: nil,
        views: ["label": label]
      )
    )
    
    view.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: horizontalConstraint,
        options: [],
        metrics: nil,
        views: ["label": label]
      )
    )
    
    
    root.addSubview(view)
    
    root.addConstraint(NSLayoutConstraint(
      item: view,
      attribute: .top,
      relatedBy: .equal,
      toItem: item,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 10)
    )
    
    root.addConstraint(NSLayoutConstraint(
      item: view,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: item,
      attribute: .centerX,
      multiplier: 1.0,
      constant: 0)
    )
    
    view.addConstraint(NSLayoutConstraint(
      item: view,
      attribute: .width,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: CGFloat(witdh))
    )
    
    view.addConstraint(NSLayoutConstraint(
      item: view,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: CGFloat(height))
    )
    
    return view
  }
  
  @IBAction func commentsInfoButtonTouched() {
    if commentsHelpView == nil {
      self.commentsHelpView = createInfoPopup(root: view, item: commentsInfoButton, witdh: 150, height: 100)
    }
    
    if let commentsHelpView = commentsHelpView {
      if commentsHelpView.alpha == 0 {
        showView(view: commentsHelpView)
      } else {
        hideView(view: commentsHelpView)
      }
    }
  }
  
  
  func viewTapped() {
    if let commentsHelpView = commentsHelpView {
      hideView(view: commentsHelpView)
    }
  }
  
  func showView(view: UIView) {
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        view.alpha = 1
      },
      completion: nil)
  }
  
  func hideView(view: UIView) {
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        view.alpha = 0
      },
      completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    commentsInfoButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
  }
  
  @IBAction func close() {
    deselectRowOnPractitionerCalendarVC()
    dismiss(animated: true, completion: nil)
  }
  
}

extension PractitionerReviewsVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PractitionerReviewCell
    let review = reviews[indexPath.row]
    
    cell.reviewerName = review.reviewerName
    cell.dateCreation = review.creationDate
    cell.comments = review.comments
    
    return cell
  }
  
}





















