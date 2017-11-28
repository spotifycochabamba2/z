//
//  BookingViewController.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/19/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import UIKit
import Ax
import UITextField_Navigation
import Just
import Alamofire
import SwiftyJSON
import SVProgressHUD
import FirebaseCrash

enum PracticionerGender: String {
  case female = "F"
  case either = "Either"
  case male = "M"
  
  func toString() -> String {
    switch self {
    case .female: return "Female"
    case .either: return "Either"
    case .male: return "Male"
    }
  }
}

enum OilAllergies: String {
  case no = "N"
  case yes = "Y"
  
  func toString() -> String {
    switch self {
    case .no: return "No allergies"
    case .yes: return "Yes allergies"
    }
  }
}

enum Pets: String {
  case dog = "Dog"
  case both = "Both"
  case cat = "Cat"
  case none = "None"
  
  func toString() -> String {
    switch self {
    case .dog: return "Dog"
    case .both: return "Dog & Cat"
    case .cat: return "Cat"
    case .none: return "None"
    }
  }
}

class BookingViewController: ModalViewController {
  
  
  
  @IBOutlet weak var stateTableViewTopConstraint: NSLayoutConstraint!
  
  var bookingSpecificPractitionerId: String?
  var currentUser :User?
  
  @IBOutlet weak var topArrowButton: UIButton!
  
  override var areaPannable: CGFloat {
    return 100
  }
  
  override func wentUp() {
    super.wentUp()
    nextStep()
  }
  
  override func wentDown() {
    super.wentDown()
    previousStep()
  }
  
  var numberFormatter = Constants.numberFormatter
  
  
  @IBOutlet weak var topImageHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var addressView: UIView!
  
  @IBOutlet weak var bottomArrowButton: UIButton!
  
  //  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var sessionLabel: UILabel!
  //  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var parkingCostLabel: UILabel!
  @IBOutlet weak var totalPaymentLabel: UILabel!
  @IBOutlet weak var titleSessionLabel: UILabel!
  
  @IBOutlet weak var addTimeFirstButton: UIButton!
  @IBOutlet weak var addTimeSecondButton: UIButton!
  @IBOutlet weak var addTimeThirdButton: UIButton!
  
  @IBOutlet weak var statesTableView: UITableView!
  
  @IBOutlet weak var firstStackView: UIStackView!
  @IBOutlet weak var firstSummaryView: UIView!
  @IBOutlet weak var firstSummaryTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var genderFemaleButton: UIButton!
  @IBOutlet weak var genderEitherButton: UIButton!
  @IBOutlet weak var genderMaleButton: UIButton!
  
  @IBOutlet weak var allergyYesButton: UIButton!
  @IBOutlet weak var allergyNoButton: UIButton!
  
  @IBOutlet weak var petsDogButton: UIButton!
  @IBOutlet weak var petsBothButton: UIButton!
  @IBOutlet weak var petsCatButton: UIButton!
  @IBOutlet weak var nonePetsButton: UIButton!
  
  @IBOutlet weak var firstGenderButton: UIButton!
  @IBOutlet weak var secondGenderButton: UIButton!
  @IBOutlet weak var thirdGenderButton: UIButton!
  
  @IBOutlet weak var arrowDownLabel: UILabel!
  @IBOutlet weak var arrowButton: UIButton?
  
  @IBOutlet weak var confirmButton: UIButton!
  
  @IBOutlet weak var genderButton: UIButton!
  @IBOutlet weak var genderHelpButton: UIButton!
  @IBOutlet weak var allergyHelpButton: UIButton!
  @IBOutlet weak var petsHelpButton: UIButton!
  @IBOutlet weak var availabilityHelpButton: UIButton!
  @IBOutlet weak var parkingCostHelpButton: UIButton!
  
  @IBOutlet weak var practicionerGenderStackView: UIStackView!
  @IBOutlet weak var allergiesStackView: UIStackView!
  @IBOutlet weak var petsStackView: UIStackView!
  
  @IBOutlet weak var errorMessageLabel: UILabel!
  
  @IBOutlet weak var firstOptionTimeLabel: UILabel!
  @IBOutlet weak var thirdOptionTimeLabel: UILabel!
  @IBOutlet weak var secondOptionTimeLabel: UILabel!
  
  @IBOutlet weak var paymentCardStackView: UIStackView!
  
  @IBOutlet weak var cardLabel: UILabel!
  @IBOutlet weak var enterPaymentStackView: UIStackView!
  
  var paymentTotal = 0.0
  
  // MODEL
  var genderSelected: PracticionerGender? {
    didSet {
      if let genderSelected = genderSelected {
        switch genderSelected {
        case .either:
          genderFemaleButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          genderMaleButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          genderEitherButton.backgroundColor = UIColor.zentaiSecondaryColor
        case .female:
          genderFemaleButton.backgroundColor = UIColor.zentaiSecondaryColor
          genderMaleButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          genderEitherButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .male:
          genderFemaleButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          genderMaleButton.backgroundColor = UIColor.zentaiSecondaryColor
          genderEitherButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        }
      }
    }
  }
  
  var allergySelected: OilAllergies? {
    didSet {
      if let allergySelected = allergySelected {
        switch allergySelected {
        case .no:
          allergyNoButton.backgroundColor = UIColor.zentaiSecondaryColor
          allergyYesButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .yes:
          allergyYesButton.backgroundColor = UIColor.zentaiSecondaryColor
          allergyNoButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        }
      }
    }
  }
  
  var petsSelected: Pets? {
    didSet {
      if let petsSelected = petsSelected {
        switch petsSelected {
        case .both:
          petsCatButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsDogButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsBothButton.backgroundColor = UIColor.zentaiSecondaryColor
          nonePetsButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .cat:
          petsCatButton.backgroundColor = UIColor.zentaiSecondaryColor
          petsDogButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsBothButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          nonePetsButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .dog:
          petsCatButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsDogButton.backgroundColor = UIColor.zentaiSecondaryColor
          petsBothButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          nonePetsButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
        case .none:
          petsCatButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsDogButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          petsBothButton.backgroundColor = UIColor.zentaiSecondaryColorOpaque
          nonePetsButton.backgroundColor = UIColor.zentaiSecondaryColor
        }
      }
    }
  }
  
  var firstOptionDate: (Date?, Date?, Date?)? {
    didSet {
      
    }
  }
  
  func setAddressInfo(address: String, city: String, state: String, zip: String) {
    self.address = address
    self.city = city
    self.state = state
    self.zip = zip
  }
  
  func didSelectPosition(latitude: Double, longitude: Double) -> Void {
    lastPositionSelected = (latitude, longitude)
    print(lastPositionSelected)
  }
  
  
  var secondOptionDate: (Date?, Date?, Date?)?
  var thirdOptionDate: (Date?, Date?, Date?)?
  
  var lastPositionSelected: (latitude: Double, longitude: Double)?
  
  var address: String? {
    
    get {
      let a = addressTextField.text!
      
      if a.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
        return nil
      }
      
      return a
    }
    
    set {
      addressTextField.text = newValue
    }
  }
  
  var apartment: String? {
    get {
      let r = roomTextField.text!
      
      if r.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
        return nil
      }
      
      return r
    }
    
    set {
      roomTextField.text = newValue
    }
    
  }
  
  var city: String? {
    get {
      let c = cityTextField.text!
      
      if c.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
        return nil
      }
      
      return c
    }
    
    set {
      cityTextField.text = newValue
    }
  }
  
  var state: String? {
    get {
      let s = stateButton.currentTitle!
      
      if s == "State" {
        return nil
      }
      
      return s
    }
    
    set {
      if let newValue = newValue, !newValue.isEmpty {
        stateButton.setTitle(newValue, for: .normal)
        stateButton.setTitleColor(.hexStringToUIColor(hex: "#666666"), for: .normal)
      }
    }
    
  }
  
  var zip: String? {
    get {
      let z = zipTextField.text!
      
      if z.isEmpty {
        return nil
      }
      
      return z
    }
    
    set {
      zipTextField.text = newValue
    }
  }
  
  
  @IBOutlet weak var firstStackViewTopConstraint: NSLayoutConstraint!
  
  //Location UI
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var roomTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var stateButton: UIButton!
  @IBOutlet weak var zipTextField: UITextField!
  
  @IBOutlet weak var parkingInstructionsButton: UIButton!
  @IBOutlet weak var locationHelpButton: UIButton!
  @IBOutlet weak var secondSummaryView: UIView!
  @IBOutlet weak var secondStackView: UIStackView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var secondSummaryViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondStackViewTopConstraint: NSLayoutConstraint!
  
  // OPTIONS UI
  @IBOutlet weak var thirdStackView: UIStackView!
  @IBOutlet weak var thirdSummaryView: UIView!
  @IBOutlet weak var thirdStackViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var thirdSummaryViewTopConstraint: NSLayoutConstraint!
  
  
  // SUMMARY
  @IBOutlet weak var fourthStackView: UIStackView!
  @IBOutlet weak var fourthStackViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var parkingHelperButton: UIButton!
  
  
  @IBOutlet weak var buttonArrowBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonConfirmBottomConstraint: NSLayoutConstraint!
  
  //  var timer = Timer()
  
  @IBOutlet weak var arrowDownCenterYConstraint: NSLayoutConstraint!
  
  var states = Utils.getStates()
  let stateCellId = "stateCell"
  lazy var touchHandler: TouchHandler = {
    return TouchHandler(tableView: self.statesTableView)
  }()
  
  var genderHelpView: UIView?
  var allergiesHelpView: UIView?
  var petsHelpView: UIView?
  var locationHelpView: UIView?
  var availabilityHelpView: UIView?
  var parkingCostHelpView: UIView?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  deinit {
    if let userId = currentUser?.id {
      User.removeHandler(id: getUserHandler, userId: userId)
    }
    
    
    //    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    //    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  @IBAction func paymentInfoButtonTouched() {
    performSegue(withIdentifier: Storyboard.BookingToAdditionalPromo, sender: nil)
  }
  
  @IBAction func parkingInstructionsButtonTouched() {
    performSegue(withIdentifier: Storyboard.BookingToParkingInstructions, sender: nil)
  }
  
  
  @IBAction func arrowUpButtonTouched() {
    //    dismissWindow(.bottom)
    previousStep()
  }
  
  @IBAction func parkingCostHelpTouched() {
    if parkingCostHelpView == nil {
      parkingCostHelpView = createInfoPopup(
        root: view,
        item: parkingHelperButton,
        witdh: 150,
        height: 100,
        text: Constants.Texts.bookingLocationHelpText
      )
    }
    
    
    
    if parkingCostHelpView?.alpha == 0 {
      viewTapped()
      showView(view: parkingCostHelpView!)
    } else {
      viewTapped()
    }
  }
  
  @IBAction func femaleButtonTouched() {
    genderSelected = PracticionerGender.female
    //    nextStep()
  }
  
  @IBAction func eitherButtonTouched() {
    genderSelected = PracticionerGender.either
    //    nextStep()
  }
  
  @IBAction func maleButtonTouched() {
    genderSelected = PracticionerGender.male
    //    nextStep()
  }
  
  @IBAction func allergyYesButtonTouched() {
    allergySelected = .yes
    //    nextStep()
  }
  
  @IBAction func allergyNoButtonTouched() {
    allergySelected = .no
    //    nextStep()
  }
  
  @IBAction func petsDogButtonTouched() {
    petsSelected = .dog
    //    nextStep()
  }
  
  @IBAction func petsBothButtonTouched() {
    petsSelected = .both
    //    nextStep()
  }
  
  @IBAction func petsCatButtonTouched() {
    petsSelected = .cat
    //    nextStep()
  }
  
  @IBAction func petsNoneButtonTouched() {
    petsSelected = Pets.none
  }
  
  @IBAction func tbdButtonTouched() {
    performSegue(withIdentifier: Storyboard.BookingToParkingCost, sender: nil)
  }
  
  @IBAction func locationHelpButtonTouched(_ sender: AnyObject) {
    if locationHelpView == nil {
      locationHelpView = createInfoPopup(
        root: view,
        item: locationHelpButton,
        witdh: 160,
        height: 150,
        text: Constants.Texts.bookingLocationHelpText
      )
    }
    
    
    if locationHelpView?.alpha == 0 {
      viewTapped()
      showView(view: locationHelpView!)
    } else {
      viewTapped()
    }
  }
  
  
  @IBAction func allergiesHelpButtonTouched() {
    if allergiesHelpView == nil {
      allergiesHelpView = createInfoPopup(
        root: view,
        item: allergyHelpButton,
        witdh: 150,
        height: 130,
        text: Constants.Texts.bookingOilAllergiesHelpText
      )
    }
    
    if allergiesHelpView?.alpha == 0 {
      viewTapped()
      showView(view: allergiesHelpView!)
    } else {
      viewTapped()
    }
  }
  
  
  @IBAction func petsHelpButtonTouched() {
    if petsHelpView == nil {
      
      petsHelpView = createInfoPopup(
        root: view,
        item: petsHelpButton,
        witdh: 150,
        height: 130,
        text: Constants.Texts.bookingPetsHelpText
      )
    }
    
    if petsHelpView?.alpha == 0 {
      viewTapped()
      showView(view: petsHelpView!)
    } else {
      viewTapped()
    }
  }
  
  @IBAction func genderHelpButtonTouched() {
    if genderHelpView == nil {
      genderHelpView = createInfoPopup(
        root: view,
        item: genderHelpButton,
        witdh: 160, //150
        height: 110,// 100
        text: Constants.Texts.bookingGenderHelpText
      )
    }
    
    if genderHelpView?.alpha == 0 {
      viewTapped()
      showView(view: genderHelpView!)
    } else {
      viewTapped()
    }
  }
  
  @IBAction func availabilityHelpButtonTouched() {
    if availabilityHelpView == nil {
      availabilityHelpView = createInfoPopup(
        root: view,
        item: availabilityHelpButton,
        witdh: 160,
        height: 110,
        text: Constants.Texts.bookingAvailabilityHelpText
      )
    }
    
    if availabilityHelpView?.alpha == 0 {
      viewTapped()
      showView(view: availabilityHelpView!)
    } else {
      viewTapped()
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
  
  var flag = false
  
  
  //  override func keyboardWillBeHidden(notification: Notification) {
  //    if step == 2 {
  //
  ////      view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + 50, width: view.frame.size.width, height: view.frame.size.height)
  //    }
  //  }
  //
  //  override func keyboardWillBeShown(notification: Notification) {
  //    if step == 2 {
  ////      view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y - 50, width: view.frame.size.width, height: view.frame.size.height)
  //    }
  //
  //    hideStatesTableView()
  //  }
  
  func viewTapped() {
    //    view.endEditing(true)
    hideView(view: statesTableView)
    
    if let genderHelpView = genderHelpView {
      hideView(view: genderHelpView)
    }
    
    if let petsHelpView = petsHelpView {
      hideView(view: petsHelpView)
    }
    
    if let allergiesHelpView = allergiesHelpView {
      hideView(view: allergiesHelpView)
    }
    
    if let locationHelpView = locationHelpView {
      hideView(view: locationHelpView)
    }
    
    if let availabilityHelpView = availabilityHelpView {
      hideView(view: availabilityHelpView)
    }
    
    if let parkingCostHelpView = parkingCostHelpView {
      hideView(view: parkingCostHelpView)
    }
  }
  
  func fillAddressInfoToUI(user: User) {
    self.address = user.address
    self.apartment = user.aparment
    self.city = user.city
    self.state = user.state
    self.zip = user.zip
    
    //  lastPositionSelected
  }
  
  func fillDataFromCache() {
    let defaults = UserDefaults.standard
    
    let gender = defaults.string(forKey: "genderSelected")
    let allergy = defaults.string(forKey: "allergySelected")
    let pets = defaults.string(forKey: "petsSelected")
    
    if let gender = gender {
      genderSelected = PracticionerGender(rawValue: gender)
    }
    
    if let allergy = allergy {
      allergySelected = OilAllergies(rawValue: allergy)
    } else {
      allergySelected = OilAllergies.no
    }
    
    if let pets = pets {
      petsSelected = Pets(rawValue: pets)
    }
    
    let latitude = defaults.double(forKey: "latitude")
    let longitude = defaults.double(forKey: "longitude")
    //    let address = defaults.string(forKey: "address")
    //    let apartment = defaults.string(forKey: "apartment")
    //    let city = defaults.string(forKey: "city")
    //    let state = defaults.string(forKey: "state")
    //    let zip = defaults.string(forKey: "zip")
    let parkingInstructions = defaults.string(forKey: "parkingInstructions")
    let parkingCost = defaults.double(forKey: "parkingCost")
    
    if latitude == 0 || longitude == 0 {
      self.lastPositionSelected = nil
    } else {
      self.lastPositionSelected = (latitude, longitude)
    }
    
    //    self.address = address
    //    self.apartment = apartment
    //    self.city = city
    //    self.state = state
    //    self.zip = zip
    self.parkingInstructions = parkingInstructions
    self.parkingCost = parkingCost
  }
  
  var getUserHandler: UInt = 0
  let sessionCost: Double = 99
  let credits = 0
  var numberOfSessions = 1
  var tip: Double { return 0 }
  var total: Double { return tip + (sessionCost * Double(numberOfSessions)) + parkingCost }
  
  func setAmountsOnSummary() {
    //    creditLabel.text = numberFormatter.string(from: credits as NSNumber)
    titleSessionLabel.text = "1 Session - 60 Mins."
    sessionLabel.text = numberFormatter.string(from: sessionCost as NSNumber)
    //    tipLabel.text = numberFormatter.string(from: tip as NSNumber)
    
    parkingCostLabel.text = numberFormatter.string(from: parkingCost as NSNumber)
    totalPaymentLabel.text = numberFormatter.string(from: total as NSNumber)
  }
  
  func addressViewWasTapped() {
    //    performSegue(withIdentifier: Storyboard.BookingToMap, sender: nil)
    viewTapped()
    performSegue(withIdentifier: Storyboard.BookingToSearchAddress, sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.bringSubview(toFront: statesTableView)
    
    print(bookingSpecificPractitionerId)
    
    parkingHelperButton.alpha = 0
    
    //    locationHelpButton.alpha = 0
    
    internalView = view
    rootViewFrame = view.frame
    
    //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    //    @IBOutlet weak var addTimeFirstButton: UIButton!
    //    @IBOutlet weak var addTimeSecondButton: UIButton!
    //    @IBOutlet weak var addTimeThirdButton: UIButton!
    
    
    setupTopImageHeight()
    updateFirstStackViewTopConstraint()
    
    topImageView.clipsToBounds = true
    
    let addressViewGesture = UITapGestureRecognizer(target: self, action: #selector(addressViewWasTapped))
    addressViewGesture.numberOfTapsRequired = 1
    addressViewGesture.numberOfTouchesRequired = 1
    
    addressView.addGestureRecognizer(addressViewGesture)
    
    step = 1
    
    //    numberFormatter.numberStyle = .currency
    //    numberFormatter.currencyCode = "USD"
    
    //    cleanCacheData()
    
    
    fillDataFromCache()
    setAmountsOnSummary()
    
    getUserHandler = User.getCurrentUser(once: false, navigationController: navigationController) { (user) in
      if let user = user {
        self.currentUser = user
        if let last4 = user.last4 {
          DispatchQueue.main.async {
            self.setCardNumber(last4: last4)
            self.fillAddressInfoToUI(user: user)
            
            if user.latitude == 0 && user.longitude == 0 {
              self.lastPositionSelected = nil
            } else {
              self.lastPositionSelected = (latitude: user.latitude, longitude: user.longitude)
            }
          }
        }
      }
    }
    
    enterPaymentStackView.isHidden = false
    paymentCardStackView.isHidden = true
    
    firstOptionTimeLabel.text = ""
    secondOptionTimeLabel.text = ""
    thirdOptionTimeLabel.text = ""
    
    
    let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    viewTapGesture.numberOfTapsRequired = 1
    viewTapGesture.numberOfTouchesRequired = 1
    viewTapGesture.delegate = touchHandler
    view.addGestureRecognizer(viewTapGesture)
    
    
    let viewSwipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(viewSwapDown))
    viewSwipeDownGesture.direction = .down
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(viewSwipeDownGesture)
    
    let viewSwipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(viewSwapUp))
    viewSwipeUpGesture.direction = .up
    view.addGestureRecognizer(viewSwipeUpGesture)
    
    statesTableView.alpha = 0
    
    firstSummaryView.alpha = 0
    
    errorMessageLabel.isHidden = true
    secondSummaryView.alpha = 0
    
    thirdStackView.alpha = 0
    thirdSummaryView.alpha = 0
    
    fourthStackView.alpha = 0
    confirmButton.alpha = 0
    
    let firstSummaryViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstSummaryViewTapped))
    firstSummaryViewTapGesture.numberOfTapsRequired = 1
    firstSummaryViewTapGesture.numberOfTouchesRequired = 1
    firstSummaryView.isUserInteractionEnabled = true
    firstSummaryViewTapGesture.cancelsTouchesInView = false
    firstSummaryView.addGestureRecognizer(firstSummaryViewTapGesture)
    
    let secondSummaryViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondSummaryViewTapped))
    secondSummaryViewTapGesture.numberOfTapsRequired = 1
    secondSummaryViewTapGesture.numberOfTouchesRequired = 1
    secondSummaryView.addGestureRecognizer(secondSummaryViewTapGesture)
    secondSummaryView.isUserInteractionEnabled = true
    
    let thirdSummaryViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(thirdSummaryViewTapped))
    thirdSummaryViewTapGesture.numberOfTapsRequired = 1
    thirdSummaryViewTapGesture.numberOfTouchesRequired = 1
    thirdSummaryView.isUserInteractionEnabled = true
    //    thirdSummaryViewTapGesture.delegate = touchHandler
    //    thirdSummaryViewTapGesture.cancelsTouchesInView = false
    thirdSummaryView.addGestureRecognizer(thirdSummaryViewTapGesture)
    
  }
  
  func showSecondStackViewInitially() {
    
  }
  
  func thirdSummaryViewTapped() {
    previousStep()
  }
  
  func configureLocationControls() {
    addressTextField.borderStyle = .none
    addressTextField.addBottomLine(color: UIColor.zentaiGray)
    
    roomTextField.borderStyle = .none
    roomTextField.addBottomLine(color: UIColor.zentaiGray)
    
    cityTextField.borderStyle = .none
    cityTextField.addBottomLine(color: UIColor.zentaiGray)
    
    zipTextField.borderStyle = .none
    zipTextField.addBottomLine(color: UIColor.zentaiGray)
    
    stateButton.addBottomLine(color: UIColor.zentaiGray)
    
    
  }
  
  func viewSwapDown() {
    previousStep()
  }
  
  func viewSwapUp() {
    nextStep()
  }
  
  func firstSummaryViewTapped() {
    print("------------------------")
    print(step)
    print("------------------------")
    viewTapped()
    
    if step > 1 {  // step == 4
      resetSecondStep()
      
      hideFirstSummary()
      hideSecondSummary()
      hideThirdSummary()
      
      hideSecondStackView()
      hideThirdStackView()
      hideFourthStackView()
      hideConfirmButton()
      
      showTopImage()
      updateFirstStackViewTopConstraint()
      showFirstStackViewPlanned()
      showArrowButton()
      
      step = 1
    } else {
      previousStep()
    }
  }
  
  func secondSummaryViewTapped() {
    
    if step == 4 {
      showTopImage()
      increaseTopImageHeight()
      updateFirstStackViewTopConstraint()
      
      hideSecondSummary()
      
      showFirstSummary()
      showSecondStackView()
      
      hideThirdSummary()
      hideFourthStackView()
      hideConfirmButton()
      
      resetSecondStep()
      
      step = 2
      showArrowButton()
    } else {
      previousStep()
    }
  }
  
  
  
  func showStatesTableView() {
    view.endEditing(true)
    //    self.statesTableView.reloadData()
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.statesTableView.alpha = 1
      },
      completion: nil)
  }
  
  func hideStatesTableView() {
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.statesTableView.alpha = 0
      },
      completion: nil)
  }
  
  @IBOutlet weak var stateArrowButton: UIButton!
  
  @IBAction func stateArrowButtonTouched() {
    
    
    
    stateButtonTouched()
  }
  
  @IBAction func stateButtonTouched() {
    view.endEditing(true)
    
    if UIDevice.screenType == .iPhone6
      ||
      UIDevice.screenType == .iPhone6Plus
      ||
      UIDevice.screenType == .Unknown {
      stateTableViewTopConstraint.constant = -190
    } else {
      stateTableViewTopConstraint.constant = 5
    }
    
    if statesTableView.alpha == 0 {
      showView(view: statesTableView)
    } else {
      hideView(view: statesTableView)
    }
  }
  
  func stateButtonHighlighted(any: UIButton) {
    self.stateArrowButton.isHighlighted = false
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    
    bottomArrowButton.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 * M_PI / 180.0))
    
  }
  
  // here
  // image height + image top space + button height + button space
  var topPosition: CGFloat {
    print(topImageHeightConstraint.constant)
    
    if topImageHeightConstraint.constant > 0 {
      return CGFloat(topImageHeightConstraint.constant + CGFloat(8 + 23 + 10 + 20))
    } else {
      return CGFloat(topImageHeightConstraint.constant + CGFloat(8 + 23 + 10))
    }
    
    //    return CGFloat(0)
  }
  
  var spaceBetweenComponents: CGFloat {
    //20
    switch UIDevice.screenType {
    case .iPhone4, .iPhone5:
      return 10
    case .iPhone6, .iPhone6Plus, .Unknown:
      return 5 // 20  // zentai
    }
  }
  
  var firstStackViewPositionY: CGFloat {
    return CGFloat(topPosition)
  }
  
  var secondStackViewPositionY: CGFloat {
    return firstStackViewPositionY + heightFirstSummaryView + spaceBetweenComponents
  }
  
  var thirdStackViewPositionY: CGFloat {
    return secondStackViewPositionY + heightSecondSummaryView + spaceBetweenComponents
  }
  
  let heightFirstSummaryView: CGFloat = 68
  let heightSecondSummaryView: CGFloat = 73
  
  let variationTopImageHeight: CGFloat = 110
  
  @IBOutlet weak var topImageView: UIImageView!
  
  func increaseTopImageHeight() {
    switch UIDevice.screenType {
    case .iPhone4:
      fallthrough
    case .iPhone5:
      topImageHeightConstraint.constant = 0
    case .iPhone6:
      topImageHeightConstraint.constant += variationTopImageHeight
    case .iPhone6Plus:
      fallthrough
    case .Unknown:
      topImageHeightConstraint.constant += variationTopImageHeight
    }
  }
  
  func decreaseTopImageHeight() {
    switch UIDevice.screenType {
    case .iPhone4:
      fallthrough
    case .iPhone5:
      topImageHeightConstraint.constant = 0
    case .iPhone6:
      topImageHeightConstraint.constant -= variationTopImageHeight
    case .iPhone6Plus:
      fallthrough
    case .Unknown:
      topImageHeightConstraint.constant -= variationTopImageHeight
    }
  }
  
  func updateFirstStackViewTopConstraint() {
    firstStackViewTopConstraint.constant = CGFloat(topPosition + spaceBetweenComponents)
  }
  
  var topImageHeight: CGFloat = 0
  
  func setupTopImageHeight() {
    switch UIDevice.screenType {
    case .iPhone4:
      fallthrough
    case .iPhone5:
      topImageHeightConstraint.constant = 0
      topImageHeight = 0
    case .iPhone6:
      topImageHeightConstraint.constant = 130 //100
      topImageHeight = 130
    case .iPhone6Plus:
      fallthrough
    case .Unknown:
      topImageHeightConstraint.constant = 190 //150
      topImageHeight = 190
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    bottomArrowButton.makeMeCircled()
    bottomArrowButton.applyBackTransparentShadow(withOffset: CGSize(width: 0, height: -2))  // 0 -3
  }
  
  func configureCircles() {
    //    arrowButton.makeMeCircled(customWidth: 0, color: .clear)
    
    genderFemaleButton.makeMeCircled(customWidth: 0, color: .clear)
    genderEitherButton.makeMeCircled(customWidth: 0, color: .clear)
    genderMaleButton.makeMeCircled(customWidth: 0, color: .clear)
    
    
    //    availabilityHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    
    //    let image = UIView.drawDottedImage(width: availabilityHelpButton.frame.width, height: availabilityHelpButton.frame.height, color: .green)
    //    availabilityHelpButton.setBackgroundImage(image, for: .normal)
    
    
    
    allergyNoButton.makeMeCircled(customWidth: 0, color: .clear)
    allergyYesButton.makeMeCircled(customWidth: 0, color: .clear)
    
    petsCatButton.makeMeCircled(customWidth: 0, color: .clear)
    petsDogButton.makeMeCircled(customWidth: 0, color: .clear)
    petsBothButton.makeMeCircled(customWidth: 0, color: .clear)
    nonePetsButton.makeMeCircled(customWidth: 0, color: .clear)
    
    firstGenderButton.makeMeCircled(customWidth: 0, color: .clear)
    secondGenderButton.makeMeCircled(customWidth: 0, color: .clear)
    thirdGenderButton.makeMeCircled(customWidth: 0, color: .clear)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    availabilityHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    genderHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    allergyHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    petsHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    
    locationHelpButton.makeMeDashedCircled(customWidth: 0, color: .zentaiPrimaryColor)
    parkingHelperButton.makeMeDashedCircled(customWidth: 0, color: UIColor.zentaiPrimaryColor)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    Spinner.dismiss()
  }
  
  @IBAction func changePaymentCard() {
    performSegue(withIdentifier: Storyboard.BookingToPayment, sender: nil)
  }
  
  @IBAction func confirmAppointment() {
    confirmButton.isEnabled = false
  
    guard let customerId = currentUser?.stripeId else {
      let alert = UIAlertController(title: "Error", message: Constants.ErrorMessages.CardNotSet, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      confirmButton.isEnabled = true
      self.present(alert, animated: true, completion: nil)
      return
    }

    let practitionerGender = self.genderSelected!.rawValue
    let oilAllergy = self.allergySelected?.rawValue
    let anyPets = self.petsSelected!.rawValue
    
    var session = Session()
    session.practitionerGender = practitionerGender
    session.oilAllergy = oilAllergy
    session.anyPets = anyPets
    session.address = address!
    session.apartment = apartment ?? ""
    session.city = city ?? ""
    session.state = state ?? ""
    session.zip = zip ?? ""
    session.cost = total
    
    session.parkingInstructions = parkingInstructions

    session.firstAvailabilityDate = firstOptionDate!.0!
    session.firstAvailabilityStart = firstOptionDate!.1!
    session.firstAvailabilityEnd = firstOptionDate!.2!
    
    session.secondAvailabilityDate = secondOptionDate?.0
    session.secondAvailabilityStart = secondOptionDate?.1
    session.secondAvailabilityEnd = secondOptionDate?.2
    
    session.thirdAvailabilityDate = thirdOptionDate?.0
    session.thirdAvailabilityStart = thirdOptionDate?.1
    session.thirdAvailabilityEnd = thirdOptionDate?.2

    let sessionJSON = session.toJSON()

    var transaction = Transaction()
    transaction.creditsUsed = 0
    transaction.numberOfSessions = numberOfSessions
    transaction.priceSession = sessionCost
    transaction.tip = tip
    transaction.parkingCost = parkingCost
    transaction.total = total
    
    let transactionJSON = transaction.toJSON()
    let urlString = Constants.Server.chargeWithoutCaptureURL
    
    
    if let userId = currentUser?.id {

      var data = [String: Any]()
      
      print(bookingSpecificPractitionerId)
      data["bookingSpecificPractitionerId"] = bookingSpecificPractitionerId ?? ""
      data["amount"] = (transaction.total ?? 0) * 100
      data["userId"] =  userId
      data["customerId"] =  customerId
      data["clientName"] =  "\((currentUser?.firstName ?? "")) \((currentUser?.lastName ?? ""))"
      data["session"] =  sessionJSON
      data["transaction"] =  transactionJSON
      data["latitude"] =  lastPositionSelected?.latitude ?? 0
      data["longitude"] =  lastPositionSelected?.longitude ?? 0
      
      SVProgressHUD.show()

      Alamofire.request(
        urlString,
        method: .post,
        parameters: data,
        encoding: JSONEncoding.default
        )
        .validate()
        .responseJSON(completionHandler: { response in
          SVProgressHUD.dismiss()
          FIRCrashMessage("6:Result from request...")
          
          self.confirmButton.isEnabled = true
          
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            
            if json["error"].boolValue {
              let alert = UIAlertController(title: "Error", message: json["message"].stringValue, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              
              DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
              }
            } else {
              let sessionId = json["sessionId"].string
              session.id = sessionId
              print(sessionId)
              
              
              DispatchQueue.main.async {
                self.performSegue(withIdentifier: Storyboard.BookingToScheduled, sender: session)
              }
            }
          case .failure(let error):
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
            
            DispatchQueue.main.async {
              self.present(alert, animated: true, completion: nil)
            }
          }
          
        })
    }
  }
  
  var step = 1
  
  @IBAction func downOptions() {
    //    hideArrowButton()
    nextStep()
  }
  
  var currentAddTime: UIButton?
  var parkingInstructions: String?
  var parkingCost: Double = 0
  
  func setParkingInstructions(instructions: String?) {
    view.endEditing(true)
    parkingInstructions = instructions
    //    nextStep()
  }
  
  
  @IBAction func closePopup(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
  func setCardNumber(last4: String?) {
    cardLabel.text = "**** **** **** \(last4 ?? "****")"
    
    enterPaymentStackView.isHidden = true
    paymentCardStackView.isHidden = false
  }
  
  func setParkingCost(amount: Double?) {
    parkingCost = amount ?? 0
    
    let defaults = UserDefaults.standard
    defaults.set(parkingCost, forKey: "parkingCost")
    
    setAmountsOnSummary()
  }
  
  func setTime(date: (String, Date)?, start: Date?, end: Date?) {
    var text: String?
    
    if let date  = date,
      let start = start,
      let end   = end    {
      //      var textDay = Utils.format(date: date)
      let textStart = Utils.format(time: start)
      let textEnd = Utils.format(time: end)
      
      text = "\(date.0), \(textStart) - \(textEnd)"
    } else {
      return
    }
    
    if currentAddTime === addTimeFirstButton {
      firstOptionDate = (date?.1, start, end)
      firstOptionTimeLabel.text = text
    } else if currentAddTime == addTimeSecondButton {
      
      if firstOptionDate == nil {
        currentAddTime = addTimeFirstButton
        firstOptionDate = (date?.1, start, end)
        firstOptionTimeLabel.text = text
      } else {
        secondOptionDate = (date?.1, start, end)
        secondOptionTimeLabel.text = text
      }
      
    } else if currentAddTime == addTimeThirdButton {
      if firstOptionDate == nil {
        currentAddTime = addTimeFirstButton
        firstOptionDate = (date?.1, start, end)
        firstOptionTimeLabel.text = text
      } else {
        thirdOptionDate = (date?.1, start, end)
        thirdOptionTimeLabel.text = text      }
    }
    
    if let text = text {
      
      if currentAddTime === addTimeFirstButton || currentAddTime === addTimeThirdButton {
        //        nextStep()
      }
      
      currentAddTime?.setTitle(text, for: .normal)
    }
    
  }
  
  var viewAppointmentViewController: (Session) -> Void = { _ in }
  
  func goBackHome(with session: Session) {
    dismiss(animated: true) {
      self.viewAppointmentViewController(session)
    }
  }
  
  func goBackHome() {
    dismiss(animated: true) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.BookingToChooseTime {
      let viewController = segue.destination as? ChooseTimeViewController
      viewController?.setTime = setTime
    } else if segue.identifier == Storyboard.BookingToParkingInstructions {
      let viewController = segue.destination as? ParkingInstructionsViewController
      viewController?.setInstructions = setParkingInstructions
      viewController?.instructions = parkingInstructions
    } else if segue.identifier == Storyboard.BookingToParkingCost {
      let viewController = segue.destination as? ParkingCostViewController
      viewController?.setParkingCost = setParkingCost
      viewController?.parkingCost = parkingCost
    } else if segue.identifier == Storyboard.BookingToAdditionalPromo {
      let viewController = segue.destination as? AdditionalPromoViewController
      viewController?.setCard = setCardNumber
    } else if segue.identifier == Storyboard.BookingToScheduled {
      let viewController = segue.destination as? ScheduledViewController
      viewController?.session = sender as? Session
    } else if segue.identifier == Storyboard.BookingToMap {
      let nv = segue.destination as? UINavigationController
      let vc = nv?.viewControllers.first as? BookingMapVC
      
      vc?.didSelectPosition = didSelectPosition
      vc?.lastPositionSelected = lastPositionSelected
      vc?.setAddressInfo = setAddressInfo
    } else if segue.identifier == Storyboard.BookingToSearchAddress {
      let vc = segue.destination as? GoogleAddressVC
      //      let vc = nv?.viewControllers.first as? GoogleAddressVC
      
      vc?.setAddressInfo = setAddressInfo
      vc?.didSelectPosition = didSelectPosition
      vc?.lastPositionSelected = lastPositionSelected
    }
  }
  
  @IBAction func addTimeFirstButtonTouched() {
    viewTapped()
    currentAddTime = addTimeFirstButton
    performSegue(withIdentifier: Storyboard.BookingToChooseTime, sender: nil)
  }
  
  @IBAction func addTimeSecondButtonTouched() {
    viewTapped()
    currentAddTime = addTimeSecondButton
    performSegue(withIdentifier: Storyboard.BookingToChooseTime, sender: nil)
  }
  
  @IBAction func addTimeThirdButtonTouched() {
    viewTapped()
    currentAddTime = addTimeThirdButton
    performSegue(withIdentifier: Storyboard.BookingToChooseTime, sender: nil)
  }
  
  func resetSecondStep() {
    hideErrorMessage()
    
    addressTextField.addBottomLine(color: UIColor.zentaiGray)
    roomTextField.addBottomLine(color: UIColor.zentaiGray)
    cityTextField.addBottomLine(color: UIColor.zentaiGray)
    stateButton.addBottomLine(color: UIColor.zentaiGray)
    zipTextField.addBottomLine(color: UIColor.zentaiGray)
  }
  
  func isValidStep(step: Int) -> Bool {
    if step == 1 {
      var valid = true
      
      if genderSelected == nil {
        practicionerGenderStackView.shake()
        valid = false
      }
      
      //      if allergySelected == nil {
      //        allergiesStackView.shake()
      //        valid = false
      //      }
      
      if petsSelected == nil {
        petsStackView.shake()
        valid = false
      }
      
      return valid
    } else if step == 2 {
      var errorMessage: String?
      var controlToShake: UIView?
      var valid = true
      
      addressTextField.addBottomLine(color: UIColor.zentaiGray)
      roomTextField.addBottomLine(color: UIColor.zentaiGray)
      cityTextField.addBottomLine(color: UIColor.zentaiGray)
      stateButton.addBottomLine(color: UIColor.zentaiGray)
      zipTextField.addBottomLine(color: UIColor.zentaiGray)
      
      if address == nil {
        errorMessage = Constants.ErrorMessages.AddressEmpty
        controlToShake = addressTextField
        valid = false
        
        //      else if apartment == nil {
        //        errorMessage = Constants.ErrorMessages.RoomEmpty
        //        controlToShake = roomTextField
        //        valid = false
      } else if city == nil {
        errorMessage = Constants.ErrorMessages.CityEmpty
        controlToShake = cityTextField
        valid = false
      } else if state == nil {
        errorMessage = Constants.ErrorMessages.StateEmpty
        controlToShake = stateButton
        valid = false
      } else if zip == nil {
        errorMessage = Constants.ErrorMessages.ZipEmpty
        controlToShake = zipTextField
        valid = false
      } else if parkingInstructions == nil || (parkingInstructions?.isEmpty ?? true) {
        errorMessage = Constants.ErrorMessages.ParkingInstructionsEmpty
        controlToShake = parkingInstructionsButton
        valid = false
      }
      
      if !valid {
        errorMessageLabel.text = errorMessage
        thirdStackViewTopConstraint.constant = 360 + 30
        UIView.animate(withDuration: 0.3, animations: {
          self.view.layoutIfNeeded()
          self.errorMessageLabel.isHidden = false
          }, completion: { (success) in
            if success {
              controlToShake?.shake()
              
              if controlToShake !== self.parkingInstructionsButton {
                controlToShake?.addBottomLine(color: UIColor.zentaiPrimaryColor)
              }
            }
        })
      }
      
      return valid
    } else if step == 3 {
      var valid = true
      var controlToShake: UIView?
      
      if firstOptionDate == nil {
        controlToShake = addTimeFirstButton
        valid = false
      }
      
      //      else if secondOptionDate == nil {
      //        controlToShake = addTimeSecondButton
      //        valid = false
      //      } else if thirdOptionDate == nil {
      //        controlToShake = addTimeThirdButton
      //        valid = false
      //      }
      
      if !valid {
        controlToShake?.shake()
      }
      
      return valid
    }
    
    return true
  }
  
  func showErrorMessage() {
    UIView.animate(withDuration: 0.3) {
      self.errorMessageLabel.isHidden = false
    }
  }
  
  func hideErrorMessage() {
    UIView.animate(withDuration: 0.3) {
      self.errorMessageLabel.isHidden = true
    }
  }
  
  func nextStep() {
    viewTapped()
    
    if isValidStep(step: step) {
      if step < 4 {
        step += 1
      }
      
      print("next step \(step)")
      
      if step == 1 {
        // show first stack view
      } else if step == 2 {
        topImageView.image = UIImage(named: "booking2")
        increaseTopImageHeight()
        updateFirstStackViewTopConstraint()
        
        resetSecondStep()
        hideFirstStackView()
        showFirstSummary()
        
        showSecondStackView()
        //        showSecondStackViewPlanned() // ?
      } else if step == 3 {
        topImageView.image = UIImage(named: "booking3")
        //        updateFirstStackViewTopConstraint()
        hideSecondStackView()
        showSecondSummary()
        showThirdStackViewSecondTime()
        
        //        showThirdStackView()
      } else if step == 4 {
        hideTopImage()
        updateFirstStackViewTopConstraint()
        
        showFirstSummary()
        showSecondSummary()
        showThirdSummary()
        hideThirdStackViewPlanned()
        
        showFourthStackView()
        
        showConfirmButton()
        hideArrowButton()
      }
    }
  }
  
  func previousStep() {
    viewTapped()
    errorMessageLabel.isHidden = true
    //    hideStatesTableView()
    view.endEditing(true)
    if step >= 1 {
      step -= 1
    }
    
    print("previous step \(step)")
    
    if step == 0 {
      self.dismiss(animated: true, completion: nil)
    } else if step == 1 {
      topImageView.image = UIImage(named: "booking1")
      showTopImage()
      updateFirstStackViewTopConstraint()
      
      hideSecondStackViewToDown()
      hideFirstSummary()
      
      showFirstStackViewPlanned()
      showArrowButton()
    } else if step == 2 {
      topImageView.image = UIImage(named: "booking2")
      resetSecondStep()
      
      showTopImage()
      increaseTopImageHeight()
      updateFirstStackViewTopConstraint()
      
      showFirstSummary()
      
      hideSecondSummary()
      hideThirdStackView()
      
      showSecondStackView()
      showSecondStackViewPlanned()
      showArrowButton()
    } else if step == 3 {
      topImageView.image = UIImage(named: "booking3")
      
      showTopImage()
      increaseTopImageHeight()
      updateFirstStackViewTopConstraint()
      
      showFirstSummary()
      showSecondSummary()
      showThirdStackViewPlanned()
      showThirdStackViewSecondTime()
      
      hideThirdSummary()
      hideFourthStackView()
      
      hideConfirmButton()
      showArrowButton()
    }
  }
  
  func hideFirstStackView() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        var transform = self.firstStackView.transform
        transform = transform.translatedBy(x: 1, y: -150) // -180
        transform = transform.scaledBy(x: 1, y: 0.01)
        self.firstStackView.transform = transform
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.firstStackView.alpha = 0
      },
      completion: nil
    )
  }
  
  func showThirdSummary() {
    saveDataToCache()
    thirdSummaryViewTopConstraint.constant = thirdStackViewPositionY //160
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.thirdSummaryView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideThirdStackViewPlanned() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        var transform = self.thirdStackView.transform
        transform = transform.translatedBy(x: 1, y: -70)
        transform = transform.scaledBy(x: 1, y: 0.01)
        self.thirdStackView.transform = transform
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.thirdStackView.alpha = 0
      },
      completion: nil
    )
  }
  
  func showTopImage() {
    topImageHeightConstraint.constant = topImageHeight
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  
  
  func hideTopImage() {
    topImageHeightConstraint.constant = 0
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideThirdSummary() {
    thirdSummaryViewTopConstraint.constant = 900
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.thirdSummaryView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideThirdStackView() {
    thirdStackViewTopConstraint.constant = 900
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.thirdStackView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  //  @IBOutlet weak var parkingCostLabel: UILabel!
  //  @IBOutlet weak var totalPaymentLabel: UILabel!
  
  func showFourthStackView() {
    
    if let user = currentUser {
      if let last4 = user.last4 {
        setCardNumber(last4: last4)
      }
    }
    
    setAmountsOnSummary()
    
    fourthStackViewBottomConstraint.constant = 80 //74
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.fourthStackView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    statesTableView.makeMeBordered(color: UIColor.zentaiSecondaryColor)
    confirmButton.makeMeRounded()
    configureCircles()
    configureLocationControls()
    
    //F3F3F3
    //    addTimeFirstButton.makeMeBordered(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    //    addTimeSecondButton.makeMeBordered(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    //    addTimeThirdButton.makeMeBordered(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    
    addTimeFirstButton.makeMeRounded(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    addTimeSecondButton.makeMeRounded(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    addTimeThirdButton.makeMeRounded(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    
    parkingInstructionsButton.makeMeRounded(color: UIColor.hexStringToUIColor(hex: "#F3F3F3"))
    
    firstSummaryView.makeMeRounded()
    secondSummaryView.makeMeRounded()
    thirdSummaryView.makeMeRounded()
  }
  
  func hideFourthStackView() {
    fourthStackViewBottomConstraint.constant = -700
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.fourthStackView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func showThirdStackView() {
    showThirdStackViewSecondTime()
    
    thirdStackViewTopConstraint.constant = 360 //210 wilson
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.thirdStackView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func showThirdStackViewSecondTime() {
    showThirdStackViewPlanned()
    
    thirdStackViewTopConstraint.constant = thirdStackViewPositionY //210 wilson
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.thirdStackView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  //  func hideThirdStackViewSecondTime() {
  //
  //  }
  
  func showThirdStackViewPlanned() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.thirdStackView.transform = CGAffineTransform.identity
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.thirdStackView.alpha = 1
      },
      completion: nil
    )
  }
  
  func showFirstStackView() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.firstStackView.transform = CGAffineTransform.identity
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.firstStackView.alpha = 1
      },
      completion: nil
    )
  }
  
  func showFirstStackViewPlanned() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        
        self.firstStackView.transform = CGAffineTransform.identity
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.firstStackView.alpha = 1
      },
      completion: nil
    )
  }
  
  func showSecondStackViewPlanned() {
    addressView.isUserInteractionEnabled = true
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        
        self.secondStackView.transform = CGAffineTransform.identity
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.stateArrowButton.alpha = 1
        self.secondStackView.alpha = 1
      },
      completion: nil
    )
  }
  
  func showSecondStackView() {
    showSecondStackViewPlanned()
    
    secondStackViewTopConstraint.constant = secondStackViewPositionY
    self.stateArrowButton.alpha = 1
    addressView.isUserInteractionEnabled = true
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        
        self.secondStackView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideSecondStackViewToDown() {
    secondStackViewTopConstraint.constant = 1000
    //    self.stateArrowButton.alpha = 0
    addressView.isUserInteractionEnabled = false
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        
        //        self.secondStackView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideSecondStackView() {
    self.stateArrowButton.alpha = 0
    addressView.isUserInteractionEnabled = false
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        var transform = self.secondStackView.transform
        transform = transform.translatedBy(x: 1, y: -100)
        transform = transform.scaledBy(x: 1, y: 0.01)
        self.secondStackView.transform = transform
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.secondStackView.alpha = 0
      },
      completion: nil
    )
  }
  
  
  
  func showSecondSummary() {
    saveDataToCache()
    
    if let apartment = apartment {
      locationLabel.text = "\(apartment), \(address!)\n\(city!), \(state!) \(zip!)"
    } else {
      locationLabel.text = "\(address!)\n\(city!), \(state!) \(zip!)"
    }
    
    secondSummaryViewTopConstraint.constant = secondStackViewPositionY //121
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.secondSummaryView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideSecondSummary() {
    secondSummaryViewTopConstraint.constant = 781
    addressView.isUserInteractionEnabled = false
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.secondSummaryView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  @IBAction func bottomArrowButtonTouched() {
    nextStep()
  }
  
  func hideFirstSummary() {
    firstSummaryTopConstraint.constant = 579
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.firstSummaryView.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func showFirstSummary() {
    saveDataToCache()
    
    firstGenderButton.setTitle(genderSelected?.rawValue, for: .normal)
    secondGenderButton.setTitle(allergySelected?.rawValue, for: .normal)
    thirdGenderButton.setTitle(petsSelected?.rawValue, for: .normal)
    
    //    firstSummaryTopConstraint.constant = 45
    
    firstSummaryTopConstraint.constant = firstStackViewPositionY
    
    UIView.animate(
      withDuration: 0.3
      ,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.firstSummaryView.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  
  func showConfirmButton() {
    buttonConfirmBottomConstraint.constant = 15 //8 here
    
    UIView.animate(
      withDuration: 0.1,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.confirmButton.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
      }
    )
  }
  
  func hideConfirmButton() {
    buttonConfirmBottomConstraint.constant = -100
    
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.confirmButton.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        if completed {
          //          self.showArrowButton()
        }
      }
    )
  }
  
  func showArrowButton() {
    //    self.hideConfirmButton()
    
    buttonArrowBottomConstraint.constant = 20
    
    UIView.animate(
      withDuration: 0.1,
      delay: 0.2,
      options: .curveEaseOut,
      animations: {
        self.bottomArrowButton.alpha = 1
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        if completed {
          
        }
      }
    )
  }
  
  func hideArrowButton() {
    //    bottomArrowButton
    buttonArrowBottomConstraint.constant = -150
    
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: .curveEaseIn,
      animations: {
        self.bottomArrowButton.alpha = 0
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        if completed {
          //          self.showConfirmButton()
        }
      }
    )
  }
  
  func animateArrowButton() {
    
    print(self.arrowDownCenterYConstraint.constant)
    self.arrowDownCenterYConstraint.constant = 0
    print("before self.arrowDownCenterYConstraint.constant: \(self.arrowDownCenterYConstraint.constant)")
    self.arrowDownCenterYConstraint.constant -= 5
    print("after self.arrowDownCenterYConstraint.constant: \(self.arrowDownCenterYConstraint.constant)")
    
    UIView.animate(
      withDuration: 0.6,
      delay: 0,
      options: [.curveEaseOut],
      animations: {
        self.view.layoutIfNeeded()
      },
      completion: { completed in
        
        if completed {
          self.arrowDownCenterYConstraint.constant += 5
          print(self.arrowDownCenterYConstraint.constant)
          
          UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 10,
            initialSpringVelocity: 70,
            options: .curveEaseIn,
            animations: {
              self.view.layoutIfNeeded()
            },
            completion: nil
          )
        }
      }
    )
  }
}


extension UIView {
  func makeMeBordered(color: UIColor) {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = color.cgColor
  }
  
  func makeMeRounded(color: UIColor) {
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 2.0
    self.layer.borderColor = color.cgColor
    //    self.layer.masksToBounds = true
  }
  
  func makeMeRounded() {
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.clear.cgColor
    //    self.layer.masksToBounds = true
  }
  
  func makeMeCircled(customWidth: CGFloat = 0, color: UIColor = .clear) {
    self.layer.cornerRadius = customWidth == 0 ?self.frame.size.width / 2 : customWidth
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = 1.0
  }
  
  static func drawDottedImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 1.0, y: 1.0))
    path.addLine(to: CGPoint(x: width, y: 1))
    path.lineWidth = 1.5
    
    let dashes: [CGFloat] = [path.lineWidth, path.lineWidth * 5]
    path.setLineDash(dashes, count: 2, phase: 0)
    path.lineCapStyle = .butt
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 2)
    color.setStroke()
    path.stroke()
    
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
  }
  
  func makeMeDashedCircled(customWidth: CGFloat = 0, color: UIColor = .clear) {
    self.layer.cornerRadius = customWidth == 0 ?self.frame.size.width / 2 : customWidth
    //    self.layer.borderColor = color.cgColor
    //    self.layer.borderWidth = 1.0
    
    //    let x = self.frame.origin.x
    //    let y = self.frame.origin.y
    let width = self.frame.width
    let height = self.frame.height
    
    let circleLayer = CAShapeLayer()
    
    circleLayer.frame = self.bounds
    circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: self.layer.cornerRadius).cgPath
    //    circleLayer.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: width, height: height)).cgPath
    //    circleLayer.bounds = CGRect(x: 0, y: 0, width: width, height: height)
    //    circleLayer.position = CGPoint(x: width / 2, y: height / 2)
    circleLayer.lineWidth = 1.0
    circleLayer.strokeColor = color.cgColor
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineJoin = kCALineJoinRound
    circleLayer.lineDashPattern = [1, 2] //1, 3
    //    self.layer.mask = circleLayer
    self.layer.addSublayer(circleLayer)
  }
  
  func makeMeBlur() {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    self.addSubview(blurEffectView)
  }
  
  func applyBlackTransparentShadow() {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 10)
    self.layer.shadowOpacity = 0.5
  }
  
  func applyBackTransparentShadow(withOffset offset: CGSize) {
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = offset
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = 1.0
  }
}



extension BookingViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return states.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.backgroundColor = UIColor.zentaiSecondaryColor
    cell?.textLabel?.highlightedTextColor = .white
    let state = states[indexPath.row]
    
    stateButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#666666"), for: .normal)
    stateButton.setTitle(state.0, for: .normal)
    hideStatesTableView()
    //    nextStep()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
  //    let cell = tableView.cellForRow(at: indexPath)
  //    cell?.contentView.backgroundColor = UIColor.white
  //    cell?.textLabel?.textColor = .black
  //  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: stateCellId, for: indexPath)
    let state = states[indexPath.row]
    cell.textLabel?.text = state.1
    
    return cell
  }
  
}

class TouchHandler: NSObject, UIGestureRecognizerDelegate {
  var tableView: UITableView
  
  init(tableView: UITableView) {
    self.tableView = tableView
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view!.isDescendant(of: tableView) {
      return false
    }
    
    return true
  }
}

extension BookingViewController: UITextFieldNavigationDelegate {
  
  func doneTextField() {
    //    view.endEditing(true)
    //    textField.resignFirstResponder()
    view.endEditing(true)
    //    nextStep()
  }
  
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    doneTextField()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    //    resetSecondStep()
    currentTextField = textField
    errorMessageLabel.isHidden = true
    if textField.text?.isEmpty ?? true {
      //      nextStep()
    }
    
    
    //
  }
  
  func textFieldNavigationDidTapDoneButton(_ textField: UITextField) {
    textField.resignFirstResponder()
    //    view.endEditing(true)
    //    nextStep()
  }
  
}

extension BookingViewController {
  
  func cleanCacheData() {
    let defaults = UserDefaults.standard
    
    defaults.set(nil, forKey: "latitude")
    defaults.set(nil, forKey: "longitude")
    
    defaults.set(nil, forKey: "genderSelected")
    defaults.set(nil, forKey: "allergySelected")
    defaults.set(nil, forKey: "petsSelected")
    
    defaults.set(nil, forKey: "address")
    defaults.set(nil, forKey: "apartment")
    defaults.set(nil, forKey: "city")
    defaults.set(nil, forKey: "state")
    defaults.set(nil, forKey: "zip")
    defaults.set(nil, forKey: "parkingInstructions")
  }
  
  func saveDataToCache() {
    print("-----------------------------------saving data: \(step)")
    let defaults = UserDefaults.standard
    
    switch(step) {
    case 2:
      print("step 2")
      defaults.set(genderSelected?.rawValue, forKey: "genderSelected")
      defaults.set(allergySelected?.rawValue, forKey: "allergySelected")
      defaults.set(petsSelected?.rawValue, forKey: "petsSelected")
    case 3:
      print("step 2")
      defaults.set(lastPositionSelected?.latitude ?? 0, forKey: "latitude")
      defaults.set(lastPositionSelected?.longitude ?? 0, forKey: "longitude")
      
      defaults.set(address, forKey: "address")
      defaults.set(apartment, forKey: "apartment")
      defaults.set(city, forKey: "city")
      defaults.set(state, forKey: "state")
      defaults.set(zip, forKey: "zip")
      defaults.set(parkingInstructions, forKey: "parkingInstructions")
    case 4:
      print("step 2")
    default:
      break
    }
  }
}

extension BookingViewController {
  
  func createInfoPopup(root: UIView, item: UIView, witdh: Double, height: Double, text: String? = nil) -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: witdh, height: height))
    view.alpha = 0
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    view.applyBlackTransparentShadow()
    view.makeMeRounded()
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: witdh, height: height))
    label.textAlignment = .natural
    label.font = UIFont(name: "SanFranciscoText-Light", size: 15)
    label.text = text
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


extension BookingViewController {
  
  
  
}










//override func goUp() {
//  super.goUp()
//  
//  nextStep()
//}
//
//override func goDown() {
//  super.goDown()
//  
//  previousStep()
//}













