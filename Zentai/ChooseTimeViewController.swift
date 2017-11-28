//
//  ChooseTimeViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/23/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChooseTimeViewController: ModalViewController {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var okButton: UIButton!
  //  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var pickerView: UIPickerView!
  
  var isReadyDatePicker = false
  
  var dateUsed: Date!
  var days = [(String, Date)]()
  
  func initDays(
    basedDate: Date
    ) -> [(String, Date)] {
    
    let calendar = Calendar.current
    let oneMonthFromNow = Calendar.current.date(byAdding: .day, value: 30, to: basedDate)
    
    var dates = [(String, Date)]()
    
    var date = basedDate // first date
    let endDate = oneMonthFromNow // last date
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EE d MMM"
    
    
    while date <= endDate! {
      dates.append((Utils.format(date: date), date))
      date = calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    dates[0].0 = "Today"
    dates[1].0 = "Tomorrow"
    
    return dates
  }
  
  func updateStartHours(basedDate: Date) -> [(String, Date)] {
    let calendar = Calendar.current
    let rightNow = basedDate
    
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    
    let interval = 30
    var nextDiff = interval - calendar.component(.minute, from: rightNow) % interval
    print(nextDiff)
    var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
    
    var hour3 = Calendar.current.component(.hour, from: nextDate)
    var hours = [(String, Date)]()
    
    print(hour3)
    
    while( (hour3 < 23 && hour3 >= 8) ) {
      hours.append((Utils.format(time: nextDate), nextDate))
      
      nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
      nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
      
      hour3 = Calendar.current.component(.hour, from: nextDate)
    }
    
    if hours.count > 0 {
      hours.removeLast()
    }
    
    return hours
  }
  
  var startHours: [(String, Date)] = []
  
  func updateEndHours(startHours: [(String, Date)]) -> [(String, Date)] {
    var hours = [(String, Date)]()
    
    if startHours.count <= 0 {
      return hours
    }
    
    var firstHour = startHours[0].1
    
    firstHour = Calendar.current.date(byAdding: .minute, value: 35, to: firstHour)!
    
    let calendar = Calendar.current
    let rightNow = firstHour
    
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    
    let interval = 30
    var nextDiff = interval - calendar.component(.minute, from: rightNow) % interval
    var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
    
    var hour3 = Calendar.current.component(.hour, from: nextDate)
    
    
    while(hour3 < 23) {
      print(Utils.format(time: nextDate))
      hours.append((Utils.format(time: nextDate), nextDate))
      
      nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
      nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
      
      hour3 = Calendar.current.component(.hour, from: nextDate)
      print(hour3)
    }
    
    hours.append((Utils.format(time: nextDate), nextDate))
    
    nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
    nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
    
    hour3 = Calendar.current.component(.hour, from: nextDate)
    
    return hours
  }
  
  var dateSelected: (String, Date)?
  var startTimeSelected: Date?
  var endTimeSelected: Date?
  
  var endHours: [(String, Date)] = []
  
  var setTime: ((String, Date)?, Date?, Date?) -> Void = { _ in }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    Spinner.show(currentViewController: this)
    SVProgressHUD.show()
    User.getTimeNow { [weak self] (error, date) in
      SVProgressHUD.dismiss()
      
      guard let this = self else { return }
      
      if let error = error {
        let alert = UIAlertController(
          title: "Error",
          message: error.localizedDescription,
          preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
          title: "OK",
          style: .default
        ))
        
        this.present(alert, animated: true)
      } else {
        this.isReadyDatePicker = true
        this.dateUsed = Calendar.current.date(byAdding: .hour, value: 2, to: date!) ?? Date()
        
        this.days = this.initDays(basedDate: this.dateUsed)
        
        this.startHours = this.updateStartHours(basedDate: this.dateUsed)
        this.endHours = this.updateEndHours(startHours: this.startHours)
        
        this.pickerView.reloadAllComponents()
      }
    }
    
    
    let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGestureRecognizer.numberOfTapsRequired = 1
    viewTapGestureRecognizer.numberOfTouchesRequired = 1
    view.addGestureRecognizer(viewTapGestureRecognizer)
    
    view.backgroundColor = .clear
    blurView.backgroundColor = .clear
    
    blurView.makeMeBlur()
  }
  
  @IBAction func closeTouched() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func okButtonTouched() {
    guard pickerView.numberOfComponents > 0 else {
      return
    }
    
    let daysRowSelected = pickerView.selectedRow(inComponent: 0)
    let startRowSelected = pickerView.selectedRow(inComponent: 1)
    let endRowSelected = pickerView.selectedRow(inComponent: 2)
    
    print(daysRowSelected)
    print(startRowSelected)
    print(endRowSelected)
    
    if daysRowSelected >= 0 {
      if days.count > 0 {
        dateSelected = days[daysRowSelected]
      }
    }
    
    if startRowSelected >= 0 {
      if startHours.count > 0 {
        startTimeSelected = startHours[startRowSelected].1
        
        if let dateSelected = dateSelected {
          let calendar = Calendar.current
          let startTimeHour = calendar.component(.hour, from: startTimeSelected!)
          let startTimeMinute = calendar.component(.minute, from: startTimeSelected!)
          let startTimeSecond = calendar.component(.second, from: startTimeSelected!)
          
          var daysComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateSelected.1)
          daysComponent.hour = startTimeHour
          daysComponent.minute = startTimeMinute
          daysComponent.second = startTimeSecond
          
          self.dateSelected?.1 = calendar.date(from: daysComponent)!
        }
      }
    }
    
    if endRowSelected >= 0 {
      if endHours.count > 0 {
        endTimeSelected = endHours[endRowSelected].1
      }
    }
    
    setTime(dateSelected, startTimeSelected, endTimeSelected)
    dismiss(animated: true, completion: nil)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: self.okButton.bounds, byRoundingCorners: ([.bottomLeft, .bottomRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
    let maskLayer: CAShapeLayer = CAShapeLayer()
    maskLayer.frame = self.okButton.bounds
    maskLayer.path = maskPath.cgPath
    self.okButton.layer.mask = maskLayer
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
  }
  
  func viewTapped() {
    dismiss(animated: true, completion: nil)
  }
}






extension ChooseTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    if isReadyDatePicker {
      return 3
    } else {
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    switch component {
    case 0:
      if row > 0 {
        dateUsed = Calendar.current.date(bySetting: .hour, value: 8, of: dateUsed)!
        dateUsed = Calendar.current.date(bySetting: .minute, value: 10, of: dateUsed)!
      } else {
        dateUsed = Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date()
      }
      
      startHours = updateStartHours(basedDate: dateUsed)
      endHours = updateEndHours(startHours: startHours)
      
      pickerView.reloadComponent(1)
      pickerView.reloadComponent(2)
    case 1:
      pickerView.selectRow(row, inComponent: 2, animated: true)
    case 2:
      pickerView.selectRow(row, inComponent: 1, animated: true)
    default:
      break
    }
    
    
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return days.count
    } else if component == 1 {
      return startHours.count
    } else {
      return endHours.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0 {
      return days[row].0
    } else if component == 1 {
      return startHours[row].0
    } else {
      return endHours[row].0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    var label: UILabel
    
    if let view = view as? UILabel {
      label = view
    } else {
      label = UILabel()
    }
    
    var data: [(String, Date)]?
    
    switch component {
    case 0:
      data = days
    case 1:
      data = startHours
    case 2:
      data = endHours
    default:
      break
    }
    
    label.textColor = UIColor.hexStringToUIColor(hex: "#484646")
    label.textAlignment = .center
    label.font = UIFont(name: "SanFranciscoText-Light", size: 18)
    
    if let data = data {
      label.text = data[row].0
    }
    
    return label
  }
}













































