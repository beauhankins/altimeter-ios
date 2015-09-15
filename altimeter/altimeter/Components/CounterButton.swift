//
//  CounterButton.swift
//  altimeter
//
//  Created by Beau Hankins on 18/07/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class CounterButton: UIControl {
  var text: String?
  var counterValue: Int = 0
  
  private lazy var titleLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Left
    label.text = self.text
    label.textColor = Colors().White
    return label
    }()

  private lazy var counterLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Unit
    label.textAlignment = .Right
    label.text = "\(self.counterValue)"
    label.textColor = Colors().Black
    return label
    }()
  
  private lazy var counterView: UIView = {
    var view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = Colors().White
    view.layer.cornerRadius = 3.0
    
    view.addSubview(self.counterLabel)
    
    view.addConstraint(NSLayoutConstraint(item: self.counterLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -8))
    view.addConstraint(NSLayoutConstraint(item: self.counterLabel, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: self.counterLabel, attribute: .Height, multiplier: 1, constant: 6))
    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: self.counterLabel, attribute: .Width, multiplier: 1, constant: 15))
    
    return view
    }()
  
  override func layoutSubviews() {
    
    addSubview(titleLabel)
    addSubview(counterView)
    
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: counterView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -20))
    addConstraint(NSLayoutConstraint(item: counterView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    
    let backgroundLayer: CAGradientLayer = {
      let layer = Gradients().SecondaryToPrimary
      layer.frame = bounds
      layer.backgroundColor = Colors().Secondary.CGColor
      layer.startPoint = CGPoint(x: 0,y: 0.5)
      layer.endPoint = CGPoint(x: 1,y: 0.5)
      return layer
      }()

    layer.insertSublayer(backgroundLayer, atIndex: 0)
  }
}