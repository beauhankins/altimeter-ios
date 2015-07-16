//
//  UserSettings.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

enum Unit: Int {
  case Feet
  case Meters
  
  func factor() -> Double {
    switch self {
    case .Feet:
      return 1.0
    case .Meters:
      return 3.2808399
    }
  }
  
  func abbreviation() -> String {
    switch self {
    case .Feet:
      return "ft"
    case .Meters:
      return "m"
    }
  }
}

class UserSettings {
  static let sharedSettings = UserSettings()
  
  var unit: Unit = .Feet
}