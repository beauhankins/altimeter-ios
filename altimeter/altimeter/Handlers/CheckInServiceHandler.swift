//
//  CheckInServiceHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import Social
import Photos

enum CheckInService : String {
  case Facebook
  case Twitter
}

let facebookAppId = "1159930637367243"

class CheckInServiceHandler {
  
  var checkIn: CheckIn
  
  var facebookAccount: ACAccount?
  var twitterAccount: ACAccount?
  
  init(checkIn: CheckIn) {
    self.checkIn = checkIn
  }
  
  func checkIn(services: [CheckInService], completion: (() -> Void)?, failure: ((service: CheckInService) -> Void)?) {
    for service in services {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        switch service {
        case .Facebook:
          self.checkInWithFacebook(completion: { () in
            dispatch_async(dispatch_get_main_queue()) { completion?() }
            }, failure: { () in
              dispatch_async(dispatch_get_main_queue()) { failure?(service: service) }
          })
        case .Twitter:
          self.checkInWithTwitter(completion: { () in
            dispatch_async(dispatch_get_main_queue()) { completion?() }
            }, failure: { () in
              dispatch_async(dispatch_get_main_queue()) { failure?(service: service) }
          })
        }
      }
    }
  }
  
  // MARK: - Accounts
  
  func requestPermissionsAndAccounts(service: CheckInService, completion: ((accounts: [ACAccount]) -> Void), failure: (() -> Void)?) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      switch service {
      case .Facebook:
        self.requestFacebookPermissionsAndAccounts({
          accounts in
          dispatch_async(dispatch_get_main_queue()) { completion(accounts: accounts) }
          }, failure: { () in
            dispatch_async(dispatch_get_main_queue()) { failure?() }
        })
      case .Twitter:
        self.requestTwitterPermissionsAndAccounts({
          accounts in
          dispatch_async(dispatch_get_main_queue()) { completion(accounts: accounts) }
          }, failure: { () in
            dispatch_async(dispatch_get_main_queue()) { failure?() }
        })
      }
    }
  }
  
  private func requestFacebookPermissionsAndAccounts(completion: ((accounts: [ACAccount]) -> Void), failure: (() -> Void)?) {
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
    let postingOptions: [NSObject: AnyObject] = [
      ACFacebookAppIdKey: facebookAppId,
      ACFacebookPermissionsKey: ["email"],
      ACFacebookAudienceKey: ACFacebookAudienceFriends]
    
    accountStore.requestAccessToAccountsWithType(accountType, options: postingOptions) {
      success, error -> Void in
      
      guard error == nil && success else { failure?(); return }
      
      let options: [NSObject: AnyObject] = [
        ACFacebookAppIdKey: facebookAppId,
        ACFacebookPermissionsKey: ["publish_actions"],
        ACFacebookAudienceKey: ACFacebookAudienceFriends]
      
      accountStore.requestAccessToAccountsWithType(accountType, options: options) {
        success, error -> Void in
        
        guard error == nil && success else { failure?(); return }
        
        let accounts = accountStore.accountsWithAccountType(accountType) as! [ACAccount]
        
        guard accounts.count > 0 else { failure?(); return }
        
        completion(accounts: accounts)
      }
    }
  }
  
  private func requestTwitterPermissionsAndAccounts(completion: ((accounts: [ACAccount]) -> Void), failure: (() -> Void)?) {
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
      success, error -> Void in
      
      guard error == nil && success else { failure?(); return }
      
      let accounts = accountStore.accountsWithAccountType(accountType) as! [ACAccount]
      
      guard accounts.count > 0 else { failure?(); return }
      
      completion(accounts: accounts)
    }
  }
  
  // MARK: - Facebook
  
  private func checkInWithFacebook(completion completion: (() -> Void)?, failure: (() -> Void)?) {
    guard let facebookAccount = facebookAccount else { failure?(); return }
    
    let requestURL = NSURL(string: "https://graph.facebook.com/me/feed")
    let mediaRequestURL = NSURL(string: "https://graph.facebook.com/me/photos")
    let altitude = Int(round(checkIn.location.altitude.doubleValue))
    let placeName = checkIn.place?.name
    let distanceUnit = UserSettings.sharedSettings.unit.distanceAbbreviation()
    let photoId = checkIn.photoId as? String
    
    var message = "Checking in at \(altitude)\(distanceUnit) via Altimeter #getaltimeter"
    if let placeName = placeName {
      message = "Checking in at \(placeName) (\(altitude)\(distanceUnit)) via Altimeter #getaltimeter"
    }
    
    let params = [
      "access_token": facebookAccount.credential?.oauthToken ?? "",
      "message": message
    ]
    let request = SLRequest(
      forServiceType: SLServiceTypeFacebook,
      requestMethod: SLRequestMethod.POST,
      URL: photoId != nil ? mediaRequestURL : requestURL,
      parameters: params)
    
    self.fetchPhotoData(photoId) {
      data in
      if let data = data {
        request.addMultipartData(
          data,
          withName: "source",
          type: "multipart/form-data",
          filename: "check-in_\(photoId).jpg")
      }
      
      request.performRequestWithHandler({
        responseData, urlResponse, error -> Void in
        
        print("Facebook HTTP response \(urlResponse.statusCode)")
        
        guard error == nil && urlResponse.statusCode == 200 else { failure?(); return }
        
        completion?()
      })
    }
  }
  
  // MARK: - Twitter
  
  private func checkInWithTwitter(completion completion: (() -> Void)?, failure: (() -> Void)?) {
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
    let mediaRequestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update_with_media.json")
    let altitude = Int(round(checkIn.location.altitude.doubleValue))
    let placeName = checkIn.place?.name
    let distanceUnit = UserSettings.sharedSettings.unit.distanceAbbreviation()
    let photoId = checkIn.photoId as? String
    
    var status = "Checking in at \(altitude)\(distanceUnit) via @GetAltimeter #getaltimeter"
    if let placeName = placeName {
      status = "Checking in at \(placeName) (\(altitude)\(distanceUnit)) via @GetAltimeter #getaltimeter"
    }
          
    let params = ["status": status]
    let request = SLRequest(
      forServiceType: SLServiceTypeTwitter,
      requestMethod: SLRequestMethod.POST,
      URL: photoId != nil ? mediaRequestURL : requestURL,
      parameters: params)
    request.account = twitterAccount
    
    self.fetchPhotoData(photoId) {
      data in
      
      if let data = data {
        request.addMultipartData(
          data,
          withName: "media[]",
          type: "multipart/form-data",
          filename: "check-in_\(photoId).jpg")
      }
      
      request.performRequestWithHandler {
        data, urlResponse, error -> Void in
        
        print("Twitter HTTP response \(urlResponse.statusCode)")
        
        guard error == nil && urlResponse.statusCode == 200 else { failure?(); return }
        
        completion?()
      }
    }
  }
  
  private func fetchPhotoData(localIdentifier: String?, completion: ((data: NSData?) -> Void)) {
    guard let localIdentifier = localIdentifier else { completion(data: nil); return }
    
    let results = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier as String], options: nil)
    var assets: [PHAsset] = []
    results.enumerateObjectsUsingBlock { (object, _, _) in
      if let asset = object as? PHAsset {
        assets.append(asset)
      }
    }
    
    if let asset = assets.first {
      let options = PHImageRequestOptions()
      options.deliveryMode = .FastFormat
      
      let imageManager = PHImageManager.defaultManager()
      imageManager.requestImageForAsset(asset,
        targetSize: PHImageManagerMaximumSize,
        contentMode: .AspectFit,
        options: options) {
          image, _ in
          if let image = image {
            let data = UIImageJPEGRepresentation(image, 1.0) ?? NSData()
            
            completion(data: data)
          }
      }
    }
  }
}