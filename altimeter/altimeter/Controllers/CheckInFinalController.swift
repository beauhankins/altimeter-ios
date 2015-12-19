//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 24/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import ReachabilitySwift

class CheckInFinalController: UIViewController {
  // MARK: - Variables & Constants
  
  lazy var locationData = CheckInDataManager.sharedManager.checkIn.locationData
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Check-In"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Back"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: "prevController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Share"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().Primary
    nav.rightBarItem.addTarget(self, action: "nextControllerShared", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var serviceStatusBar: StatusBar = {
    let statusBar = StatusBar()
    statusBar.translatesAutoresizingMaskIntoConstraints = false
    statusBar.text = "NO SERVICE"
    statusBar.hidden = self.serviceIsAvailable()
    return statusBar
    }()
  
  lazy var informationDetailView: InformationDetailView = {
    let view = InformationDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    let altitude = self.locationData.altitude
    let altitudeString = String(format: "%.0f", round(altitude))
    if let locationName = CheckInDataManager.sharedManager.checkIn.locationName {
      view.title = "\(locationName) – \(altitudeString) \(UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString)"
    } else {
      view.title = "\(altitudeString) \(UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString)"
    }
    
    view.titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
    view.style = .Gradient
    view.icon = UIImage(named: "icon-location-white")
    return view
    }()
  
  lazy var locationDataDetailView: LocationDataDetailView = {
    let view = LocationDataDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.checkIn = CheckInDataManager.sharedManager.checkIn
    return view
    }()
  
  lazy var addPhotoButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Add Photo"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Primary
    listControl.icon = UIImage(named: "icon-plus")!
    if let data = CheckInDataManager.sharedManager.checkIn.image {
      listControl.image = UIImage(data: data)
    }
    listControl.addTarget(self, action: Selector("addPhoto:"), forControlEvents: .TouchUpInside)
    return listControl
    }()
  
  lazy var facebookCheckBox: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Facebook"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Black
    listControl.checkboxImage = UIImage(named: "radio-facebook")!
    listControl.showCheckBox = true
    listControl.addTarget(self, action: Selector("checkBoxPressed:"), forControlEvents: .TouchUpInside)
    listControl.hidden = !self.serviceIsAvailable()
    return listControl
    }()
  
  lazy var twitterCheckBox: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Twitter"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Black
    listControl.checkboxImage = UIImage(named: "radio-twitter")!
    listControl.showCheckBox = true
    listControl.textIndent = 20.0
    listControl.addTarget(self, action: Selector("checkBoxPressed:"), forControlEvents: .TouchUpInside)
    listControl.hidden = !self.serviceIsAvailable()
    return listControl
    }()
  
  lazy var saveButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.stateText = "Save Check-In"
    listControl.addTarget(self, action: Selector("nextController"), forControlEvents: .TouchUpInside)
    return listControl
  }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.serviceStatusBar)
    view.addSubview(self.informationDetailView)
    view.addSubview(self.locationDataDetailView)
    view.addSubview(self.addPhotoButton)
    view.addSubview(self.facebookCheckBox)
    view.addSubview(self.twitterCheckBox)
    view.addSubview(self.saveButton)
    
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.serviceStatusBar, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.informationDetailView, attribute: .Bottom, multiplier: 1, constant: 0))

    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Top, relatedBy: .Equal, toItem: self.locationDataDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 10))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Top, relatedBy: .Equal, toItem: self.addPhotoButton, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 10))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Top, relatedBy: .Equal, toItem: self.addPhotoButton, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Top, relatedBy: .Equal, toItem: self.facebookCheckBox, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layoutInterface()
    requestPhotosPermissions()
    startMonitoringReachability()
  }
  
  override func viewWillAppear(animated: Bool) {
    updateThumbnail()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
    view.backgroundColor = Colors().White
    
    view.addSubview(navigationBar)
    view.addSubview(contentView)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
    serviceDidChange(serviceIsAvailable())
  }
  
  func updateThumbnail() {
    if let data = CheckInDataManager.sharedManager.checkIn.image {
      self.addPhotoButton.image = UIImage(data: data)
      
      self.addPhotoButton.text = "Remove Photo"
      self.addPhotoButton.icon = nil
      self.addPhotoButton.setNeedsLayout()
      self.addPhotoButton.layoutIfNeeded()
    } else {
      self.addPhotoButton.image = nil
      
      self.addPhotoButton.text = "Add Photo"
      self.addPhotoButton.icon = UIImage(named: "icon-plus")!
      self.addPhotoButton.setNeedsLayout()
      self.addPhotoButton.layoutIfNeeded()
    }
  }
  
  func serviceDidChange(serviceIsAvailable: Bool) {
    self.serviceStatusBar.hidden = serviceIsAvailable
    self.facebookCheckBox.hidden = !serviceIsAvailable
    self.twitterCheckBox.hidden = !serviceIsAvailable
    self.saveButton.hidden = serviceIsAvailable
    
    self.serviceStatusBar.setNeedsLayout()
    self.facebookCheckBox.setNeedsLayout()
    self.twitterCheckBox.setNeedsLayout()
    self.saveButton.setNeedsLayout()
    
    self.serviceStatusBar.layoutIfNeeded()
    self.facebookCheckBox.layoutIfNeeded()
    self.twitterCheckBox.layoutIfNeeded()
    self.saveButton.layoutIfNeeded()
  }
  
  // MARK: - Actions
  
  func prevController() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func nextControllerShared() {
    saveCheckIn()
    
    let alerts = NSMutableArray()
    
    let checkIn = CheckInDataManager.sharedManager.checkIn
    if facebookCheckBox.selected {
      CheckInServiceHandler().checkIn(checkIn, services: CheckInService.Facebook, success: { () -> Void in
        let checkInSuccessController = CheckInSuccessController()
        checkInSuccessController.isShared = true;
        self.navigationController?.pushViewController(checkInSuccessController, animated: true)
        
        }, failure: { () -> Void in
          let alertController = UIAlertController(
                                  title: "Post to Facebook Failed",
                                  message: "You are not logged in to Facebook. Update your details in Settings > Facebook.",
                                  preferredStyle: .Alert)
          
          let okButton = UIAlertAction(title: "👍", style: .Cancel) {
            action -> Void in
            if alerts.count > 1 {
              alerts.removeObjectAtIndex(0)
              let alert = alerts[0] as! UIAlertController
              
              self.presentViewController(alert, animated: true, completion: nil)
            }
          }
          alertController.addAction(okButton)
          
          if alerts.count == 0 {
            self.presentViewController(alertController, animated: true, completion: nil)
          }
          
          alerts.addObject(alertController)
      })
    }
    if twitterCheckBox.selected {
      CheckInServiceHandler().checkIn(checkIn, services: CheckInService.Twitter, success: { () -> Void in
        let checkInSuccessController = CheckInSuccessController()
        checkInSuccessController.isShared = true;
        self.navigationController?.pushViewController(checkInSuccessController, animated: true)
        
        }, failure: { () -> Void in
          let alertController = UIAlertController(
                                  title: "Tweet Failed",
                                  message: "You are not logged in to Twitter. Update your details in Settings > Twitter.",
                                  preferredStyle: .Alert)
          
          let okButton = UIAlertAction(title: "👍", style: .Cancel) {
            action -> Void in
            if alerts.count > 1 {
              alerts.removeObjectAtIndex(0)
              let alert = alerts[0] as! UIAlertController
              
              self.presentViewController(alert, animated: true, completion: nil)
            }
          }
          alertController.addAction(okButton)
          
          if alerts.count == 0 {
            self.presentViewController(alertController, animated: true, completion: nil)
          }
          
          alerts.addObject(alertController)
      })
      
    }
  }
  
  func nextController() {
    saveCheckIn()
    let checkInSuccessController = CheckInSuccessController()
    navigationController?.pushViewController(checkInSuccessController, animated: true)
  }
  
  func requestPhotosPermissions() {
    let library = ALAssetsLibrary()
    library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { group, stop -> Void in }) { error -> Void in }
  }
  
  func saveCheckIn() {
    let checkIn = CheckInDataManager.sharedManager.checkIn
    SavedCheckInHandler().save(checkIn)
  }
  
  func addPhoto(sender: AnyObject) {
    if let _ = CheckInDataManager.sharedManager.checkIn.image {
      CheckInDataManager.sharedManager.checkIn.image = nil
      updateThumbnail()
    } else {
      let photoGridController = PhotoGridController()
      photoGridController.modalTransitionStyle = .CoverVertical
      presentViewController(photoGridController, animated: true, completion: nil)
    }
  }
  
  func checkBoxPressed(sender: AnyObject) {
    let button = sender as! ListControl
    button.selected = !button.selected
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  // MARK: - Validation
  
  func canContinue() -> Bool {
    return (facebookCheckBox.selected || twitterCheckBox.selected)
  }
  
  func serviceIsAvailable() -> Bool {
    let reachability: Reachability

    do {
      reachability = try Reachability.reachabilityForInternetConnection()
    } catch {
      print("Unable to create Reachability")
      return false
    }
    
    return reachability.isReachable()
  }
  
  func startMonitoringReachability() {
    let reachability: Reachability
    
    do {
      reachability = try Reachability.reachabilityForInternetConnection()
    } catch {
      print("Unable to create Reachability")
      return
    }
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "reachabilityChanged:",
      name: ReachabilityChangedNotification,
      object: reachability)
  }
  
  func reachabilityChanged(note: NSNotification) {
    let reachability = note.object as! Reachability
    self.serviceDidChange(reachability.isReachable())
  }
}
