//
//  Location.swift
//  altimeter
//
//  Created by Beau Hankins on 15/12/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import MapKit

class Location {
  let name: String
  let coordinate: CLLocationCoordinate2D
  
  init(name: String, coordinate: CLLocationCoordinate2D) {
    self.name = name
    self.coordinate = coordinate
  }
  
  convenience init() {
    self.init(name: "", coordinate: CLLocationCoordinate2D())
  }
}