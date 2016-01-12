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
  
  let location: Location
  let locationManager = CLLocationManager()
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
    nav.rightBarItem.icon = UIImage(named: "icon-location-white")
    nav.rightBarItem.addTarget(self, action: "checkInController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
  }()
  
  lazy var compass: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "compass")
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    return imageView
  }()
  
  lazy var compassMarkings: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "compass-markings")
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    return imageView
  }()
  
  lazy var compassView: UIView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.compass)
    view.addSubview(self.compassMarkings)

    view.addConstraint(NSLayoutConstraint(item: self.compass, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compass, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compass, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compass, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.compassMarkings, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compassMarkings, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compassMarkings, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.compassMarkings, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    
    return view
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
  
  lazy var locationServicesDisabledLabel: UILabel = {
    let text = "Oh No! Location Services are disabled.\nEnable them in 'Settings > Altimeter'"
    let attributedText = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 8
    attributedText.addAttribute(
      NSParagraphStyleAttributeName,
      value: paragraphStyle,
      range: NSMakeRange(0, text.characters.count))
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().FormattedCoordinate
    label.textColor = Colors().White
    label.attributedText = attributedText
    label.textAlignment = .Center
    label.numberOfLines = 0
    return label
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
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    self.location = Location.create() as! Location
    self.location.save()
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    self.location = Location.create() as! Location
    self.location.save()
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"applicationWillEnterForeground:", name:
      UIApplicationWillEnterForegroundNotification, object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    prepareLocationServices({ () -> Void in
      self.startUpdatingLocation()
      self.updateInterfaceForLocationServices(true)
      }) { () -> Void in
        self.updateInterfaceForLocationServices(false)
    }
    
    updateWeatherData()
    layoutInterface()
    
    NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateData:"), userInfo: nil, repeats: true)
  }
  
  override func viewDidLayoutSubviews() {
    let backgroundLayer: CAGradientLayer = {
      let layer = Gradients().SecondaryToPrimary
      layer.frame = view.bounds
      layer.backgroundColor = Colors().Secondary.CGColor
      return layer
    }()
    
    view.layer.insertSublayer(backgroundLayer, atIndex: 0)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  func applicationWillEnterForeground(notification: NSNotification) {
    prepareLocationServices({ () -> Void in
      self.startUpdatingLocation()
      self.updateInterfaceForLocationServices(true)
      }) { () -> Void in
        self.updateInterfaceForLocationServices(false)
    }
  }
  
  // MARK: - Interface
  
  func layoutInterface() {
    view.addSubview(navigationBar)
    view.addSubview(compassView)
    view.addSubview(topView)
    view.addSubview(bottomView)
    view.addSubview(locationServicesDisabledLabel)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: compassView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 56))
    view.addConstraint(NSLayoutConstraint(item: compassView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 56))
    view.addConstraint(NSLayoutConstraint(item: compassView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: compassView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Top, multiplier: 1, constant: 36))
    
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
    view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomView, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: locationServicesDisabledLabel, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -40))
    view.addConstraint(NSLayoutConstraint(item: locationServicesDisabledLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: -40))
    view.addConstraint(NSLayoutConstraint(item: locationServicesDisabledLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: locationServicesDisabledLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    
    updateInterfaceData(location)
  }
  
  func updateData(sender: AnyObject?) {
    updateInterfaceData(location)
  }
  
  func updateInterfaceData(location: Location) {
    let altitude = round(location.altitude.doubleValue)
    let altitudeAccuracy = round(location.altitudeAccuracy.doubleValue)
    let temperature = UserSettings.sharedSettings.unit.convertDegrees(location.temperature.doubleValue)
    let latitude = fabs(location.coordinate.latitude.doubleValue)
    let longitude = fabs(location.coordinate.longitude.doubleValue)
    
    let altitudeString = String(format: "%.0f", altitude)
    let accuracyString = String(format: "~%.0f' ACCURACY", altitudeAccuracy)
    let pressureAndTemperatureString = location.pressure.doubleValue > 0 ?
      String(format: "%.02f PSI   %.0f°\(UserSettings.sharedSettings.unit.degreesAbbreviation())", location.pressure, temperature) :
      String(format: "%.0f°\(UserSettings.sharedSettings.unit.degreesAbbreviation())", temperature)
    let latitudeString = String(format: "%.4f %@", latitude, location.coordinate.latitude.doubleValue > 0 ? "S" : "N")
    let formattedLatitudeString = formattedCoordinateAngleString(location.coordinate.latitude.doubleValue)
    let longitudeString = String(format: "%.4f %@", longitude, location.coordinate.longitude.doubleValue > 0 ? "E" : "W")
    let formattedLongitudeString = formattedCoordinateAngleString(location.coordinate.longitude.doubleValue)
    
    altitudeLabel.attributedText = attributedString(altitudeString)
    accuracyLabel.attributedText = attributedString(accuracyString)
    psiAndTemperatureLabel.attributedText = attributedString(pressureAndTemperatureString)
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

  func prepareLocationServices(completion: () -> Void, failure: () -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      if CLLocationManager.locationServicesEnabled() {
        
        if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
          self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways ||
           CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            dispatch_async(dispatch_get_main_queue()) {
              completion()
            }
            return
        }
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        failure()
      }
    }
  }
  
  func updateInterfaceForLocationServices(enabled: Bool) {
    if enabled {
      topView.hidden = false
      bottomView.hidden = false
      navigationBar.rightBarItem.enabled = true
      locationServicesDisabledLabel.hidden = true
    } else {
      topView.hidden = true
      bottomView.hidden = true
      navigationBar.rightBarItem.enabled = false
      locationServicesDisabledLabel.hidden = false
    }
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  func updateWeatherData() {
    WeatherHandler().getWeatherData(lat: location.coordinate.latitude.doubleValue, lon: location.coordinate.longitude.doubleValue) {
      weatherData in
      if let
        temp = weatherData["temp"],
        pressure = weatherData["pressure"] {
          self.location.temperature = self.fahrenheit(kelvin: temp)
          self.location.pressure = self.psi(hPa: pressure)
      }
      
      self.updateInterfaceData(self.location)
    }
  }
  
  func psi(hPa pressure: Double) -> Double {
    return pressure * 0.014503773800722
  }
  
  func fahrenheit(kelvin temp: Double) -> Double {
    return temp * (9/5) - 459.67
  }
  
  // MARK: - Actions
  
  func settingsController() {
    let settingsController = SettingsController()
    settingsController.modalTransitionStyle = .CrossDissolve
    settingsController.modalPresentationStyle = .Custom
    presentViewController(settingsController, animated: true, completion: nil)
  }
  
  func checkInController() {
    let checkIn = CheckIn.create() as! CheckIn
    checkIn.location = location
    checkIn.dateCreated = NSDate()
    
    let checkInController = CheckInController(checkIn: checkIn)
    navigationController?.pushViewController(checkInController, animated: true)
  }
}

// MARK: - CLLocationManagerDelegate

extension MainController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
      startUpdatingLocation()
      updateInterfaceForLocationServices(true)
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if manager == locationManager, let managedLocation = manager.location {
      let unit = UserSettings.sharedSettings.unit
      
      if altitudeStore.count > 10 { altitudeStore.removeObjectAtIndex(0) }
      altitudeStore.addObject(location.altitude as Double)
      
      if altitudeAccuracyStore.count > 5 { altitudeAccuracyStore.removeObjectAtIndex(0) }
      altitudeAccuracyStore.addObject(managedLocation.verticalAccuracy)
      
      let avAltitude = unit.convertDistance(average(altitudeStore as NSArray as! [Double]))
      let avAltitudeAccuracy = unit.convertDistance(average(altitudeAccuracyStore as NSArray as! [Double]))
      let latitude = location.coordinate.latitude
      let longitude = location.coordinate.longitude
      
      location.altitude = avAltitude
      location.altitudeAccuracy = avAltitudeAccuracy
      location.coordinate.latitude = latitude
      location.coordinate.longitude = longitude
    }
  }
  
  func average(array: [Double]) -> Double {
    return array.reduce(0, combine:+) / Double(array.count)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let heading = newHeading.magneticHeading
    let headingDegrees = (-heading*M_PI/180)
    
    compass.transform = CGAffineTransformMakeRotation(CGFloat(headingDegrees));
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
