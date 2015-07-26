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
    view.addSubview(self.socialView)
    
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Top, relatedBy: .Equal, toItem: self.informationDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.socialView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Configure Interface
  
  func configureInterface() {
    view.backgroundColor = Colors().White
    
    view.addSubview(navigationBar)
    view.addSubview(contentView)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
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