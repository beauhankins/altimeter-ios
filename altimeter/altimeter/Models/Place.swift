//
//  Location.swift
//  altimeter
//
//  Created by Beau Hankins on 15/12/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData
import SwiftRecord

class Place: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var coordinate: Coordinate
}