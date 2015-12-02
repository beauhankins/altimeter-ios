//
//  CheckInServiceHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import Social

enum CheckInService : Int {
  case Facebook
  case Twitter
}

class CheckInServiceHandler {
  func checkIn(checkIn: CheckIn, services: CheckInService..., success: (() -> Void)?, failure: (() -> Void)?) {
    for service in services {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        switch (service) {
        case .Facebook:
          self.checkInWithFacebook(checkIn, completion: success, failure: failure)
        case .Twitter:
          self.checkInWithTwitter(checkIn, completion: success, failure: failure)
        }
      }
    }
  }
  
  // MARK: - Facebook
  
  func checkInWithFacebook(checkIn: CheckIn, completion: (() -> Void)?, failure: (() -> Void)?) {
    let requestURL = NSURL(string: "https://graph.facebook.com/me/feed")
    let altitude = checkIn.locationData.altitude
    let locationName = checkIn.locationName
    let distanceUnit = UserSettings.sharedSettings.unit.distanceAbbreviation()
    
    var message = "Checking in at \(altitude)\(distanceUnit) via Altimeter #getaltimeter"
    if let locationName = locationName {
      message = "Checking in at \(locationName) (\(altitude)\(distanceUnit)) via Altimeter #getaltimeter"
    }
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
    let postingOptions: [NSObject: AnyObject] = [
      ACFacebookAppIdKey: "1159930637367243",
      ACFacebookPermissionsKey: ["email"],
      ACFacebookAudienceKey: ACFacebookAudienceFriends]
    
    accountStore.requestAccessToAccountsWithType(accountType, options: postingOptions) {
      success, error -> Void in
      if success {
        let options: [NSObject: AnyObject] = [
          ACFacebookAppIdKey: "1159930637367243",
          ACFacebookPermissionsKey: ["publish_actions"],
          ACFacebookAudienceKey: ACFacebookAudienceFriends]
        
        accountStore.requestAccessToAccountsWithType(accountType, options: options) {
          success, error -> Void in
          
          let accounts = accountStore.accountsWithAccountType(accountType)
          if accounts.count > 0 {
            let account = accounts.first as! ACAccount
            
            let params = [
              "access_token": account.credential.oauthToken,
              "message": message
            ]
            let request = SLRequest(
              forServiceType: SLServiceTypeFacebook,
              requestMethod: SLRequestMethod.POST,
              URL: requestURL,
              parameters: params)
            
            request.performRequestWithHandler({
              responseData, urlResponse, error -> Void in
              
              if let error = error {
                print("Error : \(error.localizedDescription)")
              } else {
                dispatch_async(dispatch_get_main_queue()) {
                  if let completion = completion { completion() }
                }
              }
              
              print("Facebook HTTP response \(urlResponse.statusCode)")
            })
          } else {
            dispatch_async(dispatch_get_main_queue()) {
              if let failure = failure { failure() }
            }
          }
        }
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          if let failure = failure { failure() }
        }
      }
    }
  }
  
  // MARK: - Twitter
  
  func checkInWithTwitter(checkIn: CheckIn, completion: (() -> Void)?, failure: (() -> Void)?) {
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
    let altitude = checkIn.locationData.altitude
    let locationName = checkIn.locationName
    let distanceUnit = UserSettings.sharedSettings.unit.distanceAbbreviation()
    
    var status = "Checking in at \(altitude)\(distanceUnit) via @GetAltimeter #getaltimeter"
    if let locationName = locationName {
      status = "Checking in at \(locationName) (\(altitude)\(distanceUnit)) via @GetAltimeter #getaltimeter"
    }
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
      success, error -> Void in
      if success {
        let accounts = accountStore.accountsWithAccountType(accountType)
        if accounts.count > 0 {
          let account = accounts.last as! ACAccount
          
          let params = ["status": status]
          let request = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: SLRequestMethod.POST,
            URL: requestURL,
            parameters: params)
          
          request.account = account
          
          request.performRequestWithHandler {
            data, urlResponse, error -> Void in
            
            if let error = error {
              print("Error : \(error.localizedDescription)")
            } else {
              dispatch_async(dispatch_get_main_queue()) {
                if let completion = completion { completion() }
              }
            }
            
            print("Twitter HTTP response \(urlResponse.statusCode)")
          }
        } else {
          dispatch_async(dispatch_get_main_queue()) {
            if let failure = failure { failure() }
          }
        }
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          if let failure = failure { failure() }
        }
      }
    }
  }
}