//
//  MyFavoritesVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 4/17/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit

class MyFavoritesVC: UITableViewController {
  
  var users = [[String: Any]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "MY FAVORITES"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    if let userId = User.currentUserId {
      User.getFavorites(byUserId: userId, completion: { [weak self] (users) in
        self?.users = users
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
        })
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.MyFavoritesToPractitionerProfile {
      let user = sender as? [String: Any]
      
      let vc = segue.destination as? ProfilePractitionerViewController
      vc?.practitionerId = user?["id"] as? String
      vc?.practitionerName = user?["username"] as? String
    }
  }
}

extension MyFavoritesVC {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    
    if user["id"] == nil {
      return
    }
    
    if user["username"] == nil {
      return
    }
    
    performSegue(withIdentifier: Storyboard.MyFavoritesToPractitionerProfile, sender: user)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoritesCell.cellId, for: indexPath) as! MyFavoritesCell
    let user = users[indexPath.row]
    
    cell.imageURL = user["profileURL"] as? String
    cell.username = user["username"] as! String
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
  
}








































