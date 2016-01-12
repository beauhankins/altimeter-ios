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
  func save(checkIn: CheckIn) {
    let savedCheckIns = allSavedCheckIns()

    let alreadyExists = $.chain(savedCheckIns).any({ $0.dateCreated == checkIn.dateCreated })
    if (!alreadyExists) {
      checkIn.saved = true
      checkIn.save()
    }
  }
  
  func allSavedCheckIns() -> [CheckIn] {
    let savedCheckIns = CheckIn.query(["saved": true]) as! [CheckIn]
    return savedCheckIns
  }
}