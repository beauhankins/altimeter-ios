//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 24/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class CheckInFinalController: UIViewController {
  // MARK: - Variables & Constants
  
  lazy var locationData = CheckInDataManager.sharedManager.checkIn!.locationData!
  
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
    nav.rightBarItem.addTarget(self, action: "nextController", forControlEvents: UIControlEvents.TouchUpInside)
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
  
  lazy var addPhotoButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Add Photo"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Primary
    listControl.icon = UIImage(named: "icon-plus")!
    if let data = CheckInDataManager.sharedManager.checkIn!.image {
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
    listControl.checkboxImage = UIImage(named: "radio-facebook")!
    listControl.showCheckBox = true
    listControl.addTarget(self, action: Selector("checkBoxPressed:"), forControlEvents: .TouchUpInside)
    return listControl
    }()
  
  lazy var twitterCheckBox: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Twitter"
    listControl.textLabel.font = Fonts().Heading
    listControl.checkboxImage = UIImage(named: "radio-twitter")!
    listControl.showCheckBox = true
    listControl.textIndent = 20.0
    listControl.addTarget(self, action: Selector("checkBoxPressed:"), forControlEvents: .TouchUpInside)
    return listControl
    }()
  
  lazy var socialView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.facebookCheckBox)
    view.addSubview(self.twitterCheckBox)
    
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Left, relatedBy: .Equal, toItem: self.facebookCheckBox, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.informationDetailView)
    view.addSubview(self.locationDataDetailView)
    view.addSubview(self.addPhotoButton)
    view.addSubview(self.socialView)
    
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.informationDetailView, attribute: .Bottom, multiplier: 1, constant: 0))

    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Top, relatedBy: .Equal, toItem: self.locationDataDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Top, relatedBy: .Equal, toItem: self.addPhotoButton, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    updateThumbnail()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Configure Interface
  
  func configureInterface() {
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
  }
  
  func updateThumbnail() {
    if let data = CheckInDataManager.sharedManager.checkIn!.image {
      self.addPhotoButton.image = UIImage(data: data)
      
      self.addPhotoButton.text = "Remove Photo"
      self.addPhotoButton.icon = nil
      self.addPhotoButton.textIndent = 10.0
    } else {
      self.addPhotoButton.image = nil
      
      self.addPhotoButton.text = "Add Photo"
      self.addPhotoButton.icon = UIImage(named: "icon-plus")!
      self.addPhotoButton.textIndent = 0.0
    }
  }
  
  // MARK: - Actions
  
  func prevController() {
    print("Action: Previous Controller")
    navigationController?.popViewControllerAnimated(true)
  }
  
  func nextController() {
    print("Action: Next Controller")
    saveCheckIn()
    if facebookCheckBox.selected { CheckInServiceHandler().checkIn(locationData, services: CheckInService.Facebook) }
    if twitterCheckBox.selected { CheckInServiceHandler().checkIn(locationData, services: CheckInService.Twitter) }
    let checkInSuccessController = CheckInSuccessController()
    navigationController?.pushViewController(checkInSuccessController, animated: true)
  }
  
  func saveCheckIn() {
    if let checkIn = CheckInDataManager.sharedManager.checkIn {
      SavedCheckInHandler().save(checkIn)
    }
  }
  
  func addPhoto(sender: AnyObject) {
    if let _ = CheckInDataManager.sharedManager.checkIn!.image {
      CheckInDataManager.sharedManager.checkIn!.image = nil
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
}
