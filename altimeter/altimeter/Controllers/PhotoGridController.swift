//
//  PhotoGridController.swift
//  altimeter
//
//  Created by Beau Hankins on 9/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PhotoGridController: UIViewController {
  // MARK: - Variables & Constants

  var photos: NSMutableArray?
  var selectedPhotoURL: NSURL?

  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Camera Roll"
    nav.titleLabel.textColor = Colors().White
    nav.leftBarItem.text = "Cancel"
    nav.leftBarItem.color = Colors().White
    nav.leftBarItem.addTarget(self, action: "closeController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Done"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().Primary
    nav.rightBarItem.addTarget(self, action: "done:", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
    }()
  
  lazy var photoGridView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    layout.itemSize = CGSizeMake((self.view.bounds.width - 12) / 3, (self.view.bounds.width - 12) / 3)
    
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(PhotoGridCell.self, forCellWithReuseIdentifier: "PhotoGridCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    return collectionView
    }()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureInterface()
    preparePhotos()
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }

  // MARK: - Photos

  func preparePhotos() {
    photos = NSMutableArray()
    let library = ALAssetsLibrary()
    library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group: ALAssetsGroup?, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
      if let assets = group {
        assets.enumerateAssetsUsingBlock({ (result: ALAsset?, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
          if let photo = result {
            self.photos?.addObject(photo.defaultRepresentation().url())
          }
        })
      }
      
      if ( stop.memory.boolValue ) {
        self.photoGridView.reloadData()
      }
      
    }) { (error: NSError!) -> Void in
      
    }
  }
  
  // MARK: - Configure Interface
  
  func configureInterface() {
    view.backgroundColor = Colors().Black
    
    view.addSubview(navigationBar)
    view.addSubview(photoGridView)
    
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))

    view.addConstraint(NSLayoutConstraint(item: photoGridView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: photoGridView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: photoGridView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: photoGridView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  // MARK: - Actions
  
  func closeController() {
    print("Action: Close Controller")
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func done(sender: AnyObject) {
    let library = ALAssetsLibrary()
    library.assetForURL(selectedPhotoURL, resultBlock: { (asset: ALAsset?) -> Void in
      if let photo = asset {

        let image = UIImage(CGImage: photo.thumbnail().takeUnretainedValue())
        let imageData = UIImageJPEGRepresentation(image, 1.0)

        CheckInDataManager.sharedManager.checkIn?.image = imageData
      }
      }) { (error: NSError!) -> Void in
        
    }
    closeController()
  }
  
  func canContinue() -> Bool {
    return selectedPhotoURL != nil
  }
}

extension PhotoGridController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  // MARK: - CollectionView Delegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoGridCell

    cell.selected = true
    selectedPhotoURL = photos?.objectAtIndex(indexPath.row) as? NSURL
    
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  // MARK: - CollectionView Delegate Flow Layout
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 3
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 3
  }
  
  // MARK: - CollectionView Data Source
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos!.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoGridCell", forIndexPath: indexPath) as! PhotoGridCell
    let row = indexPath.row
    
    cell.backgroundColor = Colors().White

    let library = ALAssetsLibrary()
    library.assetForURL(photos?.objectAtIndex(row) as! NSURL, resultBlock: { (asset: ALAsset?) -> Void in
      if let photo = asset {
        cell.image = UIImage(CGImage: photo.thumbnail().takeUnretainedValue())
      }
    }) { (error: NSError!) -> Void in
        
    }

    return cell
  }
}
