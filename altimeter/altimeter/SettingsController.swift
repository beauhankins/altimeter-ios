//
//  SettingsController.swift
//  altimeter
//
//  Created by Beau Hankins on 23/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController {
  // MARK: - Variables & Constants
  
  var unit: Unit = UserSettings.sharedSettings.unit
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Settings"
    nav.leftBarItem.icon = UIImage(named: "icon-close")
    nav.leftBarItem.addTarget(self, action: "closeController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "app-icon-settings")
    imageView.layer.cornerRadius = 16.0
    imageView.layer.masksToBounds = true
    return imageView
    }()
  
  lazy var versionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Caption
    label.textAlignment = .Center
    label.textColor = Colors().White
    label.text = NSString(format: "Version %@", NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String) as String
    return label
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    print(UserSettings.sharedSettings.unit.abbreviation())
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Configure Interface
  
  func configureInterface() {
    view.backgroundColor = Colors().Black.colorWithAlphaComponent(0.9)
    
    view.addSubview(navigationBar)
    view.addSubview(iconImageView)
    view.addSubview(versionLabel)
    
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 52))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Top, relatedBy: .Equal, toItem: iconImageView, attribute: .Bottom, multiplier: 1, constant: 11))
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
  }
  
  // MARK: - Actions
  
  func closeController() {
    print("Action: Close Controller")
    dismissViewControllerAnimated(true, completion: nil)
    saveUserSettings()
  }
  
  // MARK: - Settings
  
  func saveUserSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    UserSettings.sharedSettings.unit = unit
    
    defaults.setInteger(UserSettings.sharedSettings.unit.rawValue, forKey: "settings_unit")
  }
}
