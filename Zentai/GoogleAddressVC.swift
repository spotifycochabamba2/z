//
//  GoogleAddressVC.swift
//  zentai
//
//  Created by Wilson Balderrama on 1/18/17.
//  Copyright © 2017 Zentai. All rights reserved.
//

import UIKit
import SVProgressHUD


class GoogleAddressVC: UIViewController {
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var upperView: UIView!
  @IBOutlet weak var inputTextField: UITextField!
  
  var places = [(String, String, String)]()
  
  var setAddressInfo: ((_ address: String, _ city: String, _ state: String, _ zip: String) -> Void)?
  var lastPositionSelected: (latitude: Double, longitude: Double)?
  var didSelectPosition: ((Double, Double) -> Void)?
  var setAddressInfoWith: ((AddressInfo) -> Void)?
  
  let cellId = "searchCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    inputTextField.addTarget(self, action: #selector(inputTextFieldChanged(sender:)), for: .editingChanged)
    
    //    internalView = view
    //    rootViewFrame = view.frame
    
    blurView.makeMeBlur()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    upperView.makeMeRounded()
    upperView.applyBlackTransparentShadow()
    
    inputTextField.addBottomLine(color: .zentaiGray)
  }
  
  @IBAction func closeButtonAction() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func clearInputTextView() {
    inputTextField.text = ""
    places = [(String, String, String)]()
    tableView.reloadData()
  }
}

extension GoogleAddressVC {
  func inputTextFieldChanged(sender: Any) {
    let input = inputTextField.text ?? ""
    let count = input.characters.count
    
    if count > 3 {
      Spinner.show(currentViewController: self)
      //      SVProgressHUD.show()
      Utils.searchPlaces(input: input, completion: { (addresses) in
        Spinner.dismiss()
        self.places = addresses
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
    }
  }
}


extension GoogleAddressVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let place = places[indexPath.row]
    
    //    SVProgressHUD.show()
    Spinner.show(currentViewController: self)
    Utils.getAddress(fromPlace: place) { [weak weakSelf = self] (addressInfo) in
      Spinner.dismiss()
      
      DispatchQueue.main.async {
        
        weakSelf?.didSelectPosition?(addressInfo?.latitude ?? 0.0, addressInfo?.longitude ?? 0.0)
        
        weakSelf?.setAddressInfo?(
          addressInfo?.address ?? "",
          addressInfo?.city ?? "",
          addressInfo?.state ?? "",
          addressInfo?.zip ?? ""
        )
        
        if let addressInfo = addressInfo {
          weakSelf?.setAddressInfoWith?(addressInfo)
        }
      }
      
      weakSelf?.dismiss(animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let place = places[indexPath.row]
    
    cell.textLabel?.text = place.0
    cell.detailTextLabel?.text = place.1
    
    return cell
  }
}

















































