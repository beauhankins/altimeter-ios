//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 16/07/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CheckInSuccessController: UIViewController {
  // MARK: - Variables & Constants
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    
    nav.rightBarItem.text = "Close"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().White
    nav.rightBarItem.addTarget(self, action: "closeController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var informationDetailView: InformationDetailView = {
    let view = InformationDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    let altitude = CheckInDataManager.sharedManager.checkIn!.locationData?.altitude
    let altitudeString = String(format: "%.0f", round(altitude!))
    view.title = "\(altitudeString)\(UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString)"
    view.style = .Gradient
    view.icon = UIImage(named: "icon-location")
    return view
    }()
  
  lazy var locationDataDetailView: LocationDataDetailView = {
    let view = LocationDataDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.checkIn = CheckInDataManager.sharedManager.checkIn!
    return view
    }()
  
  lazy var openMapsButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Open in Maps"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Primary
    listControl.icon = UIImage(named: "icon-map")!
    listControl.addTarget(self, action: Selector("openMaps:"), forControlEvents: .TouchUpInside)
    return listControl
    }()
  
  lazy var successView: InformationDetailView = {
    let view = InformationDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.title = "Shared Successfully!"
    view.backgroundColor = Colors().Primary
    view.style = .Default
    view.textColor = Colors().White
    view.titleLabel.font = Fonts().Default
    view.icon = UIImage(named: "radio-whiteChecked")
    return view
    }()
  
  lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    let latitude = CheckInDataManager.sharedManager.checkIn!.locationData?.latitude
    let longitude = CheckInDataManager.sharedManager.checkIn!.locationData?.longitude
    mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
    return mapView
    }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = Colors().White
    
    view.addSubview(self.informationDetailView)
    view.addSubview(self.locationDataDetailView)
    view.addSubview(self.openMapsButton)
    
    view.layer.masksToBounds = false
    view.layer.shadowOffset = CGSizeMake(0.0, 1.0)
    view.layer.shadowOpacity = 0.15
    view.layer.shadowRadius = 2.0
    
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.informationDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.openMapsButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.openMapsButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.openMapsButton, attribute: .Top, relatedBy: .Equal, toItem: self.locationDataDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.openMapsButton, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.openMapsButton, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layoutInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
    view.backgroundColor = Colors().White
    
    view.addSubview(mapView)
    view.addSubview(contentView)
    view.addSubview(successView)
    view.addSubview(navigationBar)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: successView, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  override func viewDidLayoutSubviews() {
    let topBackgroundLayer: CAGradientLayer = {
      let layer = Gradients().SecondaryToPrimary
      layer.frame = self.navigationBar.bounds
      layer.backgroundColor = Colors().Secondary.CGColor
      layer.startPoint = CGPoint(x: 0,y: 0.5)
      layer.endPoint = CGPoint(x: 1,y: 0.5)
      return layer
      }()
    
    navigationBar.layer.insertSublayer(topBackgroundLayer, atIndex: 0)
  }
  
  // MARK: - Actions
  
  func closeController() {
    navigationController?.dismissViewControllerAnimated(true, completion: nil)
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func openMaps(sender: AnyObject) {
    let coord = CLLocationCoordinate2D(latitude: (CheckInDataManager.sharedManager.checkIn!.locationData?.latitude)!, longitude: (CheckInDataManager.sharedManager.checkIn!.locationData?.longitude)!)
    let placemark = MKPlacemark(coordinate: coord, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    
    mapItem.openInMapsWithLaunchOptions(nil)
  }
  
  func canContinue() -> Bool {
    return true
  }
}