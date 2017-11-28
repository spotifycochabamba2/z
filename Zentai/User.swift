//
//  User.swift
//  zentai
//
//  Created by Wilson Balderrama on 11/26/16.
//  Copyright © 2016 Zentai. All rights reserved.
//

import Foundation

import Firebase
import FirebaseStorage
import FirebaseCrash
import UserNotifications
import FBSDKLoginKit
import Ax
import SVProgressHUD
import Alamofire
import SwiftyJSON

struct User {
  var id: String?
  let firstName: String
  let lastName: String
  let email: String?
  var stripeId: String?
  var last4: String?
  let phone: String?
  var profileURL: String?
  var address: String?
  var isWorking: Bool?
  
  var aparment: String?
  var city: String?
  var state: String?
  var zip: String?
  
  var bio: String?
  var rating: Int = 0
  
  var isPushEnabled: Bool = false
  
  var latitude: Double = 0
  var longitude: Double = 0
}

extension User {
  init(id: String?, firstName: String, lastName: String, email: String?, phone: String?) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.profileURL = ""
  }
  
  init?(json: [String: Any]?) {
    guard
      let json = json,
      let id = json["id"] as? String,
      let firstName = json["firstName"] as? String,
      let lastName = json["lastName"] as? String,
      let email = json["email"] as? String,
      let phone = json["phone"] as? String
      else {
        return nil
    }
    
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.profileURL = json["profile-url"] as? String
    self.isWorking = json["isWorking"] as? Bool
    
    self.latitude = json["latitude"] as? Double ?? 0
    self.longitude = json["longitude"] as? Double ?? 0
  }
}

enum UserRole {
  case client
  case practitioner
}

extension User {
  
  static var last4Digits: String?
  static var stripeId: String?
  
  static var _current: User?
  
  static let ref = ZFirebase.refDatabase
  
  static var current: User? {
    get {
      return _current
    }
    
    set {
      _current = newValue
    }
  }
  
  static func getTimeNow(
    completion: @escaping (NSError?, Date?) -> Void
    ) {
    let stringURL = Constants.Server.getTimeNow
    
    Alamofire.request(
      stringURL,
      method: .get,
      encoding: JSONEncoding.default
      )
      .validate()
      .responseJSON { (response) in
        switch response.result {
          
        case .success(let data):
          let json = JSON(data)
          
          if let now = json["now"].double {
            let date = Date.init(timeIntervalSince1970: now)
            completion(nil, date)
          } else {
            let error = NSError.init(
              domain: "Time",
              code: 0,
              userInfo: [
                NSLocalizedDescriptionKey: "No actual time found."
              ])
            
            completion(error, nil)
          }
          break
        case .failure(let error):
          completion(error as NSError?, nil)
          break
          
        }
    }
  }
  
  
  static func getAddresses(input: String, completion: () -> Void) {
  }
  
  
  
  static func getRole(from userId: String, completion: @escaping (_ role: UserRole?) -> Void) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    refUser.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
      if snap.exists() {
        guard
          let json = snap.value as? [String: Any]
          else {
            completion(nil)
            return
        }
        
        if let role = json["role"] as? String {
          if role == "practitioner" {
            completion(UserRole.practitioner)
          } else {
            completion(UserRole.client)
          }
        } else {
          completion(UserRole.client)
        }
        
      } else {
        completion(nil)
      }
    }
  }
  
  static func sendResetPasswordTo(email: String, completion: @escaping (Error?) -> Void) {
    FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
      completion(error)
    })
  }
  
  static func reportBug(
    description: String,
    userId: String,
    completion: @escaping (Error?) -> Void
  ) {
    let refBugs = ref.child("bugs")
    let refBug = refBugs.childByAutoId()
    
    var values = [String: Any]()
    values["userId"] = userId
    values["description"] = description
    

    
    refBug.setValue(values, withCompletionBlock: {(error: Error?, ref: FIRDatabaseReference) in
      completion(error)
    })
  }
  
  
  static func update(
    userId: String,
    withRate rate: Int,
    withComments comments: String,
    completion: @escaping (Error?) -> Void
    )
  {
    
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    refUser.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
      
      if snapshot.exists()
      {
        if let child = snapshot.value as? [String: Any]
        {
          print(child)
          let oldRate = child["rating"] as? Int ?? 0
          
          refUser.updateChildValues([
            "rating": oldRate + rate
          ]) { (error, ref) in
            completion(error)
          }
        } else {
          completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User does not exist."]))
        }
      } else {
        completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User does not exist."]))
      }
      
    }
    
  }
  
  static func getReviews(
    fromUserId: String,
    completion: @escaping ([Review]) -> Void
    ) {
    
    let refReviews = ref.child("reviews")
    let refReviewUser = refReviews.child(fromUserId)
    
    refReviewUser.observeSingleEvent(of: .value) { (snap:FIRDataSnapshot) in
      var reviews = [Review]()
      
      if snap.exists() {
        if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
          reviews = dictionaries.flatMap {
            var reviewJSON = $0.value as? [String: Any]
            
            reviewJSON?["reviewedId"] = fromUserId
            return Review(json: reviewJSON)
          }
        }
      }
      
      completion(reviews)
    }
  }
  
  
  static func createReview(
    reviewerId: String,
    reviewerName: String,
    reviewedId: String,
    sessionId: String,
    rate: Int,
    comments: String,
    completion: @escaping (Error?) -> Void
    )
  {
    let refReviews = ref.child("reviews")
    let refReviewUser = refReviews.child(reviewedId)
    let refReview = refReviewUser.childByAutoId()
    
    var data = [String: Any]()
    
    data["id"] = refReview.key
    data["reviewerId"] = reviewerId
    data["reviewerName"] = reviewerName
    data["sessionId"] = sessionId
    data["rate"] = rate
    data["creationDate"] = [".sv": "timestamp"]
    data["comments"] = comments
    
    refReview.setValue(data) { (error, ref) in
      completion(error)
    }
  }
  
  
  static func update(
    userId: String,
    withPhone phone: String,
    AndAddress address: String,
    AndApartment aparment: String,
    AndCity city: String,
    AndState state: String,
    AndZip zip: String,
    AndLatitude latitude: Double = 0,
    AndLongitude longitude: Double = 0,
    completion: @escaping (Error?) -> Void
    ) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    refUser.updateChildValues([
      "address": address,
      "phone": phone,
      "apartment": aparment,
      "city": city,
      "state": state,
      "zip": zip,
      "latitude": latitude,
      "longitude": longitude
    ]) { (error, ref) in
      completion(error)
    }
  }
  
  static func updateUserWith(isWorking: Bool, userId: String) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    refUser.updateChildValues([
      "isWorking": isWorking
    ]) { (error, ref) in
      
    }
  }
  
  static func updateUserWith(isPushEnabled: Bool, userId: String) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    refUser.updateChildValues([
      "isPushEnabled": isPushEnabled
    ]) { (error, ref) in
      
    }
    
    //    var isEnabledByUser = false
    //    var result = false
    //
    //    Ax.serial(tasks: [
    //      { done in
    //        refUser.observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
    //          if snap.exists() {
    //            let user = snap.value as? [String: Any]
    //
    //            isEnabledByUser = user?["isPushEnabled"] as? Bool ?? false
    //          }
    //
    //          done(nil)
    //        })
    //      },
    //
    //      { done in
    //        if isPushEnabledByPhoneSettings && isEnabledByUser {
    //          result = true
    //        }
    //
    //        done(nil)
    //      }
    //    ]) { (error) in
    //      refUser.updateChildValues([
    //        "isPushEnabled": result
    //      ]) { (error, ref) in
    //
    //      }
    //    }
  }
  
  static func clearDeviceToken() {
    guard
      let token = FIRInstanceID.instanceID().token(),
      let userId = User.currentUserId
      else { return }
    
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    let refTokensUsed = ref.child("tokens-registered")
    let refToken = refTokensUsed
      .queryOrdered(byChild: "token")
      .queryEqual(toValue: token)
    var keyTokenFound: String?
    
    //    print(refToken.url)
    
    var userIdFound: String?
    
    Ax.serial(tasks: [
      //      { done in
      //        // get user if exist
      //        refToken.observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
      //          if snap.exists() {
      //            print(snap.key)
      //            print(snap.value)
      //
      //            let child = snap.children.allObjects.first as? FIRDataSnapshot
      //            keyTokenFound = child?.key
      //            let entry = child?.value as? [String: Any]
      //            userIdFound = entry?["userId"] as? String
      //
      //            print(userIdFound)
      //
      //            done(nil)
      //          } else {
      //            done(nil)
      //          }
      //        })
      //      },
      //      { done in
      //        // set device token to empty
      //        if let userIdFound = userIdFound {
      //          let refUserFound = refUsers.child(userIdFound)
      //          refUserFound.updateChildValues([
      //            "deviceToken": ""
      //            ])
      //          done(nil)
      //        } else {
      //          done(nil)
      //        }
      //      },
      //      { done in
      //        // register device token on list
      //
      //        if let keyTokenFound = keyTokenFound {
      //          print(refTokensUsed.child(keyTokenFound).url)
      //          refTokensUsed.child(keyTokenFound).updateChildValues([
      //            "userId": userId
      //            ])
      //        } else {
      //          refTokensUsed.childByAutoId().setValue([
      //            "userId": userId,
      //            "token": token
      //            ])
      //        }
      //
      //        done(nil)
      //      },
      { done in
        // register device token to user id
        
        refUser.updateChildValues([
          "deviceToken": ""
          ])
        
        done(nil)
      }
    ]) { (error) in
      
    }
  }
  
  static func updateUserDeviceToken() {
    //    print("token: \(token), userId: \(userId)")
    
    guard
      let token = FIRInstanceID.instanceID().token(),
      let userId = User.currentUserId
      else { return }
    
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    let refTokensUsed = ref.child("tokens-registered")
    let refToken = refTokensUsed
      .queryOrdered(byChild: "token")
      .queryEqual(toValue: token)
    var keyTokenFound: String?
    
    //    print(refToken.url)
    
    var userIdFound: String?
    
    Ax.serial(tasks: [
      { done in
        // get user if exist
        refToken.observeSingleEvent(of: .value, with: { (snap: FIRDataSnapshot) in
          if snap.exists() {
            print(snap.key)
            print(snap.value)
            
            let child = snap.children.allObjects.first as? FIRDataSnapshot
            keyTokenFound = child?.key
            let entry = child?.value as? [String: Any]
            userIdFound = entry?["userId"] as? String
            
            print(userIdFound)
            
            done(nil)
          } else {
            done(nil)
          }
        })
      },
      { done in
        // set device token to empty
        if let userIdFound = userIdFound {
          let refUserFound = refUsers.child(userIdFound)
          refUserFound.updateChildValues([
            "deviceToken": ""
            ])
          done(nil)
        } else {
          done(nil)
        }
      },
      { done in
        // register device token on list
        
        if let keyTokenFound = keyTokenFound {
          print(refTokensUsed.child(keyTokenFound).url)
          refTokensUsed.child(keyTokenFound).updateChildValues([
            "userId": userId
            ])
        } else {
          refTokensUsed.childByAutoId().setValue([
            "userId": userId,
            "token": token
            ])
        }
        
        done(nil)
      },
      { done in
        // register device token to user id
        
        refUser.updateChildValues([
          "deviceToken": token
          ])
        
        done(nil)
      }
    ]) { (error) in
      
    }
  }
  
  static var currentFIRUser: FIRUser? {
    return FIRAuth.auth()?.currentUser
  }
  
  static func uploadPicture(userId: String?, picture: UIImage?) {
    
    guard
      let userId = userId,
      var picture = picture
      else { return }
    
    let refStorage = FIRStorage.storage().reference()
    let refStorageUsers = refStorage.child("users")
    let refStorageUser = refStorageUsers.child("\(userId).jpg")
    
    //    let refDB = FIRDatabase.database().reference()
    let refDBUsers = ref.child("users")
    let refDBUser = refDBUsers.child(userId)
    
    print(picture.size)
    if let resizePic = Utils.resize(image: picture, with: 256) {
      picture = resizePic
    }
    print(picture.size)
    
    let data = UIImageJPEGRepresentation(picture, 1.0)
    
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpg"
    
    if let data = data {
      
      var downloadURL: String?
      
      Ax.serial(tasks: [
        { done in
          _ = refStorageUser.put(data, metadata: metaData) { (metaData, error) in
            if let error = error {
              done(error as NSError?)
            } else {
              downloadURL = metaData?.downloadURL()?.absoluteString
              done(nil)
            }
          }
        },
        { done in
          refDBUser.updateChildValues([
            "profile-url": downloadURL ?? ""
            ])
          
          done(nil)
        }
        ], result: { (error) in
          
      })
    }
  }
  
  static func removeHandler(id: UInt, userId: String) {
    FIRDatabase
      .database()
      .reference()
      .child("users")
      .child(userId)
      .removeObserver(withHandle: id)
  }
  
  static func getAll(completion: @escaping ([User]) -> Void) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    
    refUsers.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
      var users = [User]()
      
      if snap.exists() {
        if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
          users = dictionaries.flatMap {
            return User(json: $0.value as? [String: Any])
          }
        }
      }
      
      completion(users)
    }
  }
  
  //  static func updateDeviceToken() {
  //    if let refreshedToken = FIRInstanceID.instanceID().token() {
  //      if let userId = User.currentUserId {
  //        User.updateUserWith(token: refreshedToken, userId: userId)
  //      }
  //    }
  //  }
  
  static var currentUserId: String? {
    return FIRAuth.auth()?.currentUser?.uid
  }
  
  static var isUserLoggedIn: Bool {
    return FIRAuth.auth()?.currentUser != nil
  }
  
  static func getUser(by: String, once: Bool, completion: @escaping(User?) -> Void) -> UInt {
    var handlerId: UInt = 0
    
    let userId = by
    //      let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    handlerId = refUser.observe(.value) { (snap: FIRDataSnapshot) in
      if snap.exists() {
        if let json = snap.value as? [String: Any] {
          let customerId = json["customerId"] as? String
          let email = json["email"] as? String
          let firstName = json["firstName"] as? String
          let last4 = json["last4"] as? String
          let lastName = json["lastName"] as? String
          let phone = json["phone"] as? String
          let profileURL = json["profile-url"] as? String
          let isPushEnabled = json["isPushEnabled"] as? Bool
          let address = json["address"] as? String
          
          var user = User(id: userId, firstName: firstName ?? "", lastName: lastName ?? "", email: email, phone: phone)
          user.last4 = last4
          user.stripeId = customerId
          user.profileURL = profileURL
          user.isPushEnabled = isPushEnabled ?? true
          user.isWorking = json["isWorking"] as? Bool
          user.bio = json["bio"] as? String
          user.rating = json["rating"] as? Int ?? 0
          user.address = address
          user.aparment = json["apartment"] as? String
          user.city = json["city"] as? String
          user.state = json["state"] as? String
          user.zip = json["zip"] as? String
          
          user.latitude = json["latitude"] as? Double ?? 0
          user.longitude = json["longitude"] as? Double ?? 0
          
          completion(user)
        }
      } else {
        completion(nil)
      }
      
      if once {
        refUser.removeObserver(withHandle: handlerId)
      }
    }
    
    return handlerId
  }
  
  static func getCurrentUser(once: Bool, navigationController: UINavigationController? = nil, completion: @escaping(User?) -> Void) -> UInt {
    var handlerId: UInt = 0
    
    if let currentUser = FIRAuth.auth()?.currentUser {
      handlerId = getUser(by: currentUser.uid, once: once, completion: completion)
    } else {
      logout()
      _ = navigationController?.popToRootViewController(animated: true)
      completion(nil)
    }
    
    return handlerId
  }
  
  
  //  static func getCurrentUser(once: Bool, navigationController: UINavigationController? = nil, completion: @escaping(User?) -> Void) -> UInt {
  //    var handlerId: UInt = 0
  //
  //    if let currentUser = FIRAuth.auth()?.currentUser {
  //
  //      let userId = currentUser.uid
  //      let ref = FIRDatabase.database().reference()
  //      let refUsers = ref.child("users")
  //      let refUser = refUsers.child(userId)
  //
  //      handlerId = refUser.observe(.value) { (snap: FIRDataSnapshot) in
  //        if snap.exists() {
  //          if let json = snap.value as? [String: Any] {
  //            let customerId = json["customerId"] as? String
  //            let email = json["email"] as? String
  //            let firstName = json["firstName"] as? String
  //            let last4 = json["last4"] as? String
  //            let lastName = json["lastName"] as? String
  //            let phone = json["phone"] as? String
  //            let profileURL = json["profile-url"] as? String
  //            let isPushEnabled = json["isPushEnabled"] as? Bool
  //            let address = json["address"] as? String
  //
  //            var user = User(id: userId, firstName: firstName ?? "", lastName: lastName ?? "", email: email, phone: phone)
  //            user.last4 = last4
  //            user.stripeId = customerId
  //            user.profileURL = profileURL
  //            user.isPushEnabled = isPushEnabled ?? false
  //            user.address = address
  //
  //            completion(user)
  //          }
  //        } else {
  //          completion(nil)
  //        }
  //
  //        if once {
  //          refUser.removeObserver(withHandle: handlerId)
  //        }
  //      }
  //
  //    } else {
  //      logout()
  //      _ = navigationController?.popToRootViewController(animated: true)
  //      completion(nil)
  //    }
  //
  //    return handlerId
  //  }
  
  //  // Deprecated, use getCurrentUser instead.
  //  static func get(id: String, completion: @escaping (User?) -> Void) -> UInt {
  //    let ref = FIRDatabase.database().reference()
  //    let refUsers = ref.child("users")
  //    let refUser = refUsers.child(id)
  //
  //    print(refUser)
  //
  //    let handler = refUser.observe(.value) { (snap: FIRDataSnapshot) in
  //      if snap.exists() {
  //        if let json = snap.value as? [String: Any] {
  //          let customerId = json["customerId"] as? String
  //          let email = json["email"] as? String
  //          let firstName = json["firstName"] as? String
  //          let last4 = json["last4"] as? String
  //          let lastName = json["lastName"] as? String
  //          let phone = json["phone"] as? String
  //          let profileURL = json["profile-url"] as? String
  //          let isPushEnabled = json["isPushEnabled"] as? Bool
  //          let address = json["address"] as? String
  //
  //          var user = User(id: id, firstName: firstName ?? "", lastName: lastName ?? "", email: email, phone: phone)
  //          user.last4 = last4
  //          user.stripeId = customerId
  //          user.profileURL = profileURL
  //          user.isPushEnabled = isPushEnabled ?? false
  //          user.address = address
  //
  //          completion(user)
  //        }
  //      } else {
  //        completion(nil)
  //      }
  //    }
  //
  //    return handler
  //  }
  
  static func exist(email: String, completion: @escaping (Bool) -> Void) -> Void {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    
    refUsers.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
      if snap.exists() {
        let result = snap.children.contains(where: { (child) -> Bool in
          if let child = child as? FIRDataSnapshot {
            if let dict = child.value as? [String: Any] {
              let e = dict["email"] as? String
              
              return email == e
            }
          }
          
          return false
        })
        
        completion(result)
      } else {
        completion(false)
      }
    }
  }
  
  static func connectToFacebook(viewController: UIViewController, completion: @escaping (NSError?, Bool, Bool) -> Void) {
    FIRCrashMessage("1:Connecting to Facebook")
    
    var credential: FIRAuthCredential?
    var firUser: FIRUserInfo?
    var isNew = false
    var isCancelled = false
    
    Ax.serial(tasks: [
      
      // getting facebook's token
      { done in
        FIRCrashMessage("2:Getting facebook's token")
        FBSDKLoginManager()
          .logIn(withReadPermissions: ["email"], from: nil) { (result, error) in
            
            isCancelled = result?.isCancelled ?? false
            
            if isCancelled {
              done(NSError())
              return
            }
            
            if error == nil {
              credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            }
            
            done(error as? NSError)
        }
      },
      
      // setting facebook's token on firebase to retrieve a user
      { done in
        FIRCrashMessage("3:setting facebook's token on firebase to retrieve a user")
        Spinner.show(currentViewController: viewController)
        //        SVProgressHUD.show()
        
        FIRAuth.auth()?.signIn(with: credential!) { (userFound, error) in
          firUser = userFound
          done(error as? NSError)
        }
      },
      
      // verifying user is already saved
      { done in
        FIRCrashMessage("4:verifying user is already saved")
        if let email = firUser?.email {
          User.exist(email: email, completion: { (exist) in
            isNew = !exist
            done(nil)
          })
        } else {
          done(nil)
        }
      },
      
      // actually saving the user if he is not.
      { done in
        FIRCrashMessage("5:actually saving the user if he is not.")
        if isNew {
          
          print(firUser!.uid)
          print(firUser?.providerID)
          
          var user = User(id: firUser!.uid, firstName: firUser!.displayName ?? "", lastName: "", email: firUser!.email, phone: "")
          user.profileURL = firUser?.photoURL?.absoluteString
          
          User.save(user: user) { error in
            done(error)
          }
        } else {
          if let profileURL = firUser?.photoURL?.absoluteString {
            User.update(userId: firUser!.uid, profileURL: profileURL)
          }
          done(nil)
        }
        
      }
    ]) { (error) in
      Spinner.dismiss()
      if isCancelled {
        completion(nil, isNew, isCancelled)
      } else {
        if error != nil {
          FIRCrashMessage("6:isCancelled: \(isCancelled)")
          FIRCrashMessage("6:isNew: \(isNew)")
          FIRCrashMessage("6:Error: \(error?.localizedDescription)")
        } else {
          User.updatePushNotificationField()
        }
        
        completion(error, isNew, isCancelled)
      }
      
    }
  }
  
  static func logout() {
    do {
      
      User.clearDeviceToken()
      
      try FIRAuth.auth()?.signOut()
      
      FBSDKLoginManager().logOut()
    } catch {
      print(error)
    }
  }
  
  static func updatePushNotificationField() {
    var isPushEnabledByUser = true
    
    if let currentUserId = User.currentUserId {
      
      Ax.serial(tasks: [
        
        { done in
          _ = User.getUser(by: currentUserId, once: true, completion: { (user) in
            isPushEnabledByUser = user?.isPushEnabled ?? true
            
            done(nil)
          })
        },
        
        { done in
          User.isPushNotificationsEnabled(completion: { (isEnabled) in
            User.updateUserWith(isPushEnabled: isEnabled && isPushEnabledByUser, userId: currentUserId)
            User.updateUserDeviceToken()
            done(nil)
          })
        }
        
        ], result: { (error) in
          
      })
      
    }
  }
  
  static func signup(user: User, password: String, completion: @escaping (NSError?, User) -> Void) {
    let completion: FIRAuthResultCallback = { firUser, error in
      var user = user
      user.id = firUser?.uid
      completion(error as NSError?, user)
    }
    
    FIRAuth
      .auth()?
      .createUser(
        withEmail: user.email!,
        password: password,
        completion: completion
    )
  }
  
  static func update(userId: String, profileURL: String) {
    //    let ref = FIRDatabase.database().reference()
    let refUsers = ref.child("users")
    let refUser = refUsers.child(userId)
    
    print(refUser)
    
    refUser.updateChildValues([
      "profile-url": profileURL
      ])
  }
  
  static func isPushNotificationsEnabled(completion: @escaping (Bool) -> Void) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
        completion(settings.authorizationStatus == .authorized)
      })
    } else {
      completion(UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false)
    }
  }
  
  static func save(user: User, completion: @escaping (NSError?) -> Void) {
    let refUsers = ref.child("users")
    
    if user.id == nil {
      completion(NSError(domain: "AuthDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "user id was not provided."]))
      return
    }
    
    let refUser = refUsers.child(user.id!)
    print(user.profileURL)
    
    var data = [String: Any]()
    
    data["id"] = user.id!
    data["firstName"] = user.firstName
    data["lastName"] = user.lastName
    data["email"] = user.email ?? ""
    data["phone"] = user.phone ?? ""
    data["profile-url"] = user.profileURL ?? ""
    data["isPushEnabled"] = true
    
    refUser.setValue(data) { (error, ref) in
      completion(error as? NSError)
    }
  }
  
  static func getFavorites(byUserId userId: String, completion: @escaping ([[String: Any]]) -> Void) {
    
    let refFavoriteUsers = ref.child("favorites-by-user").child(userId)
    
    refFavoriteUsers.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
      var favorites = [[String: Any]]()
      
      if let dictionaries = snap.children.allObjects as? [FIRDataSnapshot] {
        print(dictionaries)
        favorites = dictionaries.flatMap {
          print($0.value)
          print($0)
          return $0.value as? [String: Any]
        }
      }
      
      print(favorites)
      completion(favorites)
    }
    
  }
  
  static func addFavorites(to userAdded: [String: Any], for userOwnerId: String, completion: @escaping (NSError?) -> Void) {
    guard let userIdAdded = userAdded["id"] as? String else {
      completion(NSError(domain: "Favorites", code: 400, userInfo: [NSLocalizedDescriptionKey: "user id was not provided."]))
      return
    }
    
    guard let userNameAdded = userAdded["username"] as? String else {
      completion(NSError(domain: "Favorites", code: 400, userInfo: [NSLocalizedDescriptionKey: "user name was not provided."]))
      return
    }
    
    let refFavoriteUsers = ref.child("favorites-by-user").child(userOwnerId).child(userIdAdded)
    
    var values = [String: Any]()
    values["id"] = userIdAdded
    values["username"] = userNameAdded
    values["profileURL"] = userAdded["profileURL"] as? String
    
    refFavoriteUsers.updateChildValues(values, withCompletionBlock: {
      (error: Error?, _) in
      
      completion(error as NSError?)
    })
  }
  
  static func signin(email: String, password: String, completion: @escaping (NSError?) -> Void) {
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
      completion(error as? NSError)
    })
  }
  
}





































