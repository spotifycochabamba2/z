//
//  Utils.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/22/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct Utils {
  
  static func getAppleMapURL(
    startLocation: (latitude: Double, longitude: Double),
    endLocation: (latitude: Double, longitude: Double)
    ) -> String {
    return "http://maps.apple.com/maps?saddr=\(startLocation.latitude),\(startLocation.longitude)&daddr=\(endLocation.latitude),\(endLocation.longitude)&dirflg=d"
  }
  
  static func getGoogleMapURL(
    startLocation: (latitude: Double, longitude: Double),
    endLocation: (latitude: Double, longitude: Double)
    ) -> String {
    return "http://maps.google.com/?daddr=\(startLocation.latitude),\(startLocation.longitude)&saddr=\(endLocation.latitude),\(endLocation.longitude)&directionsmode=driving"
  }
  
  static func getAddress(fromPlace place: (String, String, String), completion: @escaping (AddressInfo?) -> Void) {
    let serviceURL = Constants.Google.Places.getDetailsURL(placeId: place.2)
    
    if let url = serviceURL {
      Alamofire.request(
        url,
        method: .get,
        encoding: JSONEncoding.default
        )
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            var addressInfo = AddressInfo()
            
            let json = JSON(data)
            
            if let location = json["result"]["geometry"]["location"].dictionary {
              let lat = location["lat"]?.double
              let lng = location["lng"]?.double
              
              addressInfo.latitude = lat
              addressInfo.longitude = lng
            }
            
            if let components = json["result"]["address_components"].array {
              
              var streetNumber: String?
              var route: String?
              var city: String?
              var state: String?
              var zip: String?
              
              components.forEach {
                if let types = $0["types"].array {
                  if types.contains("street_number") {
                    streetNumber = $0["long_name"].string
                  }
                  
                  if types.contains("route") {
                    route = $0["long_name"].string
                  }
                  
                  if types.contains("locality") {
                    city = $0["long_name"].string
                  }
                  
                  if types.contains("administrative_area_level_1") {
                    state = $0["short_name"].string
                  }
                  
                  if types.contains("postal_code") {
                    zip = $0["short_name"].string
                  }
                }
              }
              
              var address = ""
              if let streetNumber = streetNumber {
                address += "\(streetNumber) "
              }
              
              address += route ?? ""
              
              addressInfo.address = address
              addressInfo.city = city
              addressInfo.state = state
              addressInfo.zip = zip
            }
            
            completion(addressInfo)
            break
          case .failure(let error):
            completion(nil)
            break
          }
      }
    } else {
      completion(nil)
    }
  }
  
  static func searchPlaces(input: String, completion: @escaping ([(String, String, String)]) -> Void) {
    let serviceURL = Constants.Google.Places.getAutoCompleteURL(input: input)
    print(serviceURL)
    
    var places = [(String, String, String)]()
    
    if let url = serviceURL {
      Alamofire.request(
        url,
        method: .get,
        encoding: JSONEncoding.default
        )
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            
            print(json)
            
            if let array = json["predictions"].array {
              array.forEach {
                print($0)
                if
                  let placeId = $0["place_id"].string,
                  let mainText = $0["structured_formatting"]["main_text"].string,
                  let secondaryText = $0["structured_formatting"]["secondary_text"].string
                {
                  print("placeId: \(placeId)")
                  print("mainText: \(mainText)")
                  print("secondaryText: \(secondaryText)")
                  
                  places.append((mainText, secondaryText, placeId))
                }
              }
            } else {
              completion(places)
            }
            
            completion(places)
            print(json)
            break
          case .failure(let error):
            completion(places)
            break
          }
      }
    } else {
      completion(places)
    }
  }
  
  static func resize(image: UIImage, with width: CGFloat) -> UIImage? {
    let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))))
    imageView.contentMode = .scaleAspectFit
    imageView.image = image
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, image.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    imageView.layer.render(in: context)
    guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    UIGraphicsEndImageContext()
    return result
  }
  
  static func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  static func getCompleteDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, MMM d, yyyy"
    
    return formatter.string(from: date)
  }
  
  static func getCompleteDate2(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d yyyy"
    
    return formatter.string(from: date)
  }
  
  static func getDayNumber(date: Date) -> Int? {
    return Calendar.current.dateComponents([.day], from: date).day
  }
  
  static func getMonth(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM"
    
    return formatter.string(from: date).uppercased()
  }
  
  static func getDayOfWeek(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EE"
    
    return formatter.string(from: date).uppercased()
  }
  
  static func format(time: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    
    return formatter.string(from: time)
  }
  
  static func format(amount: Double) -> String? {
    let numberFormatter = NumberFormatter()
    
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = "USD"
    
    return numberFormatter.string(from: amount as NSNumber)
  }
  
  static func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EE d MMM"
    
    return formatter.string(from: date)
  }
  
  static func getStates() -> [(String, String)] {
    return [
      ("AL", "Alabama"),
      ("AK", "Alaska"),
      ("AZ", "Arizona"),
      ("AR", "Arkansas"),
      ("CA", "California"),
      ("CO", "Colorado"),
      ("CT", "Connecticut"),
      ("DE", "Delaware"),
      ("FL", "Florida"),
      ("GA", "Georgia"),
      ("HI", "Hawaii"),
      ("ID", "Idaho"),
      ("IL", "Illinois"),
      ("IN", "Indiana"),
      ("IA", "Iowa"),
      ("KS", "Kansas"),
      ("KY", "Kentucky"),
      ("LA", "Louisiana"),
      ("ME", "Maine"),
      ("MD", "Maryland"),
      ("MA", "Massachusetts"),
      ("MI", "Michigan"),
      ("MN", "Minnesota"),
      ("MS", "Mississippi"),
      ("MO", "Missouri"),
      ("MT", "Montana"),
      ("NE", "Nebraska"),
      ("NV", "Nevada"),
      ("NH", "New Hampshire"),
      ("NJ", "New Jersey"),
      ("NM", "New Mexico"),
      ("NY", "New York"),
      ("NC", "North Carolina"),
      ("ND", "North Dakota"),
      ("OH", "Ohio"),
      ("OK", "Oklahoma"),
      ("OR", "Oregon"),
      ("PA", "Pennsylvania"),
      ("RI", "Rhode Island"),
      ("SC", "South Carolina"),
      ("SD", "South Dakota"),
      ("TN", "Tennessee"),
      ("TX", "Texas"),
      ("UT", "Utah"),
      ("VT", "Vermont"),
      ("VA", "Virginia"),
      ("WA", "Washington"),
      ("WV", "West Virginia"),
      ("WI", "Wisconsin"),
      ("WY", "Wyoming"),
    ]
  }
  
}

public extension UIDevice {
  
  static var iPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
  }
  
  enum ScreenType: String {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case Unknown
  }
  
  static var screenType: ScreenType {
    guard iPhone else { return .Unknown}
    switch UIScreen.main.nativeBounds.height {
    case 960:
      return .iPhone4
    case 1136:
      return .iPhone5
    case 1334:
      return .iPhone6
    case 2208:
      return .iPhone6Plus
    default:
      return .Unknown
    }
  }
  
}










