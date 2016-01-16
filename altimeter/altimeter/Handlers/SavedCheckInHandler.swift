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
    let savedCheckIns = allSavedCheckIns()

    let alreadyExists = $.chain(savedCheckIns).any({ $0.dateCreated == checkIn.dateCreated })
    if (!alreadyExists) {
      checkIn.saved = true
      checkIn.save()
      
      guard let completion = completion else { return }
      completion()
    } else {
      guard let failure = failure else { return }
      failure()
    }
  }
  
  func allSavedCheckIns() -> [CheckIn] {
    let savedCheckIns = CheckIn.query(["saved": true]) as! [CheckIn]
    return savedCheckIns
  }
}