//
//  AccountPickerActionSheet.swift
//  altimeter
//
//  Created by Beau Hankins on 23/01/2016.
//  Copyright © 2016 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit
import Social

class AccountPickerActionSheet: ActionSheet {
  
  var accounts: [ACAccount] = [] {
    didSet {
      if accounts.count > 0 {
        self.loadingView.stopAnimating()
        self.contentView = self.accountListView
        self.contentHeight = CGFloat(accounts.count) * 64.0
      } else {
        self.loadingView.startAnimating()
        self.contentView = self.loadingView
        self.contentHeight = 64.0
      }
      self.accountListView.reloadData()
      setNeedsUpdateConstraints()
      layoutIfNeeded()
    }
  }
  var service: CheckInService = .Twitter
  var selectedAccount: ACAccount? {
    didSet {
      self.doneButton.enabled = selectedAccount != nil
    }
  }
  
  private lazy var accountListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSizeMake(self.bounds.width, 64)
    
    let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerClass(ListCell.self, forCellWithReuseIdentifier: "AccountPickerListCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = UIColor.clearColor()
    return collectionView
  }()
  
  private lazy var loadingView: UIActivityIndicatorView = {
    var activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.color = Colors().Black
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView = loadingView
  }

  convenience required init?(coder aDecoder: NSCoder) {
    self.init(frame: CGRectZero)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AccountPickerActionSheet: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UICollectionViewDelegate

extension AccountPickerActionSheet: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    let row = indexPath.row
    
    cell.selected = true
    
    selectedAccount = accounts[row]
    doneButton.enabled = true
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ListCell
    
    cell.selected = false
  }
}

// MARK: - UICollectionViewDataSource

extension AccountPickerActionSheet: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return accounts.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AccountPickerListCell", forIndexPath: indexPath) as! ListCell
    let row = indexPath.row
    
    cell.text = accounts[row].username
    cell.showCheckBox = true
    
    return cell
  }
}