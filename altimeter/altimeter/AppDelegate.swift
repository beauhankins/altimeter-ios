//
//  AppDelegate.swift
//  altimeter
//
//  Created by Beau Hankins on 12/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    MagicalRecord.setupAutoMigratingCoreDataStack()
    
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
  
  func applicationWillTerminate(application: UIApplication) {
    MagicalRecord.cleanUp()
  }
  
  func fetchUserSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    UserSettings.sharedSettings.unit = Unit(rawValue: defaults.integerForKey("settings_unit"))!
    
    defaults.setInteger(UserSettings.sharedSettings.unit.rawValue, forKey: "settings_unit")
  }
}

