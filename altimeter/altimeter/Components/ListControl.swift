//
//  ListControl.swift
//  altimeter
//
//  Created by Beau Hankins on 11/06/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//  fsociety.dat

import Foundation
import UIKit

class ListControl: UIControl {
  
  var text: String? {
    didSet {
      textLabel.text = text
    }
  }
  
  var textColor: UIColor? {
    didSet {
      textLabel.textColor = textColor
    }
  }
  
  var stateTextColor: UIColor? {
    didSet {
      stateLabel.textColor = stateTextColor
    }
  }
  
  var subtext: String? {
    didSet {
      subtextLabel.text = subtext
      subtextLabel.hidden = false
    }
  }
  
  var stateText: String? {
    didSet {
      stateLabel.text = stateText
      stateLabel.hidden = false
    }
  }
  
  var icon: UIImage? {
    didSet {
      if let icon = icon {
        iconView.image = icon
      } else {
        iconView.image = nil
      }
    }
  }
  
  var image: UIImage? {
    didSet {
      if let image = image {
        imageView.image = image
      } else {
        imageView.image = nil
      }
    }
  }
  
  var checkboxImage: UIImage = UIImage(named: "radio-default")! {
    didSet {
      checkboxView.image = checkboxImage
    }
  }
  
  var topBorder: Bool = false
  
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
    if let textColor = self.textColor { label.textColor = textColor }
    label.text = self.text
    label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    return label
  }()
  
  private lazy var subtextLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Caption
    label.textAlignment = .Left
    if let textColor = self.textColor { label.textColor = textColor }
    label.alpha = 0.2
    label.text = self.subtext
    label.hidden = true
    return label
  }()
  
  private lazy var stateLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Right
    label.textColor = Colors().PictonBlue
    label.text = self.stateText
    label.hidden = true
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
  
  private lazy var imageView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.image
    imageView.contentMode = .ScaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  private lazy var iconView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.icon
    imageView.contentMode = .ScaleAspectFit
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func layoutSubviews() {
    removeConstraints(constraints)
    
    addSubview(imageView)
    addSubview(iconView)
    addSubview(textLabel)
    addSubview(subtextLabel)
    addSubview(stateLabel)
    addSubview(checkboxView)
    
    let HEIGHT: CGFloat = 64
    
    if (!hidden) {
      addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: HEIGHT))
    } else {
      addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 0))
      return
    }
    
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: image == nil ? 0 : HEIGHT))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: HEIGHT))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1, constant: image == nil ? 0 : 10))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: icon == nil ? 0 : 1, constant: icon == nil ? 0 : -32))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 16))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -16))
    
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: checkboxView.hidden ? 0 : 1, constant: checkboxView.hidden ? 0 : -32))
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 16))
    addConstraint(NSLayoutConstraint(item: checkboxView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -16))
    
    addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: stateLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: iconView, attribute: .Right, multiplier: 1, constant: icon == nil && image == nil ? textIndent : textIndent+20))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Right, relatedBy: .Equal, toItem: checkboxView, attribute: .Left, multiplier: 1, constant: -16))
    if subtextLabel.hidden == false {
      addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    } else {
      addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
    addConstraint(NSLayoutConstraint(item: subtextLabel, attribute: .Left, relatedBy: .Equal, toItem: iconView, attribute: .Right, multiplier: 1, constant: icon == nil && image == nil ? textIndent : textIndent+20))
    addConstraint(NSLayoutConstraint(item: subtextLabel, attribute: .Right, relatedBy: .Equal, toItem: checkboxView, attribute: .Left, multiplier: 1, constant: -16))
    addConstraint(NSLayoutConstraint(item: subtextLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 6))
    
    let borderBottom: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(20, HEIGHT, self.frame.width, 1)
      layer.opacity = 0.1
      layer.name = "border"
      if let textColor = self.textColor { layer.backgroundColor = textColor == Colors().White ? textColor.CGColor : Colors().Black.CGColor }
      return layer
    }()
    
    let borderRight: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(self.frame.width, 0, 1, HEIGHT)
      layer.opacity = 0.1
      layer.name = "border"
      if let textColor = self.textColor { layer.backgroundColor = textColor == Colors().White ? textColor.CGColor : Colors().Black.CGColor }
      return layer
    }()
    
    let borderTop: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(20, 0, self.frame.width, 1)
      layer.opacity = 0.1
      layer.name = "border"
      if let textColor = self.textColor { layer.backgroundColor = textColor == Colors().White ? textColor.CGColor : Colors().Black.CGColor }
      return layer
    }()
  
    if let sublayers = layer.sublayers {
      for layer in sublayers {
        if layer.name == "border" {
          layer.removeFromSuperlayer()
        }
      }
    }
    
    layer.insertSublayer(borderRight, atIndex: 0)
    if topBorder { layer.insertSublayer(borderTop, atIndex: 0) }
    else { layer.insertSublayer(borderBottom, atIndex: 0) }
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
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
