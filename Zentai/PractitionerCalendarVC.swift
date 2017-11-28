//
//  PractitionerCalendarVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/5/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Ax
import SVProgressHUD

class PractitionerCalendarVC: UIViewController {
  
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  let blackColor = UIColor.hexStringToUIColor(hex: "#484646")
  let grayColor = UIColor.gray
  var monthDateFormatter = DateFormatter()
  
  var detailCellId = "detailCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  var sessionsByDate = Dictionary<String, [Session]>()
  var sessions = [Session]()
  
  var sessionHandler: UInt = 0
  
  var currentPractitioner: User?
  
  var currentDate: Date!
}

extension PractitionerCalendarVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    monthDateFormatter.dateFormat = "MMMM"
    
    calendarView.dataSource = self
    calendarView.delegate = self
    calendarView.registerHeaderView(xibFileNames: ["ZCellHeaderView"])
    calendarView.registerCellViewXib(file: "ZCellView")
    
    calendarView.cellInset = CGPoint(x: 0, y: 0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    
    Ax.serial(tasks: [
      { done in
        _ = User.getCurrentUser(once: true, navigationController: self.navigationController, completion: { user in
          self.currentPractitioner = user
          done(nil)
        })
      },
      { [weak self] done in
        guard let this = self else {
          done(nil)
          return
        }
        
        if let practitioner = self?.currentPractitioner {
          UserSession.getPractitionerInvitations(
            by: practitioner.id!,
            completion: { (error, invitedSessions, acceptedSessions) in
              print(acceptedSessions)
              this.sessionsByDate = this.convertToDictionary(acceptedSessions)
              
              done(nil)
          })
        } else {
          done(nil)
        }
      },
      { done in
        User.getTimeNow(completion: { [weak self] (error, currentDate) in
          guard let this = self else { return }
          
          print(currentDate)
          
          this.currentDate = currentDate
          
          done(error)
          })
      }
    ]) { [weak self] (error) in
      guard let this = self else { return }
      
      Spinner.dismiss()
      DispatchQueue.main.async {
        this.calendarView.reloadData()
      }
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let practitionerId = currentPractitioner?.id {
      UserSession.removeListenerOnPractitionerAppointments(practitionerId: practitionerId, handlerId: sessionHandler)
    }
  }
}

extension PractitionerCalendarVC {
  
  func existsDateOnSessions(_ date: Date) -> Bool {
    var exists = false
    
    let key = convertToKey(date)
    
    exists = sessionsByDate[key] != nil
    
    return exists
  }
  
  
  func convertToKey(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
  
  func convertToDictionary(_ sessions: [Session]) -> Dictionary<String, [Session]> {
    var dict = Dictionary<String, [Session]>()
    
    sessions.forEach {
      if let sessionStartTime = $0.selectedDate {
        let key = convertToKey(sessionStartTime)
        
        if dict[key] == nil {
          dict[key] = [Session]()
        }
        
        var sessionsToAdd = dict[key]
        sessionsToAdd?.append($0)
        
        dict[key] = sessionsToAdd
      }
    }
    
    return dict
  }
  
  func deselectRow() {
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
  }
}



extension PractitionerCalendarVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessions.count
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.CalendarToPractitionerAppointment {
      let vc = segue.destination as? PractitionerAppointmentVC
      let indexSessionSelected = tableView.indexPathForSelectedRow?.row ?? -1
      var sessionSelected: Session?
      
      if indexSessionSelected >= 0 {
        sessionSelected = sessions[indexSessionSelected]
      }
      
      //      vc?.modalPresentationCapturesStatusBarAppearance = true
      //      vc?.deselectRowOnPractitionerCalendarVC = deselectRow
      vc?.session = sessionSelected
      vc?.deselectCurrentRow = deselectRow
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: detailCellId, for: indexPath) as! ZDetailCell
    let session = sessions[indexPath.row]
    
    let startTime = Utils.format(time: session.selectedStart!)
    let endTime = Utils.format(time: session.selectedEnd!)
    
    cell.clientName = session.clientName
    cell.time = "\(startTime) - \(endTime)"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: Storyboard.CalendarToPractitionerAppointment, sender: nil)
  }
}


extension PractitionerCalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: JTAppleCalendar.CellState) {
    let customCell = cell as? ZCellView
    customCell?.isWeekDay = isValidDay(cellState)
    customCell?.isSelected = cellState.isSelected
    
    let key = convertToKey(date)
    self.sessions = self.sessionsByDate[key] ?? [Session]()
    self.tableView.reloadData()
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: JTAppleCalendar.CellState) {
    let customCell = cell as? ZCellView
    customCell?.isWeekDay = isValidDay(cellState)
    customCell?.isSelected = cellState.isSelected
  }
  
  func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 70)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
    let header = header as! ZCellHeaderView
    
    let monthName = monthDateFormatter.string(from: range.start)
    let year = Calendar.current.component(.year, from: range.start)
    
    header.headerLabel.backgroundColor = UIColor.hexStringToUIColor(hex: "#B6D8DB")
    header.headerLabel.text = "\(monthName) \(year)"
  }
  
  func isValidDay(_ cellState: JTAppleCalendar.CellState) -> Bool {
    return cellState.dateBelongsTo == .thisMonth &&
      cellState.day != .sunday &&
      cellState.day != .saturday
  }
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: JTAppleCalendar.CellState) {
    let myCustomCell = cell as? ZCellView
    myCustomCell?.dayLabel.text = cellState.text
    myCustomCell?.hasAnySession = existsDateOnSessions(date)
    myCustomCell?.isWeekDay = isValidDay(cellState)
    myCustomCell?.isSelected = cellState.isSelected
  }
  
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    if let currentDate = currentDate {
      
      print(currentDate)
      // setting the firt day of the month
      var startDate = Calendar.current.date(bySetting: .day, value: 1, of: currentDate)
      
      // substracting 2 months from current
      startDate = Calendar.current.date(byAdding: .month, value: -2, to: startDate!)
      
      var endDate = Calendar.current.date(bySetting: .day, value: 1, of: currentDate)
      endDate = Calendar.current.date(byAdding: .month, value: 1, to: endDate!)
      
      let parameters = ConfigurationParameters(
        startDate: startDate!,
        endDate: endDate!,
        numberOfRows: 6,
        calendar: Calendar.current,
        generateInDates: .forAllMonths,
        generateOutDates: OutDateCellGeneration.off,
        firstDayOfWeek: .sunday
      )
      
      return parameters
    } else {
      return ConfigurationParameters(startDate: Date(), endDate: Date())
    }
  }
}










