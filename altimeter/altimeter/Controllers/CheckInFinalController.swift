//
//  CheckInController.swift
//  altimeter
//
//  Created by Beau Hankins on 24/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import Photos
import ReachabilitySwift

class CheckInFinalController: UIViewController {
  // MARK: - Variables & Constants
  
  let checkIn: CheckIn
  let reachability: Reachability?
  
  // Mutable Constraints
  var successViewTop = NSLayoutConstraint()
  var successViewBottom = NSLayoutConstraint()
  var accountPickerTop = NSLayoutConstraint()
  var accountPickerBottom = NSLayoutConstraint()
  
  lazy var navigationBar: NavigationBar = {
    let nav = NavigationBar()
    nav.translatesAutoresizingMaskIntoConstraints = false
    nav.titleLabel.text = "Check-In"
    nav.titleLabel.textColor = Colors().Black
    nav.leftBarItem.text = "Back"
    nav.leftBarItem.color = Colors().Black
    nav.leftBarItem.addTarget(self, action: "prevController", forControlEvents: UIControlEvents.TouchUpInside)
    nav.rightBarItem.text = "Share"
    nav.rightBarItem.type = .Emphasis
    nav.rightBarItem.color = Colors().PictonBlue
    nav.rightBarItem.addTarget(self, action: "shareCheckIn", forControlEvents: UIControlEvents.TouchUpInside)
    return nav
  }()
  
  lazy var serviceStatusBar: StatusBar = {
    let statusBar = StatusBar()
    statusBar.translatesAutoresizingMaskIntoConstraints = false
    statusBar.text = "NO SERVICE"
    statusBar.hidden = true
    return statusBar
  }()
  
  lazy var informationDetailView: InformationDetailView = {
    let view = InformationDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    let altitude = self.checkIn.location.altitude.doubleValue
    let altitudeString = String(format: "%.0f", round(altitude))
    if let placeName = self.checkIn.place?.name {
      view.title = "\(placeName) – \(altitudeString) \(UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString)"
    } else {
      view.title = "\(altitudeString) \(UserSettings.sharedSettings.unit.distanceAbbreviation().uppercaseString)"
    }
    
    view.titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
    view.style = .Gradient
    view.icon = UIImage(named: "icon-location-white")
    return view
  }()
  
  lazy var locationDataDetailView: LocationDataDetailView = {
    let view = LocationDataDetailView(checkIn: self.checkIn)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.checkIn = self.checkIn
    return view
  }()
  
  lazy var addPhotoButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Add Photo"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().PictonBlue
    listControl.icon = UIImage(named: "icon-plus")!
    if let thumbnail = self.checkIn.photoId {
      listControl.image = UIImage()
    }
    listControl.addTarget(self, action: Selector("addPhoto"), forControlEvents: .TouchUpInside)
    return listControl
  }()
  
  lazy var facebookCheckBox: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Facebook"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Black
    listControl.checkboxImage = UIImage(named: "radio-facebook")!
    listControl.showCheckBox = true
    listControl.addTarget(self, action: Selector("facebookCheckBoxPressed"), forControlEvents: .TouchUpInside)
    listControl.hidden = false
    return listControl
  }()
  
  lazy var twitterCheckBox: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.text = "Twitter"
    listControl.textLabel.font = Fonts().Heading
    listControl.textColor = Colors().Black
    listControl.checkboxImage = UIImage(named: "radio-twitter")!
    listControl.showCheckBox = true
    listControl.addTarget(self, action: Selector("twitterCheckBoxPressed"), forControlEvents: .TouchUpInside)
    listControl.hidden = false
    return listControl
  }()
  
  lazy var saveButton: ListControl = {
    let listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.stateText = "Save Check-In"
    listControl.addTarget(self, action: Selector("saveCheckIn"), forControlEvents: .TouchUpInside)
    return listControl
  }()
  
  lazy var successView: InformationDetailView = {
    let view = InformationDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.title = "Saved Successfully!"
    view.backgroundColor = Colors().PictonBlue
    view.style = .Default
    view.textColor = Colors().White
    view.titleLabel.font = Fonts().Default
    view.icon = UIImage(named: "radio-whiteChecked")
    return view
  }()
  
  lazy var accountPicker: ActionSheet = {
    let actionSheet = ActionSheet()
    actionSheet.translatesAutoresizingMaskIntoConstraints = false
    actionSheet.title = "Select Account".uppercaseString
    actionSheet.doneButton.addTarget(self, action: Selector("hideAccountPicker"), forControlEvents: .TouchUpInside)
    return actionSheet
  }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors().White
    
    view.addSubview(self.navigationBar)
    view.addSubview(self.serviceStatusBar)
    view.addSubview(self.informationDetailView)
    view.addSubview(self.locationDataDetailView)
    view.addSubview(self.addPhotoButton)
    view.addSubview(self.facebookCheckBox)
    view.addSubview(self.twitterCheckBox)
    view.addSubview(self.saveButton)
    
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 86))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.serviceStatusBar, attribute: .Top, relatedBy: .Equal, toItem: self.navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: self.informationDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.serviceStatusBar, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.locationDataDetailView, attribute: .Top, relatedBy: .Equal, toItem: self.informationDetailView, attribute: .Bottom, multiplier: 1, constant: 0))

    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.addPhotoButton, attribute: .Top, relatedBy: .Equal, toItem: self.locationDataDetailView, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 10))
    view.addConstraint(NSLayoutConstraint(item: self.facebookCheckBox, attribute: .Top, relatedBy: .Equal, toItem: self.addPhotoButton, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 10))
    view.addConstraint(NSLayoutConstraint(item: self.twitterCheckBox, attribute: .Top, relatedBy: .Equal, toItem: self.addPhotoButton, attribute: .Bottom, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.saveButton, attribute: .Top, relatedBy: .Equal, toItem: self.facebookCheckBox, attribute: .Bottom, multiplier: 1, constant: 0))
    
    return view
    }()
  
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
  
  override func viewWillAppear(animated: Bool) {
    updateThumbnail()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  // MARK: - Layout Interface
  
  func layoutInterface() {
    view.backgroundColor = Colors().Black
    view.layer.masksToBounds = true
    
    view.addSubview(contentView)
    view.addSubview(successView)
    view.addSubview(accountPicker)
    
    successViewTop = NSLayoutConstraint(item: successView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    successViewBottom = NSLayoutConstraint(item: successView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    accountPickerTop = NSLayoutConstraint(item: accountPicker, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    accountPickerBottom = NSLayoutConstraint(item: accountPicker, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(successViewTop)
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: successView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(accountPickerTop)
    view.addConstraint(NSLayoutConstraint(item: accountPicker, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: accountPicker, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    navigationBar.rightBarItem.enabled = canContinue()
    serviceDidChange(serviceIsAvailable())
  }
  
  func updateThumbnail() {
    if let photoId = checkIn.photoId as? String {
      fetchPhoto(photoId) {
        image in
        self.addPhotoButton.image = image
        self.addPhotoButton.text = "Remove Photo"
        self.addPhotoButton.icon = nil
        self.addPhotoButton.setNeedsLayout()
        self.addPhotoButton.layoutIfNeeded()
      }
    } else {
      self.addPhotoButton.image = nil
      self.addPhotoButton.text = "Add Photo"
      self.addPhotoButton.icon = UIImage(named: "icon-plus")!
      self.addPhotoButton.setNeedsLayout()
      self.addPhotoButton.layoutIfNeeded()
    }
  }
  
  func serviceDidChange(serviceIsAvailable: Bool) {
    self.serviceStatusBar.hidden = serviceIsAvailable
    self.facebookCheckBox.hidden = !serviceIsAvailable
    self.twitterCheckBox.hidden = !serviceIsAvailable
    
    self.serviceStatusBar.setNeedsLayout()
    self.facebookCheckBox.setNeedsLayout()
    self.twitterCheckBox.setNeedsLayout()
    
    self.serviceStatusBar.layoutIfNeeded()
    self.facebookCheckBox.layoutIfNeeded()
    self.twitterCheckBox.layoutIfNeeded()
  }
  
  // MARK: - Animations
  
  func flashSuccessView(success success: Bool = true, completion: (() -> Void)? = nil) {
    if success {
      self.successView.title = "Saved Successfully!"
      self.successView.backgroundColor = Colors().PictonBlue
    } else {
      self.successView.title = "Already Saved"
      self.successView.backgroundColor = Colors().LavendarGrey
    }
    
    view.removeConstraint(self.successViewTop)
    view.addConstraint(self.successViewBottom)
    self.successView.setNeedsUpdateConstraints()
    
    UIView.animateWithDuration(0.5, animations: { () in
      self.successView.layoutIfNeeded()
      }) { _ in
        self.view.removeConstraint(self.successViewBottom)
        self.view.addConstraint(self.successViewTop)
        self.successView.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.5, delay: 2.5, options: .CurveEaseInOut, animations: { () in
          self.successView.layoutIfNeeded()
          }, completion: { _ in
            guard let completion = completion else { return }
            completion()
        })
    }
  }
  
  func showAccountPicker() {
    view.removeConstraint(self.accountPickerTop)
    view.addConstraint(self.accountPickerBottom)
    self.accountPicker.setNeedsUpdateConstraints()
    
    UIView.animateWithDuration(0.25) { () in
      self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9)
      self.contentView.alpha = 0.2
      self.contentView.userInteractionEnabled = false
      self.accountPicker.layoutIfNeeded()
    }
  }
  
  func hideAccountPicker() {
    view.removeConstraint(self.accountPickerBottom)
    view.addConstraint(self.accountPickerTop)
    self.accountPicker.setNeedsUpdateConstraints()
    
    UIView.animateWithDuration(0.25) { () in
      self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      self.contentView.alpha = 1.0
      self.contentView.userInteractionEnabled = true
      self.accountPicker.layoutIfNeeded()
    }
  }
  
  // MARK: - Actions
  
  func prevController() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func shareCheckIn() {
    let alerts = NSMutableArray()
    
    self.navigationBar.rightBarItem.isLoading = true
    
    SavedCheckInHandler().save(checkIn)
    
    if facebookCheckBox.selected {
      CheckInServiceHandler(checkIn: checkIn).checkIn(.Facebook, success: { () -> Void in
        self.nextController()
        
        }, failure: { () in
          self.navigationBar.rightBarItem.isLoading = false
          
          let alertController = UIAlertController(
                                  title: "Post to Facebook Failed",
                                  message: "You are not logged in to Facebook. Update your details in Settings > Facebook.",
                                  preferredStyle: .Alert)
          
          let okButton = UIAlertAction(title: "👍", style: .Cancel) {
            action in
            if alerts.count > 1 {
              alerts.removeObjectAtIndex(0)
              let alert = alerts[0] as! UIAlertController
              
              self.presentViewController(alert, animated: true, completion: nil)
            }
          }
          alertController.addAction(okButton)
          
          if alerts.count == 0 {
            self.presentViewController(alertController, animated: true, completion: nil)
          }
          
          alerts.addObject(alertController)
      })
    }
    
    if twitterCheckBox.selected {
      CheckInServiceHandler(checkIn: checkIn).checkIn(.Twitter, success: { () -> Void in
        self.nextController()
        
        }, failure: { () in
          self.navigationBar.rightBarItem.isLoading = false
          
          let alertController = UIAlertController(
                                  title: "Tweet Failed",
                                  message: "You are not logged in to Twitter. Update your details in Settings > Twitter.",
                                  preferredStyle: .Alert)
          
          let okButton = UIAlertAction(title: "👍", style: .Cancel) {
            action in
            if alerts.count > 1 {
              alerts.removeObjectAtIndex(0)
              let alert = alerts[0] as! UIAlertController
              
              self.presentViewController(alert, animated: true, completion: nil)
            }
          }
          alertController.addAction(okButton)
          
          if alerts.count == 0 {
            self.presentViewController(alertController, animated: true, completion: nil)
          }
          
          alerts.addObject(alertController)
      })
      
    }
  }
  
  func saveCheckIn() {
    self.saveButton.enabled = false
    
    SavedCheckInHandler().save(checkIn, completion: { () in
      self.flashSuccessView() { () in
        self.saveButton.enabled = true
      }
      }, failure:  { () in
        self.flashSuccessView(success: false) { () in
          self.saveButton.enabled = true
        }
    })
  }
  
  func nextController() {
    navigationBar.rightBarItem.isLoading = false
    let checkInSuccessController = CheckInSuccessController(checkIn: self.checkIn)
    self.navigationController?.pushViewController(checkInSuccessController, animated: true)
  }
  
  func addPhoto() {
    guard let _ = checkIn.photoId else { photoGridController(); return }
    
    checkIn.photoId = nil
    updateThumbnail()
  }
  
  func twitterCheckBoxPressed() {
    twitterCheckBox.selected = !twitterCheckBox.selected
    navigationBar.rightBarItem.enabled = canContinue()
    
    if twitterCheckBox.selected { showAccountPicker() }
  }
  
  func facebookCheckBoxPressed() {
    facebookCheckBox.selected = !facebookCheckBox.selected
    navigationBar.rightBarItem.enabled = canContinue()
  }
  
  func photoGridController() {
    let photoGridController = PhotoGridController(checkIn: checkIn)
    photoGridController.modalTransitionStyle = .CoverVertical
    presentViewController(photoGridController, animated: true, completion: nil)
  }
  
  // MARK: - Validation
  
  func canContinue() -> Bool {
    return facebookCheckBox.selected || twitterCheckBox.selected
  }
  
  func serviceIsAvailable() -> Bool {
    return reachability?.isReachable() ?? false
  }
  
  func startMonitoringReachability() {
    guard let reachability = reachability else { return }
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "reachabilityChanged:",
      name: ReachabilityChangedNotification,
      object: reachability)
    
    do {
      try reachability.startNotifier()
    } catch {}
  }
  
  func reachabilityChanged(note: NSNotification) {
    let reachability = note.object as! Reachability
    dispatch_async(dispatch_get_main_queue()) { () in
      self.serviceDidChange(reachability.isReachable())
    }
  }
  
  // MARK: - Photos
  
  private func fetchPhoto(localIdentifier: String, completion: ((image: UIImage) -> Void)) {
    let results = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier as String], options: nil)
    var assets: [PHAsset] = []
    results.enumerateObjectsUsingBlock {
      object, _, _ in
      if let asset = object as? PHAsset {
        assets.append(asset)
      }
    }
    
    if let asset = assets.first {
      let options = PHImageRequestOptions()
      options.deliveryMode = .FastFormat
      
      let imageManager = PHImageManager.defaultManager()
      imageManager.requestImageForAsset(asset,
        targetSize: PHImageManagerMaximumSize,
        contentMode: .AspectFit,
        options: options) {
          image, _ in
          if let image = image {
            completion(image: image)
          }
      }
    }
  }
}
