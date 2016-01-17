//
//  CheckIn.swift
//  altimeter
//
//  Created by Beau Hankins on 26/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData
import SwiftRecord

class CheckIn: NSManagedObject {
  @NSManaged var checkInId: NSNumber
  @NSManaged var location: Location
  @NSManaged var photoId: NSString?
  @NSManaged var dateCreated: NSDate
  @NSManaged var place: Place?
  @NSManaged var saved: Bool
  
  override internal class func autoIncrementingId() -> String? {
    return "checkInId"
  }
}