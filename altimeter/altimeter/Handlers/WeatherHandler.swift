//
//  WeatherHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 8/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation

class WeatherHandler {
  private func fetchWeather( lat lat: Double, lon: Double, completion: (AnyObject) -> Void, failure: (NSError) -> Void ) {
    let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)"
    
    let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    manager.POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
      completion(responseObject)
      }) { (operation: AFHTTPRequestOperation, error: NSError) -> Void in
      failure(error)
    }
  }
  
  func getWeatherData( lat lat: Double, lon: Double, completion: ([String:Double]) -> Void ) {
    fetchWeather(lat: lat, lon: lon, completion: { (responseObject: AnyObject) -> Void in
      var temp = 0.0
      var pressure = 0.0
      
      if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
        if let main = jsonResult["main"] as? Dictionary<String, AnyObject> {
          if let _temp = main["temp"] as? Double {
            temp = _temp
          }
          if let _pressure = main["pressure"] as? Double {
            pressure = _pressure
          }
        }
      }
      
      completion([
        "temp":temp,
        "pressure":pressure
        ])
      
      }) { (error: NSError) -> Void in
      
    }
  }
}