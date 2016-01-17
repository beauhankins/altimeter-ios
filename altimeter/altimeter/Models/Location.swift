//
//  LocationData.swift
//  altimeter
//
//  Created by Beau Hankins on 14/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData
import SwiftRecord

class Location: NSManagedObject {
  @NSManaged var locationId: NSNumber
  @NSManaged var altitude: NSNumber
  @NSManaged var altitudeAccuracy: NSNumber
  @NSManaged var coordinate: Coordinate
  @NSManaged var pressure: NSNumber
  @NSManaged var temperature: NSNumber
  
  override internal class func autoIncrementingId() -> String? {
    return "locationId"
  }
}