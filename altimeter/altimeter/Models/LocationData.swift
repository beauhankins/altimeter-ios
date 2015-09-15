//
//  LocationData.swift
//  altimeter
//
//  Created by Beau Hankins on 14/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation

class LocationData: NSObject, NSCoding {
  var altitude: Double = 0.0
  var altitudeAccuracy: Double = 0.0
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  var psi: Double = 0.0
  var temperature: Double = 0.0
  
  // MARK: - NSCoding
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
    self.altitude = aDecoder.decodeObjectForKey("altitude") as? Double ?? 0.0
    self.altitudeAccuracy = aDecoder.decodeObjectForKey("altitudeAccuracy") as? Double ?? 0.0
    self.latitude = aDecoder.decodeObjectForKey("latitude") as? Double ?? 0.0
    self.longitude = aDecoder.decodeObjectForKey("longitude") as? Double ?? 0.0
    self.psi = aDecoder.decodeObjectForKey("psi") as? Double ?? 0.0
    self.temperature = aDecoder.decodeObjectForKey("temperature") as? Double ?? 0.0
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.altitude, forKey: "altitude")
    aCoder.encodeObject(self.altitudeAccuracy, forKey: "altitudeAccuracy")
    aCoder.encodeObject(self.latitude, forKey: "latitude")
    aCoder.encodeObject(self.longitude, forKey: "longitude")
    aCoder.encodeObject(self.psi, forKey: "psi")
    aCoder.encodeObject(self.temperature, forKey: "temperature")
  }
}