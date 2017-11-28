//
//  PractitionerHomeVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/5/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Ax

enum DataSourceActive {
  case invitations
  case myAppointments
}

class PractitionerHomeVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBOutlet weak var workingSwitch: UISwitch!
  
  @IBOutlet weak var workingView: UIView!
  @IBOutlet weak var offLabel: UILabel!
  @IBOutlet weak var onLabel: UILabel!
  
  var currentDataSource = DataSourceActive.invitations
  var currentPractitioner: User?
  var cellId = "appointmentCell"
  
  var invitationSessions = [Session]()
  var appointmentsSessions = [Session]()
  
  var invitationHandler: UInt = 0
  var sessionChangesHandler: UInt = 0
  
  //  var currentDate: Date!
  
  var dateNow: Date!
  
  var isFirstCallOnInvitation = true
  var isFirstCallOnSessionChanges = true
  
  deinit {
    removeListeners()
  }
  
  @IBAction func workingSwtiched(_ sender: AnyObject) {
    print("switched")
  }
  
  @IBAction func segmentedTouched(_ sender: AnyObject) {
    if segmentedControl.selectedSegmentIndex == 0 {
      currentDataSource = .invitations
      tableView.reloadData()
    } else {
      currentDataSource = .myAppointments
      tableView.reloadData()
    }
    
    print(currentDataSource)
  }
  
}

extension PractitionerHomeVC {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.PractitionerHomeToInvitationDetail {
      let invitationDetailVC = segue.destination as? InvitationDetailVC
      invitationDetailVC?.currentSession = sender as? Session
      invitationDetailVC?.getServerDataOnPractitionerHome = getDataFromServer
      invitationDetailVC?.deselectCurrentRow = deselectCurrentRow
    } else if segue.identifier == Storyboard.PractitionerHomeToPractitionerAppointment {
      let vc = segue.destination as? PractitionerAppointmentVC
      vc?.session = sender as? Session
      vc?.deselectCurrentRow = deselectCurrentRow
    }
  }
}

extension PractitionerHomeVC {
  
  func removeListeners() {
    UserSession.removeListenNewInvitations(handlerId: invitationHandler)
    UserSession.removeListenChangesOnSessionState(handlerId: sessionChangesHandler)
  }
  
  func deselectCurrentRow() {
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
      
      getDataFromServer()
    }
  }
  
  func getDataFromServer() {
    //    if let practitionerId = currentPractitioner?.id {
    //
    //      Spinner.show(currentViewController: self)
    ////      SVProgressHUD.show()
    //      Ax.parallel(tasks: [
    //        { done in
    //          UserSession.getPractitionerInvitations(by: practitionerId, since: self.currentDate) { (sessions, handler) in
    //            self.invitationHandler = handler
    //            self.invitationSessions = sessions
    //
    //            if self.currentDataSource == .invitations {
    //              DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //              }
    //            }
    //
    //            done(nil)
    //          }
    //        },
    //        { done in
    //          let state = CellState.acceptedAndnotCompleted.rawValue
    //
    //          self.appointmentHandlerId = UserSession.getPractitionerAppointments(by: practitionerId, and: state, completion: { (sessions) in
    //            self.appointmentsSessions = sessions
    //
    //            if self.currentDataSource == .myAppointments {
    //              DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //              }
    //            }
    //
    //            done(nil)
    //          })
    //        }
    //      ], result: { (error) in
    //        Spinner.dismiss()
    //      })
    //    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    //    navigationController?.isNavigationBarHidden = true
    navigationController?.navigationBar.isHidden = true
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    Ax.serial(tasks: [
      { done in
        _ = User.getCurrentUser(once: true, completion: { [weak weakSelf = self] (user) in
          weakSelf?.currentPractitioner = user
          
          DispatchQueue.main.async {
            weakSelf?.workingSwitch.isOn = user?.isPushEnabled ?? false
            
            if let isOn = weakSelf?.workingSwitch.isOn, isOn {
              weakSelf?.onLabel.textColor = UIColor.zentaiPrimaryColor
              weakSelf?.offLabel.textColor = UIColor.zentaiGray
              
            } else {
              weakSelf?.offLabel.textColor = UIColor.zentaiPrimaryColor
              weakSelf?.onLabel.textColor = UIColor.zentaiGray
            }
          }
          done(nil)
          })
      },
      { done in
        self.getDataFromServer()
        done(nil)
      }
    ]) { (error) in
      Spinner.dismiss()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Spinner.dismiss()
  }
  
  func workingViewTapped() {
    print("working view tapped")
    
    
    if let currentUserId = User.currentUserId {
      if workingSwitch.isOn {
        User.updateUserWith(isPushEnabled: false, userId: currentUserId)
        
        workingSwitch.setOn(false, animated: true)
        offLabel.textColor = UIColor.zentaiPrimaryColor
        onLabel.textColor = UIColor.zentaiGray
      } else {
        
        //        SVProgressHUD.show()
        User.isPushNotificationsEnabled(completion: { [weak weakSelf = self] (isEnabled) in
          //          SVProgressHUD.dismiss()
          
          User.updateUserWith(isPushEnabled: isEnabled, userId: currentUserId)
          
          if isEnabled {
            DispatchQueue.main.async {
              weakSelf?.workingSwitch.setOn(true, animated: true)
              weakSelf?.onLabel.textColor = UIColor.zentaiPrimaryColor
              weakSelf?.offLabel.textColor = UIColor.zentaiGray
            }
          } else {
            let title = "The notifications permission was not authorized."
            let message = "Please enable it in Settings to continue."
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
              UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            weakSelf?.present(alert, animated: true, completion: nil)
          }
          })
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let workingGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(workingViewTapped))
    workingGestureRecognizer.numberOfTapsRequired = 1
    workingGestureRecognizer.numberOfTouchesRequired = 1
    
    workingView.addGestureRecognizer(workingGestureRecognizer)
    
    //    currentDate = Date()
    
    segmentedControl.selectedSegmentIndex = 0
    //    sessions = helperMethod()
    
    tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    
    let font = UIFont(name: "SanFranciscoText-Heavy", size: 11)
    let fontColorSelected = UIColor.white
    let fontColorNotSelected = UIColor.hexStringToUIColor(hex: "#bbbbbb")
    
    let selectedAttributes = [
      NSFontAttributeName: font!,
      NSForegroundColorAttributeName: fontColorSelected
    ]
    
    let notSelectedAttributes = [
      NSFontAttributeName: font!,
      NSForegroundColorAttributeName: fontColorNotSelected
    ]
    
    segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    segmentedControl.setTitleTextAttributes(notSelectedAttributes, for: .normal)
    
    
    SVProgressHUD.show()
    Ax.serial(tasks: [
      { done in
        getSessionInvitations(
          userId: User.currentFIRUser?.uid,
          viewController: self,
          completion: { (error) in
            done(error)
        })
      },
      
      { done in
        User.getTimeNow(completion: { (error, date) in
          if let error = error {
            done(error)
          } else {
            self.dateNow = date
            done(nil)
          }
        })
      },
      
      { done in
        print(self.dateNow)
        self.invitationHandler = UserSession.listenNewInvitations(
          fromTime: self.dateNow!,
          completion: { [weak self] in
            guard let this = self else {
              done(nil)
              return
            }
            
            if this.isFirstCallOnInvitation {
              this.isFirstCallOnInvitation = false
            } else {
              print("here wait  ing something you know.")
              getSessionInvitations(
                userId: User.currentFIRUser?.uid,
                viewController: this,
                completion: { (error) in
                  done(error)
              })
            }
            
          }
        )
        
        done(nil)
      },
      
      { done in
        
        self.sessionChangesHandler = UserSession.listenChangesOnSessionState(
          fromTime: self.dateNow,
          completion: { [weak self] in
            guard let this = self else {
              done(nil)
              return
            }
            
            if this.isFirstCallOnSessionChanges {
              this.isFirstCallOnSessionChanges = false
            } else {
              getSessionInvitations(
                userId: User.currentFIRUser?.uid,
                viewController: this,
                completion: { (error) in
                  done(error)
              })
            }
          })
        
      }
    ]) { (error) in
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
      }
      
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
        
        DispatchQueue.main.async {
          self.present(alert, animated: true)
        }
      }
    }
    
    
  }
}

//func

func getSessionInvitations(
  userId: String?,
  viewController: PractitionerHomeVC,
  completion: @escaping (NSError?) -> Void
  ) {
  
  guard let currentUserId = userId
    else {
      let error = NSError(
        domain: "Invitations",
        code: 0,
        userInfo: [
          NSLocalizedDescriptionKey: "Current User Id not found."
        ]
      )
      
      completion(error)
      return
  }
  
  UserSession.getPractitionerInvitations(
    by: currentUserId,
    completion: { (error, invitedSessions, acceptedSessions) in
      if let error = error {
        completion(error)
        return
      }
      
      viewController.appointmentsSessions = acceptedSessions
      viewController.invitationSessions = invitedSessions
      
      DispatchQueue.main.async {
        viewController.tableView.reloadData()
      }
      
      completion(nil)
  })
}


extension PractitionerHomeVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if currentDataSource == .invitations {
      return invitationSessions.count
    } else {
      return appointmentsSessions.count
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if currentDataSource == .invitations {
      let session = invitationSessions[indexPath.row]
      
      performSegue(withIdentifier: Storyboard.PractitionerHomeToInvitationDetail, sender: session)
    } else {
      let appointment = appointmentsSessions[indexPath.row]
      
      performSegue(withIdentifier: Storyboard.PractitionerHomeToPractitionerAppointment, sender: appointment)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var invitation: Session!
    var appointment: Session!
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppointmentCell
    
    if currentDataSource == .invitations {
      invitation = invitationSessions[indexPath.row]
      cell.initFields(session: invitation, type: .practitioner)
    } else {
      appointment = appointmentsSessions[indexPath.row]
      
      cell.initFields(session: appointment, type: .practitioner, state: .acceptedAndnotCompleted)
    }
    
    return cell
  }
}































