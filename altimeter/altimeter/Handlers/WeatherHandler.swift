//
//  WeatherHandler.swift
//  altimeter
//
//  Created by Beau Hankins on 8/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import Alamofire

class WeatherHandler {
  let APIKEY = "922effc79b3cf84d8aecbe895279057f"
  
  func getWeatherData(lat lat: Double, lon: Double, completion: ([String:Double]) -> Void) {
    
    fetchWeather(lat: lat, lon: lon, completion: { (responseObject: AnyObject) -> Void in
      var temp = 0.0
      var pressure = 0.0
      
      if let jsonResult = responseObject as? Dictionary<String, AnyObject>, main = jsonResult["main"] as? Dictionary<String, AnyObject> {
        if let _temp = main["temp"] as? Double {
          temp = _temp
        }
        if let _pressure = main["pressure"] as? Double {
          pressure = _pressure
        }
      }
      
      completion([
        "temp": temp,
        "pressure": pressure
        ])
      
      }) {
        error -> Void in
      print(error)
    }
  }
  
  private func fetchWeather(lat lat: Double, lon: Double, completion: (AnyObject) -> Void, failure: (NSError) -> Void) {
    let url = "http://api.openweathermap.org/data/2.5/weather"
    let parameters = [
      "lat": String(lat),
      "lon": String(lon),
      "APPID": APIKEY
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
      .responseJSON {
        response in
        if let data = response.result.value {
          completion(data)
        }
        
        if let error = response.result.error {
          failure(error)
        }
    }
  }
}