//
//  ListControl.swift
//  altimeter
//
//  Created by Beau Hankins on 11/06/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class ListControl: UIControl {
  var text: String?
  var icon: UIImage? {
    didSet {
      iconView.image = icon
    }
  }
  var textColor: UIColor = Colors().Black {
    didSet {
      textLabel.textColor = textColor
    }
  }
  
  var checkboxImage: UIImage = UIImage(named: "radio-default")! {
    didSet {
      checkboxView.image = checkboxImage
    }
  }
  
  var showCheckBox: Bool = false {
    didSet {
      checkboxView.hidden = !showCheckBox
    }
  }
  
  var textIndent: CGFloat = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Left
    label.textColor = self.textColor
    label.text = self.text
    return label
    }()
  
  private lazy var checkboxView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.checkboxImage
    imageView.contentMode = .ScaleAspectFit
    imageView.hidden = true
    return imageView
    }()
  
  private lazy var iconView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.icon
    imageView.contentMode = .ScaleAspectFit
    return imageView
    }()
  
  override func layoutSubviews() {
    layer.sublayers?.removeAll()
    
    addSubview(textLabel)
    addSubview(checkboxView)
    addSubview(iconView)
    
    if (icon != nil) { textIndent += 15 }
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 15))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -15))
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: iconView, attribute: .Right, multiplier: 1, constant: textIndent))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 15))
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -15))
    
    let borderBottom: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(0, 64, self.frame.width, 1)
      layer.opacity = 0.1
      layer.backgroundColor = textColor == Colors().White ? Colors().White.CGColor : Colors().Black.CGColor
      return layer
      }()
    
    let borderRight: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(self.frame.width, 0, 1, 64)
      layer.opacity = 0.1
      layer.backgroundColor = textColor == Colors().White ? Colors().White.CGColor : Colors().Black.CGColor
      return layer
      }()
    
    layer.insertSublayer(borderBottom, atIndex: 0)
    layer.insertSublayer(borderRight, atIndex: 0)
  }
  
  override var selected:Bool {
    didSet {
      if !selected {
        checkboxView.image = checkboxImage
      } else {
        checkboxView.image = UIImage(named: "radio-checked")!
      }
    }
  }
}