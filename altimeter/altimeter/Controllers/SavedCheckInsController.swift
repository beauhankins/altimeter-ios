//
//  SavedCheckInsController.swift
//  altimeter
//
//  Created by Beau Hankins on 18/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class SavedCheckInsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  // MARK: - Variables & Constants
  
  let savedCheckIns = SavedCheckInHandler().allSavedCheckIns()
  
  var selectedRow: Int?
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Saved"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Cancel"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: "prevController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Next"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().Primary
    nav.rightBarItem.addTarget(self, action: "nextController", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var savedCheckInsListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.view.bounds.width - 20, 64)
    
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(ListCell.self, forCellWithReuseIdentifier: "SavedListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    
    return collectionView
    }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self.savedCheckInsListView)
    
    view.addConstraint(NSLayoutConstraint(item: self.savedCheckInsListView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.savedCheckInsListView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.savedCheckInsListView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.savedCheckInsListView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    
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
  
  // MARK: - CollectionView Delegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    
    cell.selected = true
    selectedRow = indexPath.row
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    cell.selected = false
  }
  
  // MARK: - CollectionView Delegate Flow Layout
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  // MARK: - CollectionView Data Source
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedCheckIns.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.showCheckBox = true
    cell.textColor = Colors().Black
    
    let checkIn = savedCheckIns[row]
    
    if let locationData = checkIn.locationData {
      cell.text = "\(round(UserSettings.sharedSettings.unit.convertDistance(locationData.altitude)))\(UserSettings.sharedSettings.unit.distanceAbbreviation())"
    }
    
    if let timestamp = checkIn.timestamp {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEEE dd/MM/yyyy"
      let dateString = dateFormatter.stringFromDate(timestamp)
      let timeFormatter = NSDateFormatter()
      timeFormatter.dateFormat = "hh:mma"
      let timeString = timeFormatter.stringFromDate(timestamp)
      
      cell.subtext = String("\(timeString.substringToIndex(timeString.endIndex.predecessor())) at \(dateString)")
    }
    
    if let imageData = checkIn.image {
      cell.image = UIImage(data: imageData)
    }
    
    return cell
  }
  
  // MARK: - Actions
  
  func prevController() {
    print("Action: Previous Controller")
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func nextController() {
    print("Action: Next Controller")
    CheckInDataManager.sharedManager.checkIn = savedCheckIns[selectedRow!]
    let checkInFinalController = CheckInFinalController()
    navigationController?.pushViewController(checkInFinalController, animated: true)
  }
  
  // MARK: - Validation
  
  func canContinue() -> Bool {
    return selectedRow != nil
  }
}
