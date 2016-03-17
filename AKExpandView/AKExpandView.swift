//
//  AKExpandView.swift
//  Demo
//
//  Created by Krachulov Artem  on 2/25/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

struct AKExpandViewAnimationOptions {
	var duration: NSTimeInterval!
	var option: UIViewAnimationOptions!
}


class AKExpandView: UIView {

	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	// 1
	
	
	var heightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var expandWrapperViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var expandWrapperView: UIView!  {
		didSet {
			expandWrapperView.clipsToBounds = true
		}
	}
	
		@IBOutlet weak var expandContainerView: UIView! {
			didSet {
				expandContainerView.clipsToBounds = true
			}
		}
	
			var expandViewHeightContraint: NSLayoutConstraint!
			var expandView: UIView!
	
		@IBOutlet weak var gradientView: AKExpandGradientView! {
			didSet {
				
				gradientView.hidden = true
				gradientView.backgroundColor = UIColor.clearColor()
				
				let components = CGColorGetComponents(gradientViewColor.CGColor)
				
				gradientView.startColor = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 0)
				gradientView.endColor = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1)
				
				gradientView.setNeedsDisplay()
			}
		}
	
	@IBOutlet weak var actionContainerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var actionContainerView: UIView!
	
	// 2
	
	@IBOutlet weak var actionView: UIView!
	
	@IBOutlet weak var btn: UIButton!  {
		didSet {
			btn.setTitle(btnClosedTitle, forState: UIControlState.Normal)
		}
	}
	
	// Settings
	
	var minCollapsedHeight: CGFloat!
	
	var animation = false
	var animationOptions: AKExpandViewAnimationOptions?

	var showGradientView = true
	var gradientViewColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
	
	
	
	
	
	// Flags
	var flag_expanded = false
	
	
	
	var btnClosedTitle = "read more..."
	var btnOpenTitle = "read less..."
	

	
	
	// MARK: - Initialization
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	
	

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!

		clipsToBounds = true
		
		minCollapsedHeight = CGRectGetHeight(self.frame)
		
		// ???
		
		heightConstraint = heightContraint(self)
		
		// Get inner view from storyboard
		// initialization
		
		let vc = self.subviews.first
		
		// Clear all inner view
		// to aviod conflicts
		
		removeSubviews(self)
		
		loadFromNib(nil, bundle: nil)
		
		// Process views
		// 1. Expand view from storyboard
		
		if vc != nil {
			viewToExpand(vc!)
		}
		
		// 2. View with button from AKExpandView.xib
		
		actionView(actionView)
	}
	
	
	func actionView(view: UIView) {
		
		view.frame.origin = CGPointZero
		view.translatesAutoresizingMaskIntoConstraints = false
		
		actionContainerView.addSubview(view)
		
		let viewsDictionary = ["view": view]
		
		actionContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		actionContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
	}
	
	
	
	
	
	
	func removeSubviews(view: UIView) {
		for subview in view.subviews {
			subview.removeFromSuperview()
		}
	}
	
	

	

	
	
	func heightContraint(view: UIView) -> NSLayoutConstraint! {
		
		for constraint in view.constraints {
			if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.secondItem == nil {
				return constraint
			}
		}
		return nil
	}
	
	
	
	func viewToExpand(view: UIView) {
		
		removeSubviews(expandContainerView)
		
		view.frame = CGRectZero
		view.autoresizingMask = UIViewAutoresizing.None
		view.translatesAutoresizingMaskIntoConstraints = false
		expandViewHeightContraint = nil
		
		expandContainerView.addSubview(view)
		expandWrapperView.bringSubviewToFront(gradientView)

		let viewsDictionary = ["view": view]
		
		expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		
		if let heightContraint = heightContraint(expandContainerView) {
			expandContainerView.removeConstraint(heightContraint)
		}		
		
		// Get height constraint
		expandContainerView.layoutSubviews()
		
		if heightContraint(view) == nil {
			expandViewHeightContraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: CGRectGetHeight(view.frame))
			
			view.addConstraint(expandViewHeightContraint)
		}
		
		// Save reference
	
		print("AA")
		expandView = view
	}
	
	
	func heightContraint2(view: UIView) -> NSLayoutConstraint! {
		
		for constraint in view.constraints {
			if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.secondItem == nil {
				return constraint
			}
		}
		return nil
	}
	
	
	
	
	override func layoutSubviews() {
		
		layoutSubviews(true)
	}

	func layoutSubviews(action: Bool) {
		
		if expandView != nil {
			
			expandView.sizeToFit()
			expandContainerView.frame.size.height = expandView.frame.size.height
		}
		
		let height: CGFloat = CGRectGetHeight(expandContainerView.frame)
		
		if expandViewHeightContraint != nil {
			expandViewHeightContraint.constant = height
		}


		if flag_expanded {
			
			if height <= minCollapsedHeight {
				
				expandWrapperViewHeightConstraint.constant = height
				
				if heightConstraint != nil { heightConstraint.constant = height } else {
					
					if action {
						frame.size.height = height
					}
				}
			} else {
				
				expandWrapperViewHeightConstraint.constant = height
				
				gradientView.hidden = true
				
				if heightConstraint != nil { heightConstraint.constant = height + CGRectGetHeight(actionView.frame) } else {
					
					if action {
						frame.size.height = height + CGRectGetHeight(actionView.frame)
					}
				}
			}
			
		} else {
			
			expandWrapperViewHeightConstraint.constant = height > minCollapsedHeight ? minCollapsedHeight : height
			
			gradientView.hidden = height <= minCollapsedHeight
		
			if heightConstraint != nil { heightConstraint.constant = height > minCollapsedHeight ? minCollapsedHeight + CGRectGetHeight(actionView.frame) : height } else {
				
				if action {
					frame.size.height = height > minCollapsedHeight ? minCollapsedHeight + CGRectGetHeight(actionView.frame) : height
				}
			}
		
			actionContainerHeightConstraint.constant = CGRectGetHeight(actionView.frame)
		}
		
		if expandView.respondsToSelector(Selector("contentOffset")) {
			(expandView as! UIScrollView).contentOffset = CGPointZero
		}

		#if AKExpandViewDEBUG
			print("Object ::::::: AKExpandView")
			print("Method ::::::: layoutSubviews")
			print("               - -")
			print("Properties ::: height = \(height)")
			print("                  ")
			print("               AKExpandView = \(self.frame)")
			print("               ↳ expandWrapperView = \(expandWrapperView.frame)")
			print("                 ↳ expandContainerView = \(expandContainerView.frame)")
			print("                   - expandView = \(expandView)")
			print("               ↳ actionContainerView = \(actionContainerView.frame)")
			print("                 ↳ actionView = \(actionView)")
			print("")
		#endif
	}
	
	
	
	// MARK: - Actions
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBAction func btnAction(sender: AnyObject) {
		
		if flag_expanded {
			
			flag_expanded = false
			btn.setTitle(btnClosedTitle, forState: UIControlState.Normal)
			
		} else {
			
			flag_expanded = true
			btn.setTitle(btnOpenTitle, forState: UIControlState.Normal)
		}
		

//		print("AA")
		
//		self.layoutSubviews(false)
		

		
		/*
		
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			
			self.superview!.layoutIfNeeded()
			
			self.layoutSubviews(true)
			
			
			}) { (boolean) -> Void in
				
				#if AKDEBUG
					print("Object ::::::: AKExpandView 2")
					print("Method ::::::: layoutSubviews")
					print("               - -")
					print("Properties ::: self > > > \(self)")
					print(":::::::::::::: topInnerView > > > \(self.topView)")
					print(":::::::::::::: topInnerView > > > \(self.topInnerView)")
					print(":::::::::::::: v > > > \(self.v)")
					print(":::::::::::::: v > > > \(self.v.constraints.first?.constant)")
					
					print(":::::::::::::: v > > > \((self.v as! UIActivityWebView).webView)")
					print(":::::::::::::: v > > > \((self.v as! UIActivityWebView).webView.scrollView)")
					print(":::::::::::::: v > > > \((self.v as! UIActivityWebView).webView.scrollView.contentSize)")
					print("")
				#endif
				
				print(self.superview!)
				print(self.superview!.superview)
				
		}
*/
		
		

//		UIView.animateWithDuration(0.5) { () -> Void in
		
			
		
//		self.superview!.superview!.layoutIfNeeded()
		
			self.layoutSubviews(true)
		
//		}
		
		
		
		
	}
	
	
	func expand() {}
	
	func collapse() {}
	
	


}
