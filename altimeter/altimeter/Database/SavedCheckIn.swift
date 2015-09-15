//
//  SavedCheckIn.swift
//  altimeter
//
//  Created by Beau Hankins on 26/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData

@objc(SavedCheckIn)
class SavedCheckIn: NSManagedObject {
  @NSManaged var locationData: NSData?
  @NSManaged var timestamp: NSDate?
  @NSManaged var image: NSData?
  @NSManaged var locationName: String?
}
