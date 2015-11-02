//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 24/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CheckInController: UIViewController {
  // MARK: - Variables & Constants
  
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  
  let dummySearchResults: [[String:AnyObject]] = [
      [
        "location":"Lair O\' The Bear Park",
        "latitude":38.898556,
        "longitude":-77.037852
      ],
      [
        "location":"Deer Creek Canyon",
        "latitude":37.898556,
        "longitude":-76.037852
      ],
      [
        "location":"Lookout Mountain",
        "latitude":36.898556,
        "longitude":-75.037852
      ],
    ]
  
  var searchResults:[[String:AnyObject]] = []
  
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
  
  lazy var searchField: ListField = {
    let listField = ListField()
    listField.translatesAutoresizingMaskIntoConstraints = false
    listField.attributedPlaceholder = NSAttributedString(
      string: "Search for places...",
      attributes: [NSForegroundColorAttributeName: Colors().White])
    listField.font = Fonts().Heading
    listField.delegate = self
    return listField
    }()
  
  lazy var searchResultsListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.view.bounds.width - 20, 64)
    
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(ListCell.self, forCellWithReuseIdentifier: "SearchListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    return collectionView
    }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self.searchResultsListView)
    view.addSubview(self.searchField)
    
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.searchResultsListView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchResultsListView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchResultsListView, attribute: .Top, relatedBy: .Equal, toItem: self.searchField, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchResultsListView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
  lazy var savedButton: CounterButton = {
    let counterButton = CounterButton()
    counterButton.translatesAutoresizingMaskIntoConstraints = false
    counterButton.text = "View Saved Check-In's"
    counterButton.counterValue = SavedCheckIn.MR_findAll().count
    counterButton.addTarget(self, action: Selector("savedCheckInsController"), forControlEvents: .TouchUpInside)
    return counterButton
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchResults = dummySearchResults
    
    layoutInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    locationManager.delegate = self
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
    view.backgroundColor = Colors().White
    
    view.addSubview(navigationBar)
    view.addSubview(contentView)
    view.addSubview(savedButton)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: savedButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: savedButton, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: savedButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: savedButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: savedButton, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  // MARK: - Search Filter
  
  func queryDidChange(query: String) {
    
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
  
  func savedCheckInsController() {
    print("Action: Saved Check-In's Controller")
    let savedCheckInsController = UINavigationController(rootViewController: SavedCheckInsController())
    savedCheckInsController.navigationBarHidden = true
    
    savedCheckInsController.modalTransitionStyle = .CoverVertical
    savedCheckInsController.modalPresentationStyle = .Custom
    
    let savedButton_copy: CounterButton = {
      let counterButton = CounterButton()
      counterButton.translatesAutoresizingMaskIntoConstraints = false
      counterButton.text = savedButton.text
      counterButton.counterValue = savedButton.counterValue
      return counterButton
      }()
    
    savedCheckInsController.view.addSubview(savedButton_copy)
    
    savedCheckInsController.view.addConstraint(NSLayoutConstraint(item: savedButton_copy, attribute: .Bottom, relatedBy: .Equal, toItem: savedCheckInsController.view, attribute: .Top, multiplier: 1, constant: 0))
    savedCheckInsController.view.addConstraint(NSLayoutConstraint(item: savedButton_copy, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    savedCheckInsController.view.addConstraint(NSLayoutConstraint(item: savedButton_copy, attribute: .Left, relatedBy: .Equal, toItem: savedCheckInsController.view, attribute: .Left, multiplier: 1, constant: 0))
    savedCheckInsController.view.addConstraint(NSLayoutConstraint(item: savedButton_copy, attribute: .Right, relatedBy: .Equal, toItem: savedCheckInsController.view, attribute: .Right, multiplier: 1, constant: 0))
    
    presentViewController(savedCheckInsController, animated: true, completion: nil)
  }
  
  func canContinue() -> Bool {
    return true
  }
}

// MARK: - UICollectionViewDelegate

extension CheckInController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    cell.selected = true
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    cell.selected = false
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CheckInController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UICollectionViewDataSource

extension CheckInController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.showCheckBox = true
    cell.textColor = Colors().Black
    
    if let locationName = searchResults[row]["location"] {
      cell.text = String(locationName)
    }
    if (userLocation != nil) {
      if let latitude = searchResults[row]["latitude"] as? Double, longitude = searchResults[row]["longitude"] as? Double  {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let distance = location.distanceFromLocation(userLocation!)
        cell.subtext = "\(Double(UserSettings.sharedSettings.unit.convertDistance(distance)))\(UserSettings.sharedSettings.unit.distanceAbbreviation()))"
      }
    }
    
    return cell
  }
}

extension CheckInController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text { queryDidChange(text) }
    return true
  }
}

// MARK: - CLLocationManagerDelegate

extension CheckInController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    userLocation = locations.last!
  }
}