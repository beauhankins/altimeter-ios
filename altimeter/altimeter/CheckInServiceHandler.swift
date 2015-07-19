//
//  CheckInServiceHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

enum CheckInService : Int {
  case Facebook
  case Twitter
}

class CheckInServiceHandler {
  func checkIn(locationData: LocationData, services: CheckInService...) {
    for service in services {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        switch (service) {
        case .Facebook:
          self.checkInWithFacebook(locationData)
        case .Twitter:
          self.checkInWithTwitter(locationData)
        }
      }
    }
  }
  
  // MARK: - Facebook
  
  func checkInWithFacebook(locationData: LocationData) {
    if (FBSDKAccessToken.currentAccessToken() != nil) {
//      if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") {
        self.postToFacebook(locationData)
//      } else {
//        print("No publish permissions")
//      }
    } else {
      let login = FBSDKLoginManager()
      login.logInWithPublishPermissions(["publish_actions"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
        if (error != nil) {
          // Process error
          print(error.localizedDescription)
        } else if result.isCancelled {
          // Handle cancellations
        } else {
          self.checkInWithFacebook(locationData)
        }
      })
    }
  }
  
  func postToFacebook(locationData: LocationData) {
    let altitudeString = String(format: "%.0f", round(locationData.altitude))
    FBSDKGraphRequest(
      graphPath: "me/feed",
      parameters: [ "message" : "Just checking in at \(altitudeString)\(UserSettings.sharedSettings.unit.distanceAbbreviation()) above sea level." ],
      HTTPMethod: "POST").startWithCompletionHandler({
        (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
        if (error != nil) {
          print(error.localizedDescription)
        } else {
          print("Succesfully Checked-In to Facebook: \(result)")
        }
    })
  }
  
  // MARK: - Twitter
  
  func checkInWithTwitter(locationData: LocationData) {
    
  }
}