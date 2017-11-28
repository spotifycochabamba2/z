//
//  Constants.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/22/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  
  static let numberFormatter = { () -> NumberFormatter in
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    
    formatter.locale = Locale(identifier: "en_US")
    
    return formatter
  }()
  
  struct RemoteNotification {
    static let id = "ZentaiNotification"
    static let logout = "LogoutNotification"
  }
  
  
  // https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDjM0hdp7R3NDyBnaOGRDIlkK0IzY8wU8c&components=country:us&types=address&input=123
  
  // https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDjM0hdp7R3NDyBnaOGRDIlkK0IzY8wU8c&components=country:us&input=123
  struct Google {
    struct Maps {
      static let apiKey = "AIzaSyDBf33Mgd-tALvAk8vN0t-PQDvcygERQZY"
      
      static let latitudeUS = 37.09024
      static let longitudeUS = -95.7129
    }
    
    struct Places {
      private static let apiKey = "AIzaSyDjM0hdp7R3NDyBnaOGRDIlkK0IzY8wU8c"
      private static let autocompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(apiKey)"
      private static let detailsURL = "https://maps.googleapis.com/maps/api/place/details/json?key=\(apiKey)"
      
      static func getDetailsURL(placeId: String) -> String? {
        let url = "\(detailsURL)&placeid=\(placeId)"
        let encoded = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return encoded
      }
      
      static func getAutoCompleteURL(input: String) -> String? {
        let url = "\(autocompleteURL)&input=\(input)&components=country:us&types=address"
        let encoded = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return encoded
      }
    }
  }
  
  struct Server {
    //https://salty-gorge-57163.herokuapp.com
    //http://192.168.0.101:5000
    
    //    private static let stringURL = "http://192.168.0.101:5000"
    private static let stringURL = "https://us-central1-zentai-40971.cloudfunctions.net/app"
//    private static let stringURL = "http://localhost:5000/zentai-40971/us-central1/app"
//    http://localhost:5000/zentai-40971/us-central1/app
    
//  private static let stringHerokuURL = "https://salty-gorge-57163.herokuapp.com"
    private static let stringHerokuURL = "http://192.168.1.2:5000"
    
    //    send-push-for-review
    static let sendPushForReview = "\(stringURL)/send-push-for-review"
    
    
    static let captureCharge = "\(stringURL)/capture-charge"
    static let messagesURL = "\(stringURL)/messages"
    static let acceptInvitationURL = "\(stringURL)/accept-invitation"
    static let getInfoOfCancelSession = "\(stringURL)/get-info-cancel-session"
    static let getTimeNow = "\(stringURL)/time-now-utc-seconds"
    
    static let invitations = "\(stringURL)/api/invitations"
    static let sendMessageURL = "\(stringURL)/send-message"
    
    static let reviewsURL = "\(stringURL)/reviews"
    static let getTotalReviewsURL = "\(stringURL)/get-total-reviews"
    static let hasReview = "\(stringURL)/has-review"
    
    
    static let checkinSession = "\(stringHerokuURL)/checkin-session"
    static let cancelSession = "\(stringHerokuURL)/cancel-session"
    static let accountsURL = "\(stringHerokuURL)/accounts"
    static let chargeWithoutCaptureURL = "\(stringHerokuURL)/charge-without-capture"
  }
  
  struct Stripe {
    static let TestPublisableKey = "pk_test_duawjQA1UdYVbJM7GitdvkOr"
  }
  
  struct Session {
    static let WaitingPractitioner = "Waiting for Practitioner."
    static let AppointmentConfirmed = "Your appointment is now confirmed."
    static let AppointmentFinished = "Your appointment's been completed."
    static let AppointmentCancelled = "Your appointment's been cancelled."
    
    struct States {
      static let checkedIn = "checkedIn"
      static let cancelledByUser = "cancelledByUser"
      static let cancelledByPractitioner = "cancelledByPractitioner"
    }
  }
  
  struct Font {
    static let sfBoldFont = UIFont(name: "SanFranciscoText-Heavy", size: 15)
    static let sfLightFont = UIFont(name: "SanFranciscoText-Light", size: 15)
  }
  
  struct Texts {
    static let bookingAvailabilityHelpText = "Please select three of your best available times for us to ensure you get a therapist."
    
    static let bookingLocationHelpText = "Please let us know if there's additional information we should know such as where the best area to park is."
    
    static let bookingPetsHelpText = "We love pets but some of our therapists are allergic. Please let us know if you have one."
    static let bookingGenderHelpText = "Please let us know your preference for the therapist gender, either, Female, Male."
    static let bookingOilAllergiesHelpText = "Your health is important to us, please let us know if your therapist can use essential oils."
    static let reportBugPlaceholderText = "Description"
    static let parkingInstructionsText = "Ex. Go down the street three block, turn to left around the corner next to the bank."
    static let SendResetPassword = "An reset password link was sent to your Address Email."
    
    static let practitionerReviewDescription = "Please write a short description or short comment."
    
    static let waitingToBeConfirmed = "Waiting to be confirmed"
  }
  
  struct ErrorMessages {
    static let AddressEmpty = "Please fill address field to continue"
    static let RoomEmpty = "Please fill apt field to continue"
    static let CityEmpty = "Please fill city field to continue"
    static let StateEmpty = "Please fill state field to continue"
    static let ZipEmpty = "Please fill zip field to continue"
    static let ParkingInstructionsEmpty = "Please add parking instructions"
    
    static let FirstNameEmpty = "Please fill first name field to continue"
    static let LastNameEmpty = "Please fill last name field to continue"
    static let EmailEmpty = "Please fill email field to continue"
    static let EmailInvalid = "Please fill email field with a valid one"
    static let EmailAlreadyExist = "Please choose another email, it's already taken."
    static let PhoneEmpty = "Please fill phone field to continue"
    static let PasswordEmpty = "Please fill password field to continue"
    static let PasswordShort = "Please fill password field with at least 6 characters"
    static let PasswordRepeatNotEqual = "Repeat password field doesn't match with password field"
    
    static let CardNameEmpty = "Please fill card name field to continue"
    
    static let CardNumberEmpty = "Please fill card number field to continue"
    static let CardNumberInvalid = "Please fill card number field with a valid one"
    static let CardNumberIncomplete = "Card number field is incomplete"
    
    static let CCVEmpty = "Please fill CCV field to continue"
    static let CCVIncomplete = "CCV field is incomplete"
    static let CCVInvalid = "Please fill CCV field with a valid one"
    
    
    static let MMYYEmpty = "Please fill MM/YY field to continue"
    
    static let MonthIncomplete = "MM/YY field with month incomplete"
    static let MonthEmpty = "MM/YY field with month empty"
    static let MonthInvalid = "MM/YY field with month invalid"
    
    static let YearIncomplete = "MM/YY field with year incomplete"
    static let YearInvalid = "MM/YY field with year invalid"
    static let YearEmpty = "MM/YY field with year empty"
    
    static let CardNotSet = "Please enter your payment info"
  }
}




















