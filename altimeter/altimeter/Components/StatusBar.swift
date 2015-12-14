//
//  StatusBar.swift
//  altimeter
//
//  Created by Beau Hankins on 4/11/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NavigationBar

class StatusBar: UIView {
  
  var text: String? {
    didSet {
      if let text = text { textLabel.attributedText = attributedString(text) }
    }
  }
  
  lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Status
    label.textAlignment = .Center
    label.textColor = Colors().White
    return label
    }()
  
  override func layoutSubviews() {
    removeConstraints(constraints)
    
    backgroundColor = Colors().Secondary
    
    addSubview(textLabel)
    
    if (!hidden) {
      addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 36))
    } else {
      addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 0))
      return
    }
    
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
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