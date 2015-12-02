//
//  SavedCheckInHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 26/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

class SavedCheckInHandler {
  func save(checkIn: CheckIn) {
    let alreadyExists = SavedCheckIn.MR_findByAttribute("timestamp", withValue: checkIn.timestamp).count > 0
    if (alreadyExists) { return; }
    
    let savedCheckIn = SavedCheckIn.MR_createEntity()
    savedCheckIn.timestamp = checkIn.timestamp
    savedCheckIn.image = checkIn.image
    savedCheckIn.locationData = NSKeyedArchiver.archivedDataWithRootObject(checkIn.locationData)
    savedCheckIn.locationName = checkIn.locationName
    
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
  }
  
  func allSavedCheckIns() -> [CheckIn] {
    let allCheckIns = NSMutableArray()
    
    let savedCheckIns = SavedCheckIn.MR_findAll()
    for savedCheckIn in savedCheckIns {
      let checkIn = CheckIn()
      if let locationData = savedCheckIn.locationData {
        checkIn.locationData = NSKeyedUnarchiver.unarchiveObjectWithData(locationData!) as! LocationData
      }
      checkIn.timestamp = savedCheckIn.timestamp
      checkIn.image = savedCheckIn.image
      checkIn.locationName = savedCheckIn.locationName
      
      allCheckIns.addObject(checkIn)
    }
    
    return allCheckIns as NSArray as! [CheckIn]
  }
}