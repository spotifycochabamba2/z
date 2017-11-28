//
//  PractitionerReviewVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 2/14/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import Ax
import SVProgressHUD

class PractitionerReviewVC: UIViewController {
  
  var reviewerUserId: String?
  var reviewerUsername: String?
  var reviewedUserId: String?
  var reviewedUsername: String?
  var sessionId: String?
  
  var user: User?
  var closePractitionerCheckInVC: () -> Void = {}
  
  @IBOutlet weak var clientNameLabel: UILabel! {
    didSet {
      clientNameLabel.text = ""
    }
  }
  
  var hideCloseButton = true
  
  var commentsHelpView: UIView?
  
  @IBOutlet weak var cancelButton: UIButton! {
    didSet {
      cancelButton.isHidden = true
    }
  }
  
  @IBOutlet weak var commentZTextView: ZTextView!
  @IBOutlet weak var starsView: StartsView!
  
  @IBOutlet weak var commentsInfoButton: UIButton!
  
  @IBOutlet weak var saveButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cancelButton.isHidden = hideCloseButton
    commentZTextView.delegate = self
    
    let viewTapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecog.numberOfTapsRequired = 1
    viewTapGestureRecog.numberOfTouchesRequired = 1
    view.addGestureRecognizer(viewTapGestureRecog)
    
    starsView.state = .canTouchStars
    
    saveButton.makeMeRounded()
    
    commentZTextView.text = Constants.Texts.practitionerReviewDescription
    commentZTextView.textColor = .zentaiGray
    
    addDoneButtonOnKeyboardIn(textView: commentZTextView)
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    SVProgressHUD.show()
    
    Ax.parallel(tasks: [
      
      { [weak self] done in
        if let reviewerUserId = self?.reviewerUserId {
          
          _ = User.getUser(
            by: reviewerUserId,
            once: true,
            completion: { (reviewerUser) in
              if let reviewerUser = reviewerUser {
                self?.reviewerUsername = reviewerUser.firstName
              }
              done(nil)
            }
          )
        } else {
          done(nil)
        }
      },
      
      
      { [weak self] done in
        if let reviewedUserId = self?.reviewedUserId {
          
          _ = User.getUser(
            by: reviewedUserId,
            once: true,
            completion: { (reviewedUser) in
              
              if let reviewedUser = reviewedUser {
                
                DispatchQueue.main.async {
                  print(reviewedUser.firstName)
                  self?.clientNameLabel.text = reviewedUser.firstName
                }
              }
              done(nil)
            }
          )
          
        } else{
          done(nil)
        }
      }
      
    ]) { (error) in
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    commentsInfoButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
  }
  
  func viewTapped() {
    if let commentsHelpView = commentsHelpView {
      hideView(view: commentsHelpView)
    }
    
    view.endEditing(true)
  }
  
  @IBAction func cancelButtton() {
    dismiss(animated: true)
  }
  
  @IBAction func saveButtonTouched() {
    
    guard
      let comments = commentZTextView.text,
      comments != Constants.Texts.practitionerReviewDescription,
      starsView.rate > 0,
      !comments.isEmpty
      else {
        let alert = UIAlertController(title: "Error", message: "Please provide a valid review.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        return
    }
    
    guard
      let reviewedId = reviewedUserId,
      let sessionId = sessionId,
      let reviewerId = User.currentUserId,
      let reviewerName = reviewerUsername
      else { return }
    
    print("reviewedId: \(reviewedId)")
    print("sessionId: \(sessionId)")
    print("reviewerId: \(reviewerId)")
    print("reviewerName: \(reviewerName)")
    print("comments: \(comments)")
    print("rate: \(starsView.rate)")
    
    Spinner.show(currentViewController: self)
    Review.createReview(
      userReviewedId: reviewedId,
      userReviewerId: reviewerId,
      userReviewerName: reviewerName,
      sessionId: sessionId,
      rate: Int(starsView.rate),
      comments: comments) { (error) in
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        if let error = error {
          let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
          }
        } else {
          DispatchQueue.main.async {
            self.dismiss(animated: true) {
              self.closePractitionerCheckInVC()
            }
          }
        }
    }
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
  
}



extension PractitionerReviewVC: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.Texts.practitionerReviewDescription {
      textView.text = nil
      textView.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = Constants.Texts.practitionerReviewDescription
      textView.textColor = UIColor.zentaiGray
    }
    
    textView.resignFirstResponder()
  }
  
}
























