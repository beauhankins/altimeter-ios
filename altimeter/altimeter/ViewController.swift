//
//  ViewController.swift
//  altimeter
//
//  Created by Beau Hankins on 12/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    lazy var altitudeLabel: UILabel = {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        label.text = "1,337"
        return label
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
        self.view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        self.view.addSubview(altitudeLabel)
        
        self.view.addConstraint(NSLayoutConstraint(item: altitudeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: altitudeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
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
        println("Altitude: \(locationManager.location.altitude)")
        
        locationData.altitude = locationManager.location.altitude.distanceTo(0)
    }
}

