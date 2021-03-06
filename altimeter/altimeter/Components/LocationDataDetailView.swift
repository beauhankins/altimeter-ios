//
//  LocationDataDetailView.swift
//  altimeter
//
//  Created by Beau Hankins on 22/09/2015.
//  Copyright © 2015 Beau Hankins. All rights reserved.
//

import Foundation
import UIKit

class LocationDataDetailView: UIView {
  var checkIn: CheckIn {
    didSet {
      let location = checkIn.location
      let coordinate = location.coordinate
      
      let latitude = fabs(coordinate.latitude.doubleValue)
      let formattedLatitude = formattedCoordinateAngleString(coordinate.latitude.doubleValue)
      let longitude = fabs(coordinate.longitude.doubleValue)
      let formattedLongitude = formattedCoordinateAngleString(coordinate.longitude.doubleValue)
      let pressure = location.pressure.doubleValue
      let temperature = UserSettings.sharedSettings.unit.convertDegrees(location.temperature.doubleValue)
      
      let coordinateString = String(format: "%.4f %@   %.4f %@", latitude, latitude > 0 ? "S" : "N", longitude, longitude > 0 ? "E" : "W")
      let formattedCoordinateString = "\(formattedLatitude)   \(formattedLongitude)"
      let pressureString = String(format: "%.04f PSI", pressure)
      let temperatureString = String(format: "%.0f°%@", temperature, UserSettings.sharedSettings.unit.degreesAbbreviation())
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateStyle = .ShortStyle
      dateFormatter.timeStyle = .NoStyle
      dateFormatter.locale = NSLocale.currentLocale()
      let dateString = dateFormatter.stringFromDate(checkIn.dateCreated)
      
      let timeFormatter = NSDateFormatter()
      timeFormatter.dateStyle = .NoStyle
      timeFormatter.timeStyle = .ShortStyle
      timeFormatter.locale = NSLocale.currentLocale()
      let timeString = timeFormatter.stringFromDate(checkIn.dateCreated)
      
      dateLabel.attributedText = attributedString(dateString)
      timeLabel.attributedText = attributedString(timeString.substringToIndex(timeString.endIndex.predecessor()))
      
      coordinateLabel.attributedText = attributedString(coordinateString)
      formattedCoordinateLabel.attributedText = attributedString(formattedCoordinateString)
      pressureLabel.attributedText = attributedString(pressureString)
      temperatureLabel.attributedText = attributedString(temperatureString)
    }
  }
  
  lazy var coordinateLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.textAlignment = .Left
    return label
    }()
  
  lazy var formattedCoordinateLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.textAlignment = .Left
    return label
    }()
  
  lazy var pressureLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.textAlignment = .Left
    return label
    }()
  
  lazy var temperatureLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.textAlignment = .Right
    return label
    }()
  
  lazy var dateLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.alpha = 0.3
    label.textAlignment = .Left
    return label
    }()
  
  lazy var timeLabel: UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Fonts().Data
    label.alpha = 0.3
    label.textAlignment = .Right
    return label
    }()
  
  lazy var container: UIView = {
    var view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.coordinateLabel)
    view.addSubview(self.formattedCoordinateLabel)
    view.addSubview(self.pressureLabel)
    view.addSubview(self.temperatureLabel)
    view.addSubview(self.dateLabel)
    view.addSubview(self.timeLabel)
    
    view.addConstraint(NSLayoutConstraint(item: self.coordinateLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.coordinateLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.coordinateLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.formattedCoordinateLabel, attribute: .Top, relatedBy: .Equal, toItem: self.coordinateLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.formattedCoordinateLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.formattedCoordinateLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.pressureLabel, attribute: .Top, relatedBy: .Equal, toItem: self.formattedCoordinateLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.pressureLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.temperatureLabel, attribute: .Top, relatedBy: .Equal, toItem: self.formattedCoordinateLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.temperatureLabel, attribute: .Left, relatedBy: .Equal, toItem: self.pressureLabel, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.temperatureLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.dateLabel, attribute: .Top, relatedBy: .Equal, toItem: self.pressureLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.dateLabel, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Top, relatedBy: .Equal, toItem: self.temperatureLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    view.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Left, relatedBy: .Equal, toItem: self.pressureLabel, attribute: .Right, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.dateLabel, attribute: .Bottom, multiplier: 1, constant: 12))
    
    return view
    }()
  
  init(checkIn: CheckIn) {
    self.checkIn = checkIn
    
    super.init(frame: CGRectZero)
  }
  
  convenience required init?(coder aDecoder: NSCoder) {
    let checkIn = CheckIn.create() as! CheckIn
    
    self.init(checkIn: checkIn)
  }
  
  override func layoutSubviews() {
    layer.sublayers?.removeAll()
    
    addSubview(container)
    
    addConstraint(NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 12))
    addConstraint(NSLayoutConstraint(item: container, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 40))
    addConstraint(NSLayoutConstraint(item: container, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -22))
    
    addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 12))
    
    let borderBottom: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(20, self.frame.height, self.frame.width, 1)
      layer.opacity = 0.1
      layer.backgroundColor = Colors().Black.CGColor
      return layer
      }()
    
    let borderRight: CALayer = {
      let layer = CALayer()
      layer.frame = CGRectMake(self.frame.width, 0, 1, self.frame.height)
      layer.opacity = 0.1
      layer.backgroundColor = Colors().Black.CGColor
      return layer
      }()
    
    layer.insertSublayer(borderBottom, atIndex: 0)
    layer.insertSublayer(borderRight, atIndex: 0)
  }
  
  func formattedCoordinateAngleString(angle: Double) -> String {
    var seconds = Int(angle * 3600)
    let degrees = seconds / 3600
    seconds = abs(seconds % 3600)
    let minutes = seconds / 60
    seconds %= 60
    return String(format:"%d°%d'%d\"",
      abs(degrees),
      minutes,
      seconds)
  }
  
  func attributedString(string: String, letterSpacing: Float = 1.0) -> NSAttributedString
  {
    return NSAttributedString(
      string: string,
      attributes:
      [
        NSKernAttributeName: letterSpacing
      ])
  }
}
