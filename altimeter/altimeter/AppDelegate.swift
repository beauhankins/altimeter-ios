//
//  AppDelegate.swift
//  altimeter
//
//  Created by Beau Hankins on 12/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    fetchUserSettings()
    
    window = {
      let win = UIWindow(frame: UIScreen.mainScreen().bounds)
      win.backgroundColor = UIColor.whiteColor()
      let navigationController = UINavigationController(rootViewController: MainController())
      navigationController.navigationBarHidden = true
      win.rootViewController = navigationController
      return win
      }()
    
    window!.makeKeyAndVisible()
    
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func fetchUserSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    UserSettings.sharedSettings.unit = Unit(rawValue: defaults.integerForKey("settings_unit"))!
    
    defaults.setInteger(UserSettings.sharedSettings.unit.rawValue, forKey: "settings_unit")
  }
}

