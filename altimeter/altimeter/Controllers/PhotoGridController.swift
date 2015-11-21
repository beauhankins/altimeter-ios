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
  
  lazy var photoGridViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    layout.itemSize = CGSizeMake((self.view.bounds.width - 12) / 3, (self.view.bounds.width - 12) / 3)
    return layout
    }()
  
  lazy var photoGridView: UICollectionView = {
    let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.photoGridViewLayout)
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
    
    layoutInterface()
    preparePhotos()
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
            self.photos?.insertObject(UIImage(CGImage: photo.thumbnail().takeUnretainedValue()), atIndex: 0)
          }
        })
      }
      
      if stop.memory.boolValue {
        self.photoGridView.reloadData()
      }
      
    }) { (error: NSError!) -> Void in
      
    }
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
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
  
  func takePhoto() {
    let picker = UIImagePickerController()
    picker.sourceType = .Camera
    picker.cameraCaptureMode = .Photo
    picker.cameraDevice = .Rear
    picker.delegate = self
    picker.mediaTypes = [kUTTypeImage as String]
    self.presentViewController(picker, animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDelegate

extension PhotoGridController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let row = indexPath.row
    
    if (row < 1) {
      // Default camera
      selectedPhotoURL = nil
      takePhoto()
    } else {
      selectedPhotoURL = photos?.objectAtIndex(row - 1) as? NSURL
      navigationBar.rightBarItem.enabled = canContinue()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoGridController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 3
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 3
  }
}

// MARK: - UICollectionViewDataSource

extension PhotoGridController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos!.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoGridCell", forIndexPath: indexPath) as! PhotoGridCell
    let relativeRow = indexPath.row - 1
    
    if (relativeRow < 0) {
      cell.image = UIImage(named: "icon-camera")
      cell.imageMode = .Center
    } else {
      if let photos = photos {
        cell.image = photos.objectAtIndex(relativeRow) as? UIImage
      }
    }
    
    return cell
  }
}

// MARK: - UIImagePickerControllerDelegate

extension PhotoGridController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    
    let mediaType = info[UIImagePickerControllerMediaType] as! String
    
    if mediaType == kUTTypeImage as String {
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      preparePhotos()
    }
  }
}
