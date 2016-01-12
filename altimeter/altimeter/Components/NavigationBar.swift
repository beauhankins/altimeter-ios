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
    var navBarItem = NavigationBarItem()
    navBarItem.translatesAutoresizingMaskIntoConstraints = false
    navBarItem.alignment = .Left
    return navBarItem
  }()
  
  lazy var rightBarItem: NavigationBarItem = {
    var navBarItem = NavigationBarItem()
    navBarItem.translatesAutoresizingMaskIntoConstraints = false
    navBarItem.alignment = .Right
    return navBarItem
    }()
  
  lazy var titleLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Heading
    label.textAlignment = .Center
    label.textColor = Colors().White
    return label
    }()
  
  override func layoutSubviews() {
    
    addSubview(titleLabel)
    addSubview(leftBarItem)
    addSubview(rightBarItem)
    
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
    addConstraint(NSLayoutConstraint(item: leftBarItem, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 34))
    
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
    addConstraint(NSLayoutConstraint(item: rightBarItem, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 34))
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 10))
  }
}

// MARK: - NavigationBarItem

enum NavigationBarItemAlignment: Int {
  case Left
  case Right
}

enum NavigationBarItemType: Int {
  case Default
  case Emphasis
}

class NavigationBarItem: UIControl {
  
  var icon: UIImage?
  var text: String? {
    didSet {
      textLabel.text = text
    }
  }
  var alignment: NavigationBarItemAlignment = .Left
  var type: NavigationBarItemType = .Default
  var color: UIColor = Colors().White {
    didSet {
      textLabel.textColor = color
    }
  }
  
  private lazy var iconView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.icon
    imageView.contentMode = .ScaleAspectFit
    return imageView
    }()
  
  private lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = self.type == .Emphasis ? Fonts().Heading : Fonts().Default
    label.textAlignment = self.alignment == .Left ? .Left : .Right
    label.textColor = self.color
    label.text = self.text
    return label
    }()
  
  override func layoutSubviews() {
    addSubview(iconView)
    addSubview(textLabel)
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: textLabel, attribute: .Width, multiplier: 1, constant: icon != nil ? 25 : 0))
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: iconView, attribute: .Right, multiplier: 1, constant: icon != nil ? 5 : 0))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
  }
  
  override var enabled: Bool {
    didSet {
      if enabled {
        textLabel.textColor = self.color
        alpha = 1.0
      } else {
        textLabel.textColor = Colors().Black
        alpha = 0.3
      }
    }
  }
  
  override var highlighted: Bool {
    didSet {
      if highlighted {
        alpha = 0.5
      } else {
        alpha = 1.0
      }
    }
  }
}