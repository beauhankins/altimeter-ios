//
//  UserSettings.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

let FEET_IN_MILES = 5280.0
let FEET_CUTOFF = 3281.0
let METERS_IN_KILOMETERS = 1000.0
let METERS_CUTOFF = METERS_IN_KILOMETERS

enum Unit: Int {
  case Imperial
  case Metric
  
  func convertDistance(distance: Double) -> Double {
    switch self {
    case .Imperial:
      return distance * 3.2808399
    case .Metric:
      return distance
    }
  }
  
  func distanceAbbreviation() -> String {
    switch self {
    case .Imperial:
      return "ft"
    case .Metric:
      return "m"
    }
  }
  
  func dynamicDistance(distance: Double) -> Double {
    let dist = convertDistance(distance)
    
    switch self {
    case .Imperial:
      if dist > FEET_CUTOFF {
        return dist / FEET_IN_MILES
      } else {
        return dist
      }
    case .Metric:
      if dist > METERS_CUTOFF {
        return dist / METERS_IN_KILOMETERS
      } else {
        return dist
      }
    }
  }
  
  func dynamicDistanceAbbreviation(distance: Double) -> String {
    let dist = convertDistance(distance)
    
    switch self {
    case .Imperial:
      if dist > FEET_CUTOFF {
        return "mi"
      } else {
        return "ft"
      }
    case .Metric:
      if dist > METERS_CUTOFF {
        return "km"
      } else {
        return "m"
      }
    }
  }
  
  func convertDegrees(degrees: Double) -> Double {
    switch self {
    case .Imperial:
      return degrees
    case .Metric:
      return (degrees - 32) / 1.8
    }
  }
  
  func degreesAbbreviation() -> String {
    switch self {
    case .Imperial:
      return "F"
    case .Metric:
      return "C"
    }
  }
  
  func description() -> String {
    switch self {
    case .Imperial:
      return "Feet, Fahrenheit"
    case .Metric:
      return "Meters, Celsius"
    }
  }
}

class UserSettings {
  static let sharedSettings = UserSettings()
  
  var unit: Unit = .Imperial
}