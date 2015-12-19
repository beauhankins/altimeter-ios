//
//  LocationSearchHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 15/12/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import Dollar

class LocationSearchHandler {
  let APIKEY = "AIzaSyBEFgz1nnN_4HiaE8bQFm1U0xhbOFZIjUg"

  func getLocations(query: String, completion: ([Location]) -> Void, failure: (NSError?) -> Void) {
    let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let parameters = [
      "input": query,
      "key": APIKEY
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
      .responseJSON {
        response in
        
        if let data = response.result.value, predictions = data["predictions"] as? Array<AnyObject> {
          let locationIds = $.map(predictions, transform: {
            prediction in
            return prediction["place_id"] as! String
          })
          
          self.getLocationDetails(locationIds, completion: {
            locations in
            completion(locations)
            }, failure: {
              error in
              failure(error)
          })
        }
        
        if let error = response.result.error {
          failure(error)
        }
      }
  }
  
  private func getLocationDetails(locationIds: [String], completion: ([Location]) -> Void, failure: (NSError?) -> Void) {
    let locations = NSMutableArray()
    
    $.each(locationIds) {
      i, id in
      let url = "https://maps.googleapis.com/maps/api/place/details/json"
      let parameters = [
        "placeid": String(id),
        "key": self.APIKEY
      ]
      
      Alamofire.request(.GET, url, parameters: parameters)
        .responseJSON {
          response in
          
          if let error = response.result.error {
            failure(error)
          } else {
            if let result = response.result.value?["result"] {
              if let result = result {
                if let
                  name = result["name"] as? String,
                  location = result["geometry"]?["location"],
                  lat = location["lat"] as? Double,
                  lng = location["lng"] as? Double {
                    locations.addObject(Location(
                      name: name,
                      coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)
                      ))
                    
                    if let lastId = $.last(locationIds) where id == lastId  {
                      completion(locations as NSArray as! [Location])
                    }
                    
                    return
                }
              }
            }
          }
          
          failure(nil)
      }
    }
  }
}