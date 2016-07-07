//
//  SavedCheckInsController.swift
//  altimeter
//
//  Created by Beau Hankins on 18/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Dollar

class SavedCheckInsController: UIViewController {
  // MARK: - Variables & Constants
  
  let onDisappear: (() -> Void)?
  var savedCheckIns = SavedCheckInHandler().allSavedCheckIns()
  
  let cachingImageManager = PHCachingImageManager()
  var assets: [PHAsset] = [] {
    willSet {
      cachingImageManager.stopCachingImagesForAllAssets()
    }
    
    didSet {
      cachingImageManager.startCachingImagesForAssets(self.assets,
        targetSize: CGSize(width: 100.0, height: 100.0),
        contentMode: .AspectFill,
        options: nil
      )
    }
  }
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Saved"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Cancel"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: #selector(prevController), forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var savedCheckInsListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.view.bounds.width, 64)
    
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
  
  init(onDisappear: (() -> Void)?) {
    self.onDisappear = onDisappear
    
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience required init?(coder aDecoder: NSCoder) {
    self.init(onDisappear: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layoutInterface()
  }
  
  override func viewWillAppear(animated: Bool) {
    prepareAssets({
      self.reloadData()
    })
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    guard let onDisappear = onDisappear else { return }
    onDisappear()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Photos
  
  func prepareAssets(completion: () -> Void) {
    assets = []
    
    let photoCheckIns = $.chain(savedCheckIns).filter {
      checkIn in
      return checkIn.photoId != nil
    }.value
    
    let localIdentifiers = $.map(photoCheckIns) { checkIn in
      return checkIn.photoId as! String
    }
    
    let results = PHAsset.fetchAssetsWithLocalIdentifiers(localIdentifiers, options: nil)
    results.enumerateObjectsUsingBlock { (object, _, _) in
      if let asset = object as? PHAsset {
        self.assets.append(asset)
      }
    }
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
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
  }
  
  func reloadData() {
    self.savedCheckIns = SavedCheckInHandler().allSavedCheckIns()
    self.savedCheckInsListView.reloadData()
  }
  
  // MARK: - Actions
  
  func prevController() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func nextController(selectedRow: Int) {
    let checkIn = savedCheckIns[selectedRow]
    let checkInFinalController = CheckInFinalController(checkIn: checkIn, onDisappear: { () in
      self.reloadData()
    })
    navigationController?.pushViewController(checkInFinalController, animated: true)
  }
}

// MARK: - UICollectionViewDelegate

extension SavedCheckInsController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let row = indexPath.row
    nextController(row)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SavedCheckInsController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UICollectionViewDataSource

extension SavedCheckInsController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedCheckIns.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.textColor = Colors().Black
    
    let checkIn = savedCheckIns[row]
    let altitude = UserSettings.sharedSettings.unit.convertDistance(checkIn.location.altitude.doubleValue)
    let altitudeString = String(format: "%.0f", round(altitude))
    
    cell.text = "\(altitudeString) \(UserSettings.sharedSettings.unit.distanceAbbreviation())"
      
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = .ShortStyle
    dateFormatter.timeStyle = .NoStyle
    dateFormatter.locale = NSLocale.currentLocale()
    let dateString = dateFormatter.stringFromDate(checkIn.dateCreated)
    
    let timeFormatter = NSDateFormatter()
    timeFormatter.dateStyle = .NoStyle
    timeFormatter.timeStyle = .ShortStyle
    timeFormatter.locale = NSLocale.currentLocale()
    let timeString = timeFormatter.stringFromDate(checkIn.dateCreated)
    
    cell.subtext = String("\(dateString) at \(timeString.substringToIndex(timeString.endIndex.predecessor()))")
    
    if let photoId = checkIn.photoId {
      let imageManager = PHImageManager.defaultManager()
      
      if cell.tag != 0 {
        imageManager.cancelImageRequest(PHImageRequestID(cell.tag))
      }
      
      let asset = $.find(assets) {
        asset -> Bool in
        return asset.localIdentifier == photoId
      } ?? PHAsset()
      
      let request = imageManager.requestImageForAsset(asset,
        targetSize: CGSize(width: 100.0, height: 100.0),
        contentMode: .AspectFill,
        options: nil) {
          image, _ in
          if let image = image {
            cell.image = image
          }
      }
      
      cell.tag = Int(request)
    }
    
    return cell
  }
}
