//
//  PhotoGridCell.swift
//  altimeter
//
//  Created by Beau Hankins on 15/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class PhotoGridCell: UICollectionViewCell {
  
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  var imageMode: UIViewContentMode = .ScaleAspectFit {
    didSet {
      imageView.contentMode = imageMode
    }
  }

  override var selected: Bool {
    didSet {
      self.layer.borderWidth = selected ? 6 : 0
      self.layer.borderColor = Colors().Secondary.CGColor
    }
  }
  
  private lazy var imageView: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.image
    imageView.contentMode = self.imageMode
    return imageView
    }()

  private lazy var selectedOverlay: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = self.image
    imageView.contentMode = .ScaleAspectFit
    return imageView
    }()
  
  override func layoutSubviews() {

    selected = false

    addSubview(imageView)

    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    addConstraint(NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
  }
}
