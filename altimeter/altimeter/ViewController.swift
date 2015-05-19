//
//  ViewController.swift
//  altimeter
//
//  Created by Beau Hankins on 12/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let unit = "ft"

    lazy var altitudeLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 54)
        label.textColor = Colors().White
        label.text = "Altitude"
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = Colors().White
        label.text = self.unit.uppercaseString
        return label
    }()
    
    lazy var accuracyLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textColor = Colors().White
        label.text = "Altitude Accuracy"
        return label
    }()
    
    lazy var psiAndTemperatureLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = Colors().White
        label.text = "Temperature"
        return label
    }()
    
    lazy var latitudeLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.text = "Latitude"
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var longitudeLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.text = "Longitude"
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var dividerView: UIView = {
        let view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = Colors().Primary
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = Colors().Primary
        
        view.addSubview(self.altitudeLabel)
        view.addSubview(self.unitLabel)
        view.addSubview(self.accuracyLabel)
        view.addSubview(self.psiAndTemperatureLabel)
        
        view.addConstraint(NSLayoutConstraint(item: self.altitudeLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.accuracyLabel, attribute: .CenterY, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: self.altitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: -(self.unitLabel.frame.size.width)-10))
        
        view.addConstraint(NSLayoutConstraint(item: self.unitLabel, attribute: .Baseline, relatedBy: .Equal, toItem: self.altitudeLabel, attribute: .Baseline, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.unitLabel, attribute: .Left, relatedBy: .Equal, toItem: self.altitudeLabel, attribute: .Right, multiplier: 1, constant: 5))
        
        view.addConstraint(NSLayoutConstraint(item: self.accuracyLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.accuracyLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self.psiAndTemperatureLabel, attribute: .Top, relatedBy: .Equal, toItem: self.accuracyLabel, attribute: .Bottom, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: self.psiAndTemperatureLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = Colors().White
        
        view.addSubview(self.latitudeLabel)
        view.addSubview(self.longitudeLabel)
        view.addSubview(self.dividerView)
        
        view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 0.5, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.latitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.5, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.longitudeLabel, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
        view.addConstraint(NSLayoutConstraint(item: self.dividerView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -20))
        
        return view
    }()
    
    let locationManager = CLLocationManager()
    
    lazy var locationData: LocationData = LocationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInterface()
    }
    
    override func  viewWillAppear(animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        triggerLocationServices()
    }
    
    func configureInterface() {
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        
        self.view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: topView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1, constant: -100))
        self.view.addConstraint(NSLayoutConstraint(item: topView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        self.view.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
    }
    
    func triggerLocationServices() {
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
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("Altitude: \(locationManager.location.altitude.advancedBy(0) * 3.2808399)")
        
        locationData.altitude = locationManager.location.altitude.advancedBy(0) * 3.2808399
        locationData.altitudeAccuracy = locationManager.location.verticalAccuracy * 3.2808399
        locationData.latitude = locationManager.location.coordinate.latitude
        locationData.longitude = locationManager.location.coordinate.longitude
        
        updateInterface(locationData)
    }
    
    func updateInterface(data: LocationData) {
        var altitudeString = NSString(format: "%.0f", round(data.altitude)) as String
        var accuracyString = NSString(format: "~%.0f' ACCURACY", round(data.altitudeAccuracy)) as String
        var psiString = NSString(format: "%.2f PSI", 11.99) as String
        var temperatureString = NSString(format: "%.0f°C", 77.0) as String
        var latitudeString = NSString(format: "%.4f", data.latitude) as String
        var longitudeString = NSString(format: "%.4f", data.longitude) as String
        
        altitudeLabel.attributedText = attributedString(altitudeString)
        accuracyLabel.attributedText = attributedString(accuracyString)
        psiAndTemperatureLabel.attributedText = attributedString("\(psiString)  \(temperatureString)")
        latitudeLabel.attributedText = attributedString(latitudeString)
        longitudeLabel.attributedText = attributedString(longitudeString)
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

