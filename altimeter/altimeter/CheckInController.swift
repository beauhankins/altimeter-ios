//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 24/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class CheckInController: UIViewController {
  // MARK: - Variables & Constants
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Check-In"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Cancel"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: "closeController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Next"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().Primary
    nav.rightBarItem.addTarget(self, action: "nextController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
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
  
  func closeController() {
    print("Action: Close Controller")
    navigationController?.popViewControllerAnimated(true)
  }
  
  func nextController() {
    print("Action: Next Controller")
    let checkInFinalController = CheckInFinalController()
    navigationController?.pushViewController(checkInFinalController, animated: true)
  }
  
  func canContinue() -> Bool {
    return true
  }
}