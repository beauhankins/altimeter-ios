//
//  ListCell.swift
//  altimeter
//
//  Created by Beau Hankins on 11/06/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UICollectionViewCell {
  var text: String?
  var color: UIColor = Colors().White
  
  private lazy var textLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Default
    label.textAlignment = .Left
    label.textColor = self.color
    label.text = self.text
    return label
    }()
  
  override func layoutSubviews() {
    addSubview(textLabel)
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 20))
    addConstraint(NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
  }
}