//
//  UserSettings.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

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