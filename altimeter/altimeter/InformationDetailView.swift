//
//  InformationDetailView.swift
//  altimeter
//
//  Created by Beau Hankins on 17/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

enum InformationDetailViewStyle {
  case Default
  case Gradient
}

class InformationDetailView: UIView {
  var title: String?
  var textColor: UIColor?
  var icon: UIImage?
  var style: InformationDetailViewStyle = .Default
  
  lazy var titleLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Heading
    label.textAlignment = .Left
    label.textColor = self.textColor
    label.text = self.title
    return label
    }()
  
  private lazy var iconView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.icon
    imageView.contentMode = .ScaleAspectFit
    return imageView
    }()
  
  override func layoutSubviews() {
    addSubview(iconView)
    addSubview(titleLabel)
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: iconView, attribute: .Right, multiplier: 1, constant: icon != nil ? 10 : 0))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: iconView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
    
    if (style == .Gradient) {
      titleLabel.textColor = textColor == nil ? Colors().White : textColor
      
      let backgroundLayer: CAGradientLayer = {
        let layer = Gradients().SecondaryToPrimary
        layer.frame = bounds
        layer.backgroundColor = Colors().Secondary.CGColor
        layer.startPoint = CGPoint(x: 0,y: 0.5)
        layer.endPoint = CGPoint(x: 1,y: 0.5)
        return layer
        }()
      
      layer.insertSublayer(backgroundLayer, atIndex: 0)
    } else {
      titleLabel.textColor = textColor == nil ? Colors().Black : textColor
    }
  }
}