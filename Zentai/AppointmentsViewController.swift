//
//  AppointmentsTableViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/13/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppointmentsViewController: UITableViewController {
  
  var sessions = [UserSession]()
  var cellId = "appointmentCell"
  
  var sessionHandlerId: UInt = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    clearsSelectionOnViewWillAppear = false
    
    tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "MY APPOINTMENTS"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let userId = User.currentUserId {
      UserSession.removeListenerOnUsersSessions(handlerId: sessionHandlerId, userId: userId)
    }
    
    Spinner.dismiss()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    if let userId = User.currentUserId {
      SVProgressHUD.show()
      //      Spinner.show(currentViewController: self)
      
      sessionHandlerId = UserSession.get(by: userId) { (sessions) in
        SVProgressHUD.dismiss()
        print(sessions.count)
        self.sessions = sessions
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func deselectRow() {
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(
        at: selectedRow,
        animated: true
      )
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.AppointmentsToDetail {
      let vc = segue.destination as? AppointmentResultViewController
      vc?.sessionId = (sender as? UserSession)?.id
      vc?.deselectRowOnAppointmentsViewController = deselectRow
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let session = sessions[indexPath.row]
    
    performSegue(withIdentifier: Storyboard.AppointmentsToDetail, sender: session)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppointmentCell
    let session = sessions[indexPath.row]
    
    DispatchQueue.main.async {
      cell.initFields(session: session, type: .client)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
}
