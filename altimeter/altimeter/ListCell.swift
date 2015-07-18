//
//  ListCell.swift
//  altimeter
//
//  Created by Beau Hankins on 18/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UICollectionViewCell {
  
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
  
  private lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Left
    if let textColor = self.textColor { label.textColor = textColor }
    label.text = self.text
    return label
    }()
  
  override func layoutSubviews() {
    layer.sublayers?.removeAll()
    
    addSubview(textLabel)
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    let borderBottom: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(0, 64, self.frame.width, 1)
      layer.opacity = textColor == Colors().White ? 0.1 : 1.0
      if let textColor = self.textColor { layer.backgroundColor = textColor.CGColor }
      return layer
      }()
    
    let borderRight: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(self.frame.width - 20, 0, 1, 0)
      layer.opacity = textColor == Colors().White ? 0.1 : 1.0
      if let textColor = self.textColor { layer.backgroundColor = textColor.CGColor }
      return layer
      }()
    
    layer.insertSublayer(borderBottom, atIndex: 0)
    layer.insertSublayer(borderRight, atIndex: 0)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}