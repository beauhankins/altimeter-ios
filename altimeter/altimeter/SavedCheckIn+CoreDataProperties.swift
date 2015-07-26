//
//  SavedCheckIn+CoreDataProperties.swift
//  altimeter
//
//  Created by Beau Hankins on 26/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension SavedCheckIn {
  @NSManaged var locationData: NSData?
  @NSManaged var timestamp: NSDate?
  @NSManaged var image: NSData?
  @NSManaged var locationName: String?
}
