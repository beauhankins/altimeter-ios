//
//  NavigationBar.swift
//  altimeter
//
//  Created by Beau Hankins on 23/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NavigationBar

class NavigationBar: UIView {
  
  lazy var leftBarItem: NavigationBarItem = {
    var control = NavigationBarItem()
    control.setTranslatesAutoresizingMaskIntoConstraints(false)
    return control
  }()
  
  lazy var rightBarItem: NavigationBarItem = {
    var control = NavigationBarItem()
    control.setTranslatesAutoresizingMaskIntoConstraints(false)
    return control
    }()
  
  lazy var titleLabel: UILabel = {
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    label.font = Fonts().Heading
    label.textAlignment = NSTextAlignment.Center
    label.text = "Settings"
    label.textColor = Colors().White
    return label
    }()
  
  override func layoutSubviews() {
    addSubview(titleLabel)
    addSubview(leftBarItem)
    addSubview(rightBarItem)
    
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
  }
}

// MARK: - NavigationBarItem

enum NavigationBarItemAlignment : Int {
  case Left
  case Right
}

class NavigationBarItem: UIControl {
  
  var icon: UIImage!
  var text: String!
  var alignment: String!
  
  private lazy var iconView: UIImageView = {
    var imageView = UIImageView()
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.image = self.icon
    return imageView
    }()
  
  private lazy var textLabel: UILabel = {
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    label.textAlignment = alignment ==  NSTextAlignment.Left
    label.textColor = Colors().White
    label.text = self.text
    return label
    }()
  
  override func layoutSubviews() {
    addSubview(iconView)
    addSubview(textLabel)
    
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
  }
}