//
//  SettingsController.swift
//  altimeter
//
//  Created by Beau Hankins on 23/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import SafariServices

class SettingsController: UIViewController {
  // MARK: - Variables & Constants
  
  var unit: Unit = UserSettings.sharedSettings.unit
  
  var settingsListItems: [[String:String]] {
    return [[
      "text": "Units",
      "state": unit.description(),
      "action": "toggleUnits"
    ], [
      "text": "Send feedback",
      "action": "openFeedback"
    ], [
      "text": "Rate in the App Store",
      "action": "openInAppStore"
    ]]
  }
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Settings"
    nav.leftBarItem.icon = UIImage(named: "icon-close")
    nav.leftBarItem.addTarget(self, action: #selector(closeController), forControlEvents: UIControlEvents.TouchUpInside)
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
  
  lazy var settingsListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.view.bounds.width, 64)
    
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(ListCell.self, forCellWithReuseIdentifier: "SettingsListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    return collectionView
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    layoutInterface()
    settingsListView.reloadData()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
    view.backgroundColor = Colors().Black.colorWithAlphaComponent(0.9)
    
    view.addSubview(navigationBar)
    view.addSubview(iconImageView)
    view.addSubview(versionLabel)
    view.addSubview(settingsListView)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 52))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: versionLabel, attribute: .Top, relatedBy: .Equal, toItem: iconImageView, attribute: .Bottom, multiplier: 1, constant: 11))
    
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -20))
    view.addConstraint(NSLayoutConstraint(item: settingsListView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(64*settingsListItems.count+1)))
  }
  
  // MARK: - Actions
  
  func closeController() {
    dismissViewControllerAnimated(true, completion: nil)
    saveUserSettings()
  }
  
  func toggleUnits() {
    unit = unit == .Imperial ? .Metric : .Imperial
    UserSettings.sharedSettings.unit = unit
    settingsListView.reloadData()
  }
  
  func openFeedback() {
    let urlString = "http://goo.gl/forms/lRPWNFy1Lx8G6a522"
    if #available(iOS 9.0, *) {
      let safariViewController = SFSafariViewController(URL: NSURL(string: urlString)!)
      self.presentViewController(safariViewController, animated: true, completion: nil)
    } else {
      UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
  }
  
  func openInAppStore() {
    let urlString = "itms://itunes.apple.com/us/app/altimeter-simple-precise-altitude/id1066240359"
    
    UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
  }
  
  // MARK: - Settings
  
  func saveUserSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setInteger(UserSettings.sharedSettings.unit.rawValue, forKey: "settings_unit")
  }
}

// MARK: - UICollectionViewDelegate

extension SettingsController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let row = indexPath.row
    
    if let action = settingsListItems[row]["action"] {
      NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: Selector(action), userInfo: nil, repeats: false)
    }
  }
  
  func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    
    cell.textColor = Colors().PictonBlue
  }
  
  func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    
    cell.textColor = Colors().White
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingsController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UICollectionViewDataSource

extension SettingsController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settingsListItems.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SettingsListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.textColor = Colors().White
    
    if let text = settingsListItems[row]["text"] { cell.text = text }
    if let state = settingsListItems[row]["state"] { cell.stateText = state }
    else { cell.stateText = "" }
    
    return cell
  }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsController: MFMailComposeViewControllerDelegate {
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}
