//
//  Coordinate.swift
//  altimeter
//
//  Created by Beau Hankins on 10/01/2016.
//  Copyright © 2016 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData
import SwiftRecord

class Coordinate: NSManagedObject {
  @NSManaged var coordinateId: NSNumber
  @NSManaged var latitude: NSNumber
  @NSManaged var longitude: NSNumber
  
  override internal class func autoIncrementingId() -> String? {
    return "coordinateId"
  }
}