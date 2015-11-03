//
//  MainController.swift
//  altimeter
//
//  Created by Beau Hankins on 12/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MainController: UIViewController {
  
  // MARK: - Variables & Constants
  
  let locationManager = CLLocationManager()
  lazy var locationData = LocationData()
  lazy var altitudeStore = NSMutableArray()
  lazy var altitudeAccuracyStore = NSMutableArray()
  lazy var unitStore = NSMutableArray()
  
  lazy var altitudeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().LargeHeading
    label.textColor = Colors().White
    label.text = "Altitude"
    return label
    }()
  
  lazy var unitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Unit
    label.textColor = Colors().White
    return label
    }()
  
  lazy var accuracyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textColor = Colors().White
    label.text = "Altitude Accuracy"
    return label
    }()
  
  lazy var psiAndTemperatureLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Center
    label.textColor = Colors().White
    label.text = "Temperature"
    return label
    }()
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.leftBarItem.icon = UIImage(named: "icon-menu")
    nav.leftBarItem.addTarget(self, action: "settingsController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.icon = UIImage(named: "icon-location")
    nav.rightBarItem.addTarget(self, action: "checkInController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var latitudeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Coordinate
    label.text = "Latitude"
    label.textAlignment = .Center
    return label
    }()
  
  lazy var formattedLatitudeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().FormattedCoordinate
    label.text = "Latitude"
    label.textAlignment = .Center
    return label
    }()
  
  lazy var longitudeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Coordinate
    label.text = "Longitude"
    label.textAlignment = .Center
    return label
    }()
  
  lazy var formattedLongitudeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().FormattedCoordinate
    label.text = "Longitude"
    label.textAlignment = .Center
    return label
    }()
  
  lazy var dividerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors().Primary
    return view
    }()
  
  lazy var altitudeView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.altitudeLabel)
    view.addSubview(self.unitLabel)
    
    view.addConstraint(NSLayoutConstraint(item: self.altitudeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.altitudeLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.unitLabel, attribute: .Baseline, relatedBy: .Equal, toItem: self.altitudeLabel, attribute: .Baseline, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.unitLabel, attribute: .Left, relatedBy: .Equal, toItem: self.altitudeLabel, attribute: .Right, multiplier: 1, constant: 5))
    view.addConstraint(NSLayoutConstraint(item: self.unitLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    return view
    }()
  
  lazy var topView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.altitudeView)
    view.addSubview(self.accuracyLabel)
    view.addSubview(self.psiAndTemperatureLabel)
    view.addSubview(self.navigationBar)
    
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.altitudeView, attribute: .Bottom, relatedBy: .Equal, toItem: self.accuracyLabel, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.altitudeView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.accuracyLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.accuracyLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.psiAndTemperatureLabel, attribute: .Top, relatedBy: .Equal, toItem: self.accuracyLabel, attribute: .Bottom, multiplier: 1, constant: 10))
    view.addConstraint(NSLayoutConstraint(item: self.psiAndTemperatureLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    
    return view
    }()
  
  lazy var bottomView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors().White
    
    view.addSubview(self.latitudeLabel)
    view.addSubview(self.formattedLatitudeLabel)
    view.addSubview(self.longitudeLabel)
    view.addSubview(self.formattedLongitudeLabel)
    view.addSubview(self.dividerView)
    
    view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -5))
    view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 0.5, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.formattedLatitudeLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 5))
    view.addConstraint(NSLayoutConstraint(item: self.formattedLatitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 0.5, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.formattedLatitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -5))
    view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.5, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.formattedLongitudeLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 5))
    view.addConstraint(NSLayoutConstraint(item: self.formattedLongitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.5, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
    view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -20))
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    startLocationServices()
    updateWeatherData()
    
    layoutInterface()
  }
  
  override func viewDidLayoutSubviews() {
    let topBackgroundLayer: CAGradientLayer = {
      let layer = Gradients().SecondaryToPrimary
      layer.frame = self.topView.bounds
      layer.backgroundColor = Colors().Secondary.CGColor
      return layer
    }()
    
    topView.layer.insertSublayer(topBackgroundLayer, atIndex: 0)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Interface
  
  func layoutInterface() {
    
    view.addSubview(topView)
    view.addSubview(bottomView)
    
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -100))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    
    updateInterfaceData(LocationData())
  }
  
  func updateInterfaceData(data: LocationData) {
    let altitude = round(data.altitude)
    let altitudeAccuracy = round(data.altitudeAccuracy)
    let temperature = UserSettings.sharedSettings.unit.convertDegrees(data.temperature)
    let latitude = fabs(data.latitude)
    let longitude = fabs(data.longitude)
    
    let altitudeString = String(format: "%.0f", altitude)
    let accuracyString = String(format: "~%.0f' ACCURACY", altitudeAccuracy)
    let psiAndTemperatureString = data.psi > 0 ?
      String(format: "%.0f PSI %.0f°\(UserSettings.sharedSettings.unit.degreesAbbreviation())", data.psi, temperature) :
      String(format: "%.0f°\(UserSettings.sharedSettings.unit.degreesAbbreviation())", temperature)
    let latitudeString = String(format: "%.4f %@", latitude, data.latitude > 0 ? "S" : "N")
    let formattedLatitudeString = formattedCoordinateAngleString(data.latitude)
    let longitudeString = String(format: "%.4f %@", longitude, data.longitude > 0 ? "E" : "W")
    let formattedLongitudeString = formattedCoordinateAngleString(data.longitude)
    
    altitudeLabel.attributedText = attributedString(altitudeString)
    accuracyLabel.attributedText = attributedString(accuracyString)
    psiAndTemperatureLabel.attributedText = attributedString(psiAndTemperatureString)
    latitudeLabel.attributedText = attributedString(latitudeString)
    formattedLatitudeLabel.attributedText = attributedString(formattedLatitudeString)
    longitudeLabel.attributedText = attributedString(longitudeString)
    formattedLongitudeLabel.attributedText = attributedString(formattedLongitudeString)
    
    unitLabel.text = UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString
  }
  
  func formattedCoordinateAngleString(angle: Double) -> String {
    var seconds = Int(angle * 3600)
    let degrees = seconds / 3600
    seconds = abs(seconds % 3600)
    let minutes = seconds / 60
    seconds %= 60
    return String(format:"%d°%d'%d\"",
      abs(degrees),
      minutes,
      seconds)
  }
  
  // MARK: - Location Services

  func startLocationServices() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      if CLLocationManager.locationServicesEnabled() {
        if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
          self.locationManager.requestWhenInUseAuthorization()
        } else {
          self.startUpdatingLocation()
        }
      }
    }
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func updateWeatherData() {
    WeatherHandler().getWeatherData(lat: locationData.latitude, lon: locationData.longitude) { (weatherData:[String : Double]) -> Void in
      self.locationData.temperature = weatherData["temp"]! * (9/5) - 459.67
      self.locationData.psi = weatherData["pressure"]!
      
      self.updateInterfaceData(self.locationData)
    }
  }
  
  // MARK: - Actions
  
  func settingsController() {
    let settingsController = SettingsController()
    settingsController.modalTransitionStyle = .CrossDissolve
    settingsController.modalPresentationStyle = .Custom
    presentViewController(settingsController, animated: true, completion: nil)
  }
  
  func checkInController() {
    let checkIn = CheckIn()
    checkIn.locationData = locationData
    checkIn.timestamp = NSDate()
    
    CheckInDataManager.sharedManager.checkIn = checkIn
    
    let checkInController = CheckInController()
    navigationController?.pushViewController(checkInController, animated: true)
  }
}

// MARK: - CLLocationManagerDelegate

extension MainController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
      startUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if unitStore.count > 0 {
      if unitStore[0] as! NSNumber != UserSettings.sharedSettings.unit.rawValue {
        altitudeStore.removeAllObjects()
        altitudeAccuracyStore.removeAllObjects()
      }
    }
    
    unitStore[0] = UserSettings.sharedSettings.unit.rawValue
    
    if altitudeStore.count > 10 { altitudeStore.removeObjectAtIndex(0) }
    altitudeStore.addObject(UserSettings.sharedSettings.unit.convertDistance(locationManager.location!.altitude.advancedBy(0)))
    
    if altitudeAccuracyStore.count > 5 { altitudeAccuracyStore.removeObjectAtIndex(0) }
    altitudeAccuracyStore.addObject(UserSettings.sharedSettings.unit.convertDistance(locationManager.location!.verticalAccuracy))
    
    let avAltitude = Double((altitudeStore as NSArray as! [Int]).reduce(0,combine:+)) / Double(altitudeStore.count)
    let avAltitudeAccuracy = Double((altitudeAccuracyStore as NSArray as! [Int]).reduce(0,combine:+)) / Double(altitudeAccuracyStore.count)
    
    locationData.altitude = avAltitude
    locationData.altitudeAccuracy = avAltitudeAccuracy
    
    let latitude = locationManager.location!.coordinate.latitude
    let longitude = locationManager.location!.coordinate.longitude
    
    locationData.latitude = latitude
    locationData.longitude = longitude
    
    updateWeatherData()
    
    updateInterfaceData(locationData)
  }
  
  func attributedString(string: String, letterSpacing: Float = 3.0) -> NSAttributedString
  {
    return NSAttributedString(
      string: string,
      attributes:
      [
        NSKernAttributeName: letterSpacing
      ])
  }
}
