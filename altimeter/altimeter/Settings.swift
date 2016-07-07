//
//  Settings.swift
//  altimeter
//
//  Created by Beau Hankins on 23/05/2015.
//  Copyright (c) 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
  let White = UIColor(white: 1, alpha: 1)
  let LavendarGrey = UIColor(red: (194/255.0), green: (195/255.0), blue: (207/255.0), alpha: 1)
  let Shark = UIColor(red: (40/255.0), green: (40/255.0), blue: (45/255.0), alpha: 1)
  let Black = UIColor(white: 0, alpha: 1)
  let PictonBlue = UIColor(red: (56/255.0), green: (170/255.0), blue: (255/255.0), alpha: 1)
  let NeonBlue = UIColor(red: (72/255.0), green: (84/255.0), blue: (255/255.0), alpha: 1)
  let Red = UIColor(red: (255/255.0), green: (57/255.0), blue: (57/255.0), alpha: 1)
}

struct Gradients {
  let SecondaryToPrimary: CAGradientLayer = {
    var gradient = CAGradientLayer()
    gradient.colors = [Colors().NeonBlue.CGColor, Colors().PictonBlue.CGColor]
    gradient.locations = [0.0, 1.0]
    return gradient
  }()
}

struct Fonts {
  let LargeHeading = UIFont(name: "Lato-Light", size: 64.0)
  
  let Default = UIFont(name: "Lato-Regular", size: 18.0)
  let Heading = UIFont(name: "Lato-Regular", size: 18.0)
  let FormattedCoordinate = UIFont(name: "Lato-Regular", size: 16.0)
  let SmallHeading = UIFont(name: "Lato-Regular", size: 14.0)
  let Data = UIFont(name: "Lato-Regular", size: 14.0)
  let Caption = UIFont(name: "Lato-Regular", size: 11.0)
  
  let Coordinate = UIFont(name: "Lato-Bold", size: 16.0)
  let Unit = UIFont(name: "Lato-Bold", size: 14.0)
  let Status = UIFont(name: "Lato-Bold", size: 13.0)
}