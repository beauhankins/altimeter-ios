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
  
  func settingsStackItem(text: String?, selectedText: String?, selected: Bool, selector: Selector?) -> StackViewItem {
    let stackItem: StackViewItem = {
      let view = StackViewItem()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.text = text
      view.textColor = Colors().White
      view.selectedText = selectedText
      view.selected = selected
      if selector != nil { view.addTarget(self, action: selector!, forControlEvents: .TouchUpInside) }
      return view
      }()
    return stackItem
  }
  
  @available(iOS 9.0, *)
  lazy var settingsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = UIStackViewAlignment.Fill
    stackView.distribution = UIStackViewDistribution.EqualCentering
    stackView.axis = .Vertical
    
    stackView.addArrangedSubview(self.settingsStackItem("Units: \(Unit.Feet.abbreviation())", selectedText: "Units: \(Unit.Meters.abbreviation())", selected: (self.unit == .Meters), selector: Selector("toggleUnits:")))
    stackView.addArrangedSubview(self.settingsStackItem("Send Feedback", selectedText: nil, selected: false, selector: Selector("sendFeedback")))
    stackView.addArrangedSubview(self.settingsStackItem("Rate in the App Store", selectedText: nil, selected: false, selector: Selector("openInAppStore")))
    
    return stackView
    }()
  
  lazy var settingsStackViewLegacy: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    configureInterface()
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
    
    let settingsListView: UIView = {
        if #available(iOS 9.0, *) {
          return settingsStackView
        } else {
          return settingsStackViewLegacy
        }
      }()
    
    view.addSubview(settingsListView)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 52))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Top, relatedBy: .Equal, toItem: iconImageView, attribute: .Bottom, multiplier: 1, constant: 11))
    
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: -20))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 64*3))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -20))
  }
  
  // MARK: - Actions
  
  func closeController() {
    print("Action: Close Controller")
    dismissViewControllerAnimated(true, completion: nil)
    saveUserSettings()
  }
  
  func toggleUnits(sender: AnyObject?) {
    unit = unit == .Feet ? .Meters : .Feet
    let item = sender as! StackViewItem
    item.selected = unit == .Meters
  }
  
  func sendFeedback() {
    print("Send Feedback")
  }
  
  func openInAppStore() {
    print("Open In App Store")
  }
  
  // MARK: - Settings
  
  func saveUserSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    UserSettings.sharedSettings.unit = unit
    
    defaults.setInteger(UserSettings.sharedSettings.unit.rawValue, forKey: "settings_unit")
  }
}
