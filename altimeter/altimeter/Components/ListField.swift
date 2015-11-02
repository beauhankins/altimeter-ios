//
//  ListField.swift
//  altimeter
//
//  Created by Beau Hankins on 26/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class ListField: UITextField {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 64))
    
    backgroundColor = Colors().Black
    textColor = Colors().White
  }
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 20, 0)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 20, 0)
  }
}