//
//  ProfileViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/13/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class ProfileViewController: UITableViewController {
  @IBOutlet weak var photoCell: UITableViewCell!
  @IBOutlet weak var accountSettingsCell: UITableViewCell!
  @IBOutlet weak var myAppointmentsCell: UITableViewCell!
  @IBOutlet weak var myFavoritesCell: UITableViewCell!
  @IBOutlet weak var reportBugCell: UITableViewCell!
  @IBOutlet weak var logoutCell: UITableViewCell!
  @IBOutlet weak var aboutCell: UITableViewCell!
  
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel! {
    didSet {
      nameLabel.text = ""
    }
  }
  
  @IBOutlet weak var emailLabel: UILabel! {
    didSet {
      emailLabel.text = ""
    }
  }
  
  internal var imagePicker = UIImagePickerController()
  var currentUser: User?
  
  @IBAction func addPromoButtonTouched() {
    print("add promo button touched")
  }
  
  @IBAction func inviteButtonTouched() {
    print("invite butotn touched")
  }
  
  func configure(imagePicker: UIImagePickerController) {
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = false
      imagePicker.cameraCaptureMode = .photo
    }
  }
  
  func configure(profileImageView: UIImageView, pictureURL: String?) {
    
    if let pictureURL = pictureURL, !pictureURL.isEmpty {
      profileImageView.sd_setImage(with: URL(string: pictureURL)!, placeholderImage: UIImage(named: "person-default"))
    } else {
      profileImageView.image = UIImage(named: "person-default")
    }
    
    profileImageView.layer.cornerRadius = 70 / 2
    profileImageView.layer.borderColor = UIColor.gray.cgColor
    profileImageView.layer.borderWidth = 1.0
    profileImageView.layer.masksToBounds = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.contentMode = .scaleAspectFit
    
    Spinner.show(currentViewController: self)
    //    SVProgressHUD.show()
    _ = User.getCurrentUser(once: true, navigationController: navigationController) { (user) in
      Spinner.dismiss()
      
      if let user = user {
        self.currentUser = user
        
        DispatchQueue.main.async {
          self.nameLabel.text = "\(user.firstName) \(user.lastName)"
          self.emailLabel.text = user.email
          self.configure(profileImageView: self.imageView, pictureURL: user.profileURL)
        }
      }
    }
    
    configure(imagePicker: imagePicker)
    
    let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
    imageViewTapGesture.numberOfTapsRequired = 1
    imageViewTapGesture.numberOfTouchesRequired = 1
    imageView.addGestureRecognizer(imageViewTapGesture)
    imageView.isUserInteractionEnabled = true
    
    tableView.separatorInset = .zero
    tableView.layoutMargins = .zero
    
    photoCell.selectionStyle = .none
    //buttonsCell.selectionStyle = .none
    aboutCell.selectionStyle = .none
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "EDIT PROFILE"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    //addPromoButton.makeMeRounded()
    //invitePromoButton.makeMeRounded()
  }
}

extension ProfileViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = super.tableView(tableView, heightForRowAt: indexPath)
    
    if indexPath.row == 7 {
      let height = view.frame.size.height - (CGFloat(480) + (UIApplication.shared.statusBarFrame.height * 2))
      if height >= 0 {
        return height
      }
    }
    
    return abs(height)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if cell === accountSettingsCell {
      performSegue(withIdentifier: Storyboard.ProfileToSettings, sender: nil)
    } else if cell === myAppointmentsCell {
      performSegue(withIdentifier: Storyboard.ProfileToAppointments, sender: nil)
    } else if cell === myFavoritesCell {
      performSegue(withIdentifier: Storyboard.ProfileToMyFavorites, sender: nil)
    } else if cell === reportBugCell {
      performSegue(withIdentifier: Storyboard.ProfileToReportBug, sender: nil)
    } else if cell === logoutCell {
      User.logout()
      _ = navigationController?.popToRootViewController(animated: true)
    }
  }
}
//UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imageViewTapped() {
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    imagePicker.dismiss(animated: true, completion: nil)
    let image = info[UIImagePickerControllerOriginalImage] as? UIImage
    
    imageView.image = image
    User.uploadPicture(userId: User.currentUserId, picture: image)
  }
}


class ModalTableViewController: UITableViewController {
  var rootViewFrame: CGRect?
  var internalView: UIView?
  
  var currentTextField: UIView?
  
  @IBOutlet weak var constraint: NSLayoutConstraint?
  
  var panGestureRecognizer: UIPanGestureRecognizer?
  var originalPosition: CGPoint?
  var currentPositionTouched: CGPoint?
  
  var areaPannable: CGFloat {
    return view.frame.size.height
  }
  
  func wentUp() {
    
  }
  
  func wentDown() {
    
  }
  
  func dismissed() {
    
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    modalPresentationCapturesStatusBarAppearance = true
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
    view.addGestureRecognizer(panGestureRecognizer!)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }
  
  func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
    let translation = panGesture.translation(in: view)
    
    if panGesture.state == .began {
      originalPosition = view.center
      currentPositionTouched = panGesture.location(in: view)
    } else if panGesture.state == .changed {
      if currentPositionTouched!.y <= areaPannable {
        view.frame.origin = CGPoint(
          x: translation.x,
          y: translation.y
        )
      }
    } else if panGesture.state == .ended {
      let velocity = panGesture.velocity(in: view)
      
      if currentPositionTouched!.y <= areaPannable && velocity.y >= 1500 {
        UIView.animate(withDuration: 0.2
          , animations: {
            self.view.frame.origin = CGPoint(
              x: self.view.frame.origin.x,
              y: self.view.frame.size.height
            )
          }, completion: { (isCompleted) in
            if isCompleted {
              self.dismiss(animated: false, completion: {
                self.dismissed()
              })
            }
        })
      } else if currentPositionTouched!.y >= areaPannable && velocity.y >= 1500 {
        wentDown()
      } else if currentPositionTouched!.y >= areaPannable && velocity.y <= -1500 {
        wentUp()
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.view.center = self.originalPosition!
        })
      }
    }
  }
  
  
  func keyboardWillBeHidden(notification: Notification) {
    if let rootViewFrame = rootViewFrame {
      internalView?.frame = rootViewFrame
    }
  }
  
  func keyboardWillBeShown(notification: Notification) {
    let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    if let textField = currentTextField {
      let newFrame = textField.convert(textField.bounds, to: internalView)
      let keyboardHeight = keyboardRect!.origin.y - 50 //100
      let resultHeight2 = keyboardHeight - newFrame.origin.y
      var frame = rootViewFrame!
      frame.origin.y += resultHeight2
      
      if resultHeight2 < 0 {
        internalView?.frame = frame
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
}
