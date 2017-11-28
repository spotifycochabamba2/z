//
//  PractitionerProfileVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/5/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Ax

class PractitionerProfileTVC: UITableViewController {
  
  @IBOutlet weak var editProfileCell: UITableViewCell!
  @IBOutlet weak var helpSupportCell: UITableViewCell!
  @IBOutlet weak var reportBugCell: UITableViewCell!
  @IBOutlet weak var logoutCell: UITableViewCell!
  
  
  @IBOutlet weak var starsView: StartsView!
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet weak var bioLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pictureImageView.layer.cornerRadius = 120 / 2
    pictureImageView.layer.borderColor = UIColor.gray.cgColor
    pictureImageView.layer.borderWidth = 1.0
    pictureImageView.layer.masksToBounds = true
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "MY PROFILE"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
  }
  
  func updateUI(_ user: User) {
    let profileURL = user.profileURL
    let bio = user.bio
    
    if let profileURL = profileURL, !profileURL.isEmpty {
      pictureImageView.sd_setImage(with: URL(string: profileURL)!, placeholderImage: UIImage(named: "person-default"))
    } else {
      pictureImageView.image = UIImage(named: "person-default")
    }
    
    bioLabel.text = bio
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    
    if cell === logoutCell {
      NotificationCenter.default.post(name: Notification.Name(Constants.RemoteNotification.logout), object: nil)
    } else if cell === editProfileCell {
      performSegue(withIdentifier: Storyboard.PractitionerProfileToEditProfile, sender: nil)
    } else if cell === reportBugCell {
      performSegue(withIdentifier: Storyboard.PractitionerProfileToReportBug, sender: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let practitionerId = User.currentUserId {
      
      Spinner.show(currentViewController: self)
      Ax.serial(tasks: [
        
        { done in
          _ = User.getUser(by: practitionerId, once: true) { [weak weakSelf = self] (user) in
            DispatchQueue.main.async {
              if let user = user {
                weakSelf?.updateUI(user)
              }
            }
            
            done(nil)
          }
        },
        
        
        { done in
          Review.getTotalReviews(
            userId: practitionerId,
            completion: { [weak self] (error, rate) in
              print(rate)
              
              if let error = error {
                done(error)
              } else {
                DispatchQueue.main.async {
                  //                self?.starsView.rate = rate
                }
                
                done(nil)
              }
            })
        }
        
        ], result: { [weak self] (error) in
          Spinner.dismiss()
          
          if let error = error {
            let alert = UIAlertController(
              title: "Error",
              message: error.localizedDescription,
              preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
              title: "OK",
              style: .default
            ))
            
            self?.present(alert, animated: true)
          }
        })
    }
  }
}



























