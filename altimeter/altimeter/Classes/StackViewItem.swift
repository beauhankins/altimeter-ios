//
//  StackViewItem.swift
//  altimeter
//
//  Created by Beau Hankins on 11/06/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class StackViewItem: UIControl {
  var text: String?
  var selectedText: String?
  var textColor: UIColor = Colors().Black
  
  private lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Left
    label.textColor = self.textColor
    label.text = self.text
    return label
    }()
  
  override func layoutSubviews() {
    layer.sublayers?.removeAll()
    
    addSubview(textLabel)
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    let border: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(0, 64, self.frame.width, 1)
      layer.opacity = textColor == Colors().White ? 0.1: 1.0
      layer.backgroundColor = Colors().White.CGColor
      return layer
      }()
    
    layer.insertSublayer(border, atIndex: 0)
  }
  
  override var selected:Bool {
    didSet {
      if !selected {
        textLabel.text = self.text
      } else {
        textLabel.text = self.selectedText
      }
    }
  }
  
  override var highlighted:Bool {
    didSet {
      if !highlighted {
        textLabel.textColor = self.textColor
      } else {
        textLabel.textColor = Colors().Primary
      }
    }
  }
}