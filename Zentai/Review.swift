//
//  Review.swift
//  zentai
//
//  Created by Wilson Balderrama on 3/8/17.
//  Copyright © 2017 Zentai. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

struct Review {
  
  var id: String
  var reviewedId: String
  var reviewerId: String
  var reviewerName: String
  var sessionId: String
  var rate: Int
  var comments: String
  var creationDate: Date
  
  init?(json: [String: Any]?) {
    guard
      let json = json,
      let id = json["id"] as? String,
      let reviewedId = json["reviewedId"] as? String,
      let reviewerId = json["reviewerId"] as? String,
      let reviewerName = json["reviewerName"] as? String,
      let sessionId = json["sessionId"] as? String,
      let rate = json["rate"] as? Int,
      let comments = json["comments"] as? String,
      let utcCreationDate = json["creationDate"] as? Double
      else {
        return nil
    }
    
    self.id = id
    self.reviewedId = reviewedId
    self.reviewerId = reviewerId
    self.reviewerName = reviewerName
    self.sessionId = sessionId
    self.rate = rate
    self.comments = comments
    
    self.creationDate = Date(timeIntervalSince1970: utcCreationDate)
  }
}

extension Review {
  static var ref = ZFirebase.refDatabase
  
  static func sendPushForReview(
    clientId: String,
    practitionerId: String,
    sessionId: String,
    completion: @escaping (NSError?) -> Void
    ) -> Void {
    var params = [String: Any]()
    params["clientId"] = clientId
    params["practitionerId"] = practitionerId
    params["sessionId"] = sessionId
    
    let stringURL = Constants.Server.sendPushForReview
    
    Alamofire
      .request(
        stringURL,
        method: .post,
        parameters: params,
        encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          
          if json["error"].boolValue {
            let message = json["message"].stringValue
            let error = NSError(
              domain: "",
              code: 0,
              userInfo: [
                NSLocalizedDescriptionKey: message
              ]
            )
            
            completion(error)
          } else {
            completion(nil)
          }
        case .failure(let error):
          completion(error as NSError?)
        }
    }
  }
  
  static func hasReview(
    userId: String,
    sessionId: String,
    completion: @escaping (NSError?, Bool) -> Void
    ) {
    var params = [String: Any]()
    params["userId"] = userId
    params["sessionId"] = sessionId
    
    let stringURL = Constants.Server.hasReview
    
    print(stringURL)
    print(params)
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: params,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          
          if json["error"].boolValue {
            let message = json["message"].stringValue
            
            let error = NSError(
              domain: "Review",
              code:0,
              userInfo: [
                NSLocalizedDescriptionKey: message
              ]
            )
            
            completion(error, false)
          } else {
            let hasReview = json["hasReview"].boolValue
            completion(nil, hasReview)
          }
          
          break
        case .failure(let error):
          completion(error as NSError?, false)
          break
        }
    }
  }
  
  static func getTotalReviews(
    userId: String,
    completion: @escaping (NSError?, UInt) -> Void
    ) {
    
    var params = [String: Any]()
    params["userId"] = userId
    
    let stringURL = Constants.Server.getTotalReviewsURL
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: params,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          
          if json["error"].boolValue {
            let message = json["message"].stringValue
            
            let error = NSError(
              domain: "Review",
              code: 0,
              userInfo: [
                NSLocalizedDescriptionKey: message
              ])
            
            completion(error, 0)
          } else {
            let rate = json["rate"].intValue
            
            completion(nil, UInt(rate))
          }
          break
        case .failure(let error):
          completion(error as NSError?, 0)
          break
        }
    }
    
  }
  
  static func createReview(
    userReviewedId: String,
    userReviewerId: String,
    userReviewerName: String,
    sessionId: String,
    rate: Int,
    comments: String,
    completion: @escaping (NSError?) -> Void
    ) {
    
    var params = [String: Any]()
    params["userReviewedId"] = userReviewedId
    params["userReviewerId"] = userReviewerId
    params["userReviewerName"] = userReviewerName
    params["sessionId"] = sessionId
    params["rate"] = rate
    params["comments"] = comments
    
    let stringURL = Constants.Server.reviewsURL
    
    Alamofire.request(
      stringURL,
      method: .post,
      parameters: params,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let data):
          let json = JSON(data)
          
          if json["error"].boolValue {
            let message = json["message"].stringValue
            
            let error = NSError(
              domain: "Review",
              code: 0,
              userInfo: [
                NSLocalizedDescriptionKey: message
              ]
            )
            
            completion(error)
          } else {
            completion(nil)
          }
          
        case .failure(let error):
          completion(error as NSError?)
        }
    }
  }
  
}































