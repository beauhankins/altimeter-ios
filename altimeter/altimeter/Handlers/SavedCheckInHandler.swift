//
//  SavedCheckInHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 26/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import Dollar

class SavedCheckInHandler {
  func save(checkIn: CheckIn, completion: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
    let savedCheckIn = CheckIn.findOrCreate(["dateCreated": checkIn.dateCreated, "saved": true]) as! CheckIn
    
    if savedCheckIn.location.locationId == checkIn.location.locationId &&
       savedCheckIn.photoId == checkIn.photoId &&
       savedCheckIn.place?.placeId == checkIn.place?.placeId {
        guard let failure = failure else { return }
        failure()
    } else {
      savedCheckIn.location = checkIn.location
      savedCheckIn.photoId = checkIn.photoId
      savedCheckIn.place = checkIn.place
      savedCheckIn.save()
      
      guard let completion = completion else { return }
      completion()
    }
  }
  
  func allSavedCheckIns() -> [CheckIn] {
    let savedCheckIns = CheckIn.query(["saved": true], sort: ["dateCreated":"DESC"]) as! [CheckIn]
    return savedCheckIns
  }
}