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

class PlaceSearchHandler {
  let APIKEY = "AIzaSyBEFgz1nnN_4HiaE8bQFm1U0xhbOFZIjUg"

  func getPlaces(query: String, completion: ([Place]) -> Void, failure: (NSError?) -> Void) {
    let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let parameters = [
      "input": query,
      "key": APIKEY
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
      .responseJSON {
        response in
        
        if let data = response.result.value, predictions = data["predictions"] as? Array<AnyObject> {
          let placeIds = $.map(predictions, transform: {
            prediction in
            return prediction["place_id"] as! String
          })
          
          self.getPlaceDetails(placeIds, completion: {
            places in
            completion(places)
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
  
  private func getPlaceDetails(placeIds: [String], completion: ([Place]) -> Void, failure: (NSError?) -> Void) {
    let places = NSMutableArray()
    
    $.each(placeIds) {
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
                  coord = result["geometry"]?["location"],
                  lat = coord["lat"] as? Double,
                  lng = coord["lng"] as? Double {
                    let coordinate = Coordinate.create() as! Coordinate
                    coordinate.latitude = lat
                    coordinate.longitude = lng
                    coordinate.save()
                    
                    let place = Place.create() as! Place
                    place.name = name
                    place.coordinate = coordinate
                    place.save()
                    
                    places.addObject(place)
                    
                    if let lastId = $.last(placeIds) where id == lastId  {
                      completion(places as NSArray as! [Place])
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