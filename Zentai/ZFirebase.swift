//
//  ZFirebase.swift
//  Zentai
//
//  Created by Wilson Balderrama on 10/2/17.
//  Copyright © 2017 Zentai. All rights reserved.
//
import FirebaseDatabase

class ZFirebase {
  static var refDatabase: FIRDatabaseReference = {
    return FIRDatabase.database().reference()
  }()
}
