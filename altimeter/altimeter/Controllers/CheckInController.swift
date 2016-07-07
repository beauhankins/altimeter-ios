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
import ReachabilitySwift

class CheckInController: UIViewController {
  // MARK: - Variables & Constants
  
  let checkIn: CheckIn
  let reachability: Reachability?
  var places: [Place] = []
  var selectedPlace: Place?
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Check-In"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Cancel"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: #selector(closeController), forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Next"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().PictonBlue
    nav.rightBarItem.addTarget(self, action: #selector(nextController), forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()

  lazy var serviceStatusBar: StatusBar = {
    let statusBar = StatusBar()
    statusBar.translatesAutoresizingMaskIntoConstraints = false
    statusBar.text = "NO SERVICE"
    statusBar.hidden = true
    return statusBar
    }()
  
  lazy var placesListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.view.bounds.width, 64)
    
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(ListCell.self, forCellWithReuseIdentifier: "SearchListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    return collectionView
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
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(self.serviceStatusBar)
    view.addSubview(self.placesListView)
    view.addSubview(self.searchField)

    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.searchField, attribute: .Top, relatedBy: .Equal, toItem: self.serviceStatusBar, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.placesListView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.placesListView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.placesListView, attribute: .Top, relatedBy: .Equal, toItem: self.searchField, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.placesListView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
  lazy var savedButton: ListControl = {
    return self.newSavedButton()
    }()
  
  func newSavedButton() -> ListControl {
    let savedButton: ListControl = {
      let listControl = ListControl()
      listControl.translatesAutoresizingMaskIntoConstraints = false
      listControl.text = "View Saved Check-Ins"
      listControl.textLabel.font = Fonts().Heading
      listControl.textColor = Colors().PictonBlue
      listControl.icon = UIImage(named: "icon-location")!
      listControl.stateText = "\(SavedCheckInHandler().allSavedCheckIns().count)"
      listControl.stateTextColor = Colors().Black.colorWithAlphaComponent(0.5)
      listControl.topBorder = true
      listControl.backgroundColor = Colors().White
      listControl.addTarget(self, action: #selector(savedCheckInsController), forControlEvents: .TouchUpInside)
      return listControl
      }()
    
    return savedButton
  }
  
  func reloadSavedCounter() {
    self.savedButton.stateText = "\(SavedCheckInHandler().allSavedCheckIns().count)"
  }
  
  // MARK: - View Lifecycle
  
  init(checkIn: CheckIn) {
    self.checkIn = checkIn
    do {
      self.reachability = try Reachability.reachabilityForInternetConnection()
    } catch {
      self.reachability = nil
    }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience required init?(coder aDecoder: NSCoder) {
    let checkIn = CheckIn.create() as! CheckIn
    
    self.init(checkIn: checkIn)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layoutInterface()
    startMonitoringReachability()
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
    
    updateRightNavigationBarItem()
    serviceDidChange(serviceIsAvailable())
  }
  
  func updateRightNavigationBarItem() {
    navigationBar.rightBarItem.enabled = canContinue()
    navigationBar.rightBarItem.text = (selectedPlace != nil) ? "Next" : "Skip"
  }

  func serviceDidChange(serviceIsAvailable: Bool) {
    self.serviceStatusBar.hidden = serviceIsAvailable
    self.searchField.enabled = serviceIsAvailable
    
    self.serviceStatusBar.setNeedsLayout()
    self.serviceStatusBar.layoutIfNeeded()
  }
  
  // MARK: - Search Filter
  
  func queryDidChange(query: String) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    PlaceSearchHandler().getPlaces(query, completion: {
      places -> Void in
      self.places = places
      self.placesListView.reloadData()
      self.selectedPlace = nil
      self.updateRightNavigationBarItem()
      
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      }) {
        error -> Void in
        if let error = error {
          print(error)
        } else {
          print("No results for location search query")
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  }
  
  // MARK: - Actions
  
  func closeController() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func nextController() {
    if let place = selectedPlace {
      checkIn.place = place
    }
        
    let checkInFinalController = CheckInFinalController(checkIn: checkIn, onDisappear: { () in
      self.reloadSavedCounter()
    })
    navigationController?.pushViewController(checkInFinalController, animated: true)
  }
  
  func savedCheckInsController() {
    let savedCheckInsController = UINavigationController(rootViewController: SavedCheckInsController(onDisappear: { () in
      self.reloadSavedCounter()
    }))
    savedCheckInsController.navigationBarHidden = true
    
    savedCheckInsController.modalTransitionStyle = .CoverVertical
    savedCheckInsController.modalPresentationStyle = .Custom
    
    let savedButton_copy = newSavedButton()
    
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

  func serviceIsAvailable() -> Bool {
    return reachability?.isReachable() ?? false
  }
  
  func startMonitoringReachability() {
    guard let reachability = reachability else { return }
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(reachabilityChanged(_:)),
      name: ReachabilityChangedNotification,
      object: reachability)
    
    do {
      try reachability.startNotifier()
    } catch {}
  }
  
  func reachabilityChanged(note: NSNotification) {
    let reachability = note.object as! Reachability
    dispatch_async(dispatch_get_main_queue()) {
      () in
      self.serviceDidChange(reachability.isReachable())
    }
  }
}

// MARK: - UICollectionViewDelegate

extension CheckInController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    let row = indexPath.row
    
    cell.selected = true
    
    selectedPlace = places[row]
    updateRightNavigationBarItem()
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
    return places.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.showCheckBox = true
    cell.textColor = Colors().Black
    
    cell.text = String(places[row].name)
    
    let location = checkIn.location
    
    let coordinate = places[row].coordinate
    
    let placeLocation = CLLocation(
      latitude: coordinate.latitude.doubleValue,
      longitude: coordinate.longitude.doubleValue)
    let distance = placeLocation.distanceFromLocation(CLLocation(
      latitude: location.coordinate.latitude.doubleValue,
      longitude: location.coordinate.longitude.doubleValue))
    cell.subtext = "\(Int(UserSettings.sharedSettings.unit.dynamicDistance(distance))) \(UserSettings.sharedSettings.unit.dynamicDistanceAbbreviation(distance).uppercaseString)"
    
    return cell
  }
}

// MARK: - UITextFieldDelegate

extension CheckInController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let text = textField.text
    NSObject.cancelPreviousPerformRequestsWithTarget(self)
    performSelector(#selector(queryDidChange(_:)), withObject: text, afterDelay: 0.3)
    return true
  }
}
