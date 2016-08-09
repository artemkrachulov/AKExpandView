//
//  AKExpandView.swift
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit

final class AKExpandGradientView: UIView  {
  
  //  MARK: - Properties
  
  /// Start & end color grabbed from gradienColor property
	internal var startColor, endColor: UIColor!

  //  MARK: - Life cycle
  
  override func drawRect(rect: CGRect) {
    
    guard let startColor = startColor, endColor = endColor else {
      return
    }
    print(startColor, endColor)

    let currentContext = UIGraphicsGetCurrentContext()
    CGContextSaveGState(currentContext)
    
    let startColorComponents = CGColorGetComponents(startColor.CGColor)		
    let endColorComponents = CGColorGetComponents(endColor.CGColor)
    
    var colorComponents = [
      startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3],
      endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    ]
    
    var locations:[CGFloat] = [0.0, 1.0]
    
    let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), &colorComponents, &locations, 2)
    
    CGContextDrawLinearGradient(currentContext, gradient, CGPointMake(0, 0), CGPointMake(0, bounds.height), CGGradientDrawingOptions(rawValue: 0))
  }
}

