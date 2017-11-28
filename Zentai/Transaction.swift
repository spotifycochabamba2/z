//
//  Transaction.swift
//  zentai
//
//  Created by Wilson Balderrama on 12/7/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Foundation

struct Transaction {
  
  var id: String?
  var sessionId: String?
  
  var creditsUsed: Double?
  var priceSession: Double?
  var numberOfSessions: Int?
  var tip: Double?
  var parkingCost: Double?
  var total: Double?
  
}


extension Transaction {
  
  func toJSON() -> [String: Any] {
    var dict = [String: Any]()
    
    dict["creditsUsed"] = creditsUsed ?? 0
    dict["priceSession"] = priceSession ?? 0
    dict["tip"] = tip ?? 0
    dict["parkingCost"] = parkingCost ?? 0
    dict["total"] = total ?? 0
    
    return dict
  }
  
}
