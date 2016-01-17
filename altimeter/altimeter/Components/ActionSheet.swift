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
  
  lazy var doneButton: ListControl = {
    var listControl = ListControl()
    listControl.translatesAutoresizingMaskIntoConstraints = false
    listControl.stateText = "Done"
    return listControl
  }()
  
  override func layoutSubviews() {
    addSubview(titleLabel)
    addSubview(contentView)
    addSubview(doneButton)
    
    backgroundColor = Colors().White
    
    let padding: CGFloat = 20
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 140))
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: padding))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -padding))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: padding))
    
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: padding))
    
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: padding))
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