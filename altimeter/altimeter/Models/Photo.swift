//
//  Photo.swift
//  altimeter
//
//  Created by Beau Hankins on 1/01/2016.
//  Copyright © 2016 Beau Hankins. All rights reserved.
//

import Foundation
import CoreData
import SwiftRecord

class Photo: NSManagedObject {
  @NSManaged var original: NSData
  @NSManaged var thumbnail: NSData
}