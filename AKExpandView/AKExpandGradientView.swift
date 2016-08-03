import UIKit

class AKExpandGradientView: UIView {
	
	var startColor, endColor: UIColor!


  override func drawRect(rect: CGRect) {
		if startColor != nil && endColor != nil {
			

      
			let currentContext = UIGraphicsGetCurrentContext()
			CGContextSaveGState(currentContext)
			
			let startColorComponents = CGColorGetComponents(startColor.CGColor)		
			let endColorComponents = CGColorGetComponents(endColor.CGColor)
			
			var colorComponents = [
				startColorComponents[0],
				startColorComponents[1],
				startColorComponents[2],
				startColorComponents[3],
				endColorComponents[0],
				endColorComponents[1],
				endColorComponents[2],
				endColorComponents[3]
			]
			
			var locations:[CGFloat] = [0.0, 1.0]
			
			let gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), &colorComponents, &locations, 2)
			
			CGContextDrawLinearGradient(currentContext, gradient, CGPointMake(0, 0), CGPointMake(0, bounds.height), CGGradientDrawingOptions(rawValue: 0))
		}		
  }
}

