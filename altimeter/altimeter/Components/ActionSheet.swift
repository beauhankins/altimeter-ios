//
//  ActionSheet.swift
//  altimeter
//
//  Created by Beau Hankins on 17/01/2016.
//  Copyright © 2016 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class ActionSheet: UIView {
  var title: String = "" {
    didSet {
      titleLabel.attributedText = attributedString(title)
    }
  }
  
  var contentHeight: CGFloat = 64.0
  var heightConstraint = NSLayoutConstraint()
  var contentHeightConstraint = NSLayoutConstraint()
  
  var contentView: UIView = {
    var view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }() {
    
    didSet {
      self.setNeedsUpdateConstraints()
      self.layoutIfNeeded()
    }
  }
  
  lazy private var titleLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().SmallHeading
    label.textAlignment = .Left
    label.textColor = Colors().Black
    label.attributedText = self.attributedString(self.title)
    return label
  }()
  
  lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Cancel", forState: .Normal)
    button.setTitleColor(Colors().Black, forState: .Normal)
    button.setTitleColor(Colors().Black.colorWithAlphaComponent(0.5), forState: .Highlighted)
    button.titleLabel?.font = Fonts().Default
    button.titleLabel?.textAlignment = .Right
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
    return button
  }()
  
  lazy var doneButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Done", forState: .Normal)
    button.setTitleColor(Colors().PictonBlue, forState: .Normal)
    button.setTitleColor(Colors().PictonBlue.colorWithAlphaComponent(0.5), forState: .Highlighted)
    button.setTitleColor(Colors().Black.colorWithAlphaComponent(0.3), forState: .Disabled)
    button.titleLabel?.font = Fonts().Default
    button.titleLabel?.textAlignment = .Right
    button.enabled = false
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
    return button
  }()
  
  override func layoutSubviews() {
    addSubview(titleLabel)
    addSubview(contentView)
    addSubview(doneButton)
    addSubview(cancelButton)
    
    backgroundColor = Colors().White
    
    let padding: CGFloat = 20
    
    removeConstraint(heightConstraint)
    removeConstraint(contentHeightConstraint)
    
    heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: contentHeight + 120)
    contentHeightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: contentHeight)
    
    addConstraint(heightConstraint)
    addConstraint(contentHeightConstraint)
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: padding))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -padding))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: padding))
    
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: padding))
    
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
  }
  
  func attributedString(string: String, letterSpacing: Float = 1.0) -> NSAttributedString
  {
    return NSAttributedString(
      string: string,
      attributes:
      [
        NSKernAttributeName: letterSpacing
      ])
  }
}