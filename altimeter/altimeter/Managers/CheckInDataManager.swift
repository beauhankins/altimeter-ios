//
//  CheckInDataManager.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

class CheckInDataManager {
  static let sharedManager = CheckInDataManager()
  
  var checkIn: CheckIn = CheckIn()
}