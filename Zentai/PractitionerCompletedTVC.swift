//
//  PractitionerCompletedVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/5/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import Ax
import SVProgressHUD

// properties
class PractitionerCompletedTVC: UITableViewController {
  
  let cellId = "appointmentCell"
  var sessionHandler: UInt = 0
  
  var completedSessions = [Session]() {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
}

// life cycle
extension PractitionerCompletedTVC {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set header title
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    titleLabel.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    titleLabel.text = "COMPLETED APPOINTMENTS"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SanFranciscoText-Heavy", size: 13)
    navigationItem.titleView = titleLabel
    
    tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    
    tableView.contentInset.top = UIApplication.shared.statusBarFrame.height
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let userId = User.currentUserId {
      UserSession.removeListenerOnPractitionerAppointments(practitionerId: userId, handlerId: sessionHandler)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //    navigationController?.navigationBar.isHidden = false
    
    if let userId = User.currentUserId {
      let state = CellState.checkedIn.rawValue
      
      Spinner.show(currentViewController: self)
      //      SVProgressHUD.show()
      sessionHandler = UserSession.getPractitionerAppointments(by: userId, and: state, completion: { [weak self] (sessions) in
        Spinner.dismiss()
        self?.completedSessions = sessions
        })
    }
  }
  
}

// UITableViewDelegate
extension PractitionerCompletedTVC {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return completedSessions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppointmentCell
    let session = completedSessions[indexPath.row]
    
    cell.initFields(session: session, type: .practitioner, state: .completedAndPaid)
    cell.state = CellState.completedAndPaid
    
    return cell
  }
}



















































