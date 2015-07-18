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
import CoreMotion

class MainController: UIViewController {
  
  // MARK: - Variables & Constants
  
  let locationManager = CLLocationManager()
  let barometerManager = CMAltimeter()
  lazy var locationData = LocationData()
  lazy var altitudeStore = NSMutableArray() // Remember to reset this when toggling between Fahrenheit & Celsius
  lazy var altitudeAccuracyStore = NSMutableArray() // Remember to reset this when toggling between Fahrenheit & Celsius
  
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
    nav.leftBarItem.icon = UIImage(named: "icon-gear")
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
    
    configureInterface()
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
  
  func configureInterface() {
    
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
    let altitudeString = String(format: "%.0f", round(data.altitude))
    let accuracyString = String(format: "~%.0f' ACCURACY", round(data.altitudeAccuracy))
    let psiAndTemperatureString = data.psi > 0 ? String(format: "%.2f PSI %.0f°C", data.psi, 77.0) : String(format: "%.0f°C", 77.0)
    let latitudeString = String(format: "%.4f %@", fabs(data.latitude), data.longitude > 0 ? "S" : "N")
    let formattedLatitudeString = formattedCoordinateAngleString(data.latitude)
    let longitudeString = String(format: "%.4f %@", fabs(data.longitude), data.longitude > 0 ? "E" : "W")
    let formattedLongitudeString = formattedCoordinateAngleString(data.longitude)
    
    altitudeLabel.attributedText = attributedString(altitudeString)
    accuracyLabel.attributedText = attributedString(accuracyString)
    psiAndTemperatureLabel.attributedText = attributedString(psiAndTemperatureString)
    latitudeLabel.attributedText = attributedString(latitudeString)
    formattedLatitudeLabel.attributedText = attributedString(formattedLatitudeString)
    longitudeLabel.attributedText = attributedString(longitudeString)
    formattedLongitudeLabel.attributedText = attributedString(formattedLongitudeString)
    
    unitLabel.text = UserSettings.sharedSettings.unit.abbreviation().uppercaseString
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
    if CLLocationManager.locationServicesEnabled() {
      if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
        locationManager.requestWhenInUseAuthorization()
      } else {
        startUpdatingLocation()
      }
    }
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
    startUpdatingAltimeter()
  }
  
  // MARK: - Barometer
  
  func startUpdatingAltimeter() {
    if CMAltimeter.isRelativeAltitudeAvailable() {
      barometerManager.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { data, error in
        if error != nil {
          self.locationData.psi = Double((data as CMAltitudeData?)!.pressure)
          print("Relative Altitude: \(data!.relativeAltitude)")
        } else {
          print("Relative Altitude: \(error!.localizedDescription)")
        }
      })
    }
  }
  
  // MARK: - Actions
  
  func settingsController() {
    print("Action: Settings Controller")
    let settingsController = SettingsController()
    settingsController.modalTransitionStyle = .CrossDissolve
    settingsController.modalPresentationStyle = .Custom
    presentViewController(settingsController, animated: true, completion: nil)
  }
  
  func checkInController() {
    print("Action: Check-In Controller")
    CheckInDataManager.sharedManager.locationData = locationData
    CheckInDataManager.sharedManager.timestamp = NSDate()
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
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
    if altitudeStore.count > 10 { altitudeStore.removeObjectAtIndex(0) }
    altitudeStore.addObject((locationManager.location!.altitude.advancedBy(0) * UserSettings.sharedSettings.unit.factor()))
    
    if altitudeAccuracyStore.count > 10 { altitudeAccuracyStore.removeObjectAtIndex(0) }
    altitudeAccuracyStore.addObject(locationManager.location!.verticalAccuracy * UserSettings.sharedSettings.unit.factor())
    
    let avAltitude = Double((altitudeStore as NSArray as! [Int]).reduce(0,combine:+)) / Double(altitudeStore.count)
    let avAltitudeAccuracy = Double((altitudeAccuracyStore as NSArray as! [Int]).reduce(0,combine:+)) / Double(altitudeAccuracyStore.count)
    
    locationData.altitude = avAltitude
    locationData.altitudeAccuracy = avAltitudeAccuracy
    locationData.latitude = locationManager.location!.coordinate.latitude
    locationData.longitude = locationManager.location!.coordinate.longitude
    
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
