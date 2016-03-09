//
//  AKExpandView.swift
//  Demo
//
//  Created by Krachulov Artem  on 2/25/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class AKExpandView: UIView {
	
	var anumation: Bool = false
	
	var maxHeight: CGFloat!
	
	var color: UIColor! = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
	
	
	@IBOutlet weak var gradientView: AKExpandGradientView! {
		didSet {
			
			gradientView.hidden = true
			
			gradientView.backgroundColor = UIColor.clearColor()
			
			let components = CGColorGetComponents(color.CGColor)
			
			gradientView.startColor = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 0)
			gradientView.endColor = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1)

			gradientView.setNeedsDisplay()
		}
	}
	
	
	@IBOutlet weak var topView: UIView!  {
		didSet {
			topView.clipsToBounds = true
		}
	}
	
	@IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var topInnerView: UIView! {
		didSet {
			topInnerView.clipsToBounds = true
		}
	}
	
	
	@IBOutlet weak var btn: UIButton!

	@IBOutlet weak var bottomVIew: UIView!
	
	@IBOutlet weak var buttonView: UIView!
	
	@IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
	
	
	var  c: NSLayoutConstraint!
	
	
	
	

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
			print("  ")
			print("  --------   ")
			print("  ")
		
		
		let vc = self.subviews.first
		print(subviews)
		print("VC \(vc)")
		
//		v = self.subviews.first
		
		
		for s in self.subviews {
			s.removeFromSuperview()
		}
		
		loadFromNib(nil, bundle: nil)
		
		
		
		self.clipsToBounds = true
		
		c = constraints.first as NSLayoutConstraint!
		
		if maxHeight == nil {

			maxHeight = self.frame.size.height
//			print(maxHeight)
		}
		
		/*
		
		if let height = constraints.first as NSLayoutConstraint!  {
//			self.removeConstraint(height)
		}
		*/
//		print(buttonView)
		
		
		bottomVIew.addSubview(buttonView)
	
		buttonView.frame.origin = CGPointZero
		
		buttonView.translatesAutoresizingMaskIntoConstraints = false
		
		let viewsDictionary = ["view": buttonView]
		
		bottomVIew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		bottomVIew.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		
		
		if vc != nil {
			
			print("VC")
			viewToExpand(vc!)
		}
	}
	
	
	
	var v : UIView!
	var cc: NSLayoutConstraint!
	
	func viewToExpand(view: UIView) {
		
//		view.removeConstraints(view.constraints)
		
		view.autoresizingMask = UIViewAutoresizing.None
		view.translatesAutoresizingMaskIntoConstraints = false
		
		v = view
		
		

		view.frame = CGRectZero

		topInnerView.addSubview(view)
		topView.bringSubviewToFront(gradientView)

		let viewsDictionary = ["view": v]
		
		topInnerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		topInnerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary))
		
		if let height = topInnerView.constraints.first as NSLayoutConstraint!  {
			topInnerView.removeConstraint(height)		}
		
		topInnerView.layoutSubviews()
		
		
		
		
		var isHeight: Bool = false
		for _c in v.constraints {
			
			print(_c)
			
			
			if _c.secondItem == nil && _c.firstAttribute == NSLayoutAttribute.Height {
				
				isHeight = true
/*
				
				cc = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: v.frame.size.height)
				
				
				v.addConstraint(cc)*/
				
				break
				

			}
			
		
			//				}
			
			
			
			
		}
		
		if !isHeight {
			
			
			
			print("s")
			
			
			cc = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: v.frame.size.height)
			
			
			v.addConstraint(cc)
		}
		
		
		
//		print(view.frame)
		
		/*
		cc = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: view.frame.size.height)
		
		v.addConstraint(cc)

		*/
		

		
		
		
//		topInnerView.layoutSubviews()
		

//		cc = refreshHeightConstraint()
		
		
		
		
//		print(v.autoresizingMask)



		
//		print(topInnerView)
		
//		topInnerView.layoutIfNeeded()
		
//		print(v)
//		print(v.constraints)
		
		
//		print(v)
//		print(topInnerView)
		
		/*
		
		cc = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: 100)
		
		v.addConstraint(cc)

*/
		
		
	}
	
	override func layoutSubviews() {
//		super.layoutSubviews()
		print("aaaa")
		
//		
//		print("ss")
		
		
//		layoutIfNeeded()
		layoutSubviews(true)
		
//		layoutIfNeeded()
		
		
	}

	// Flags
	var flag_expanded = false
	
	
	
	var btnClosedTitle = "read more..."
	var btnOpenTitle = "read less..."
	
	
	
	
	func refreshHeightConstraint(special: Bool = false ) -> NSLayoutConstraint! {
		
		print(special)
		
		var isHeight: Bool! = false
		
		if v != nil {
			if !v.constraints.isEmpty {
				
			for _c in v.constraints {
				
				print(_c)
				
				
				
				/*
				
				if special {
					print("AAA")
					
					isHeight = true
					
					break
				
				} else {*/
				
					
					if _c.secondItem == nil && _c.firstAttribute == NSLayoutAttribute.Height {
						
						isHeight = true
						
//						print(_c)
						
						
						return _c.constant != 0 ? _c : nil

//						break
					}
//				}
				
				
				
				
			}
			}
			
			
			if !isHeight {
				
				print(v.constraints )
				
				for _c in v.constraints {
					
					print(_c)
					
					
					if _c.secondItem != nil && _c.secondAttribute == NSLayoutAttribute.Height  && _c.firstAttribute == NSLayoutAttribute.Height {
						
//						isHeight = true
						
						let cc = NSLayoutConstraint(item: v, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: v.frame.size.height)
						
						
						v.addConstraint(cc)
						
						print(_c)
						
						return cc
					}
					//				}
					
					
					
					
				}
				
		/*
				
				return refreshHeightConstraint(true)
				*/
				
			}
		}
		
		return nil
		
//		cc = nil
		
		
		

	}
	
	
	
	func layoutSubviews(action: Bool) {


		

//		cc = refreshHeightConstraint()
		
		
/*


		
		
		#if AKDEBUG
			print("Object ::::::: AKExpandView 1")
			print("Method ::::::: layoutSubviews")
			print("               - -")
			print("Properties ::: self > > > \(self)")
			print(":::::::::::::: topInnerView > > > \(topInnerView)")
			print(":::::::::::::: v > > > \(v)")
			print(":::::::::::::: v > > > \(v.constraints)")
			print("")
		#endif

		*/
		
		
		if v != nil {
//			v.layoutIfNeeded()
			
//			topInnerView.layoutIfNeeded()
			v.sizeToFit()
//			topInnerView.layoutSubviews()
			
			
		
			topInnerView.frame.size.height = v.frame.size.height
			
			
//			v.constraints.first?.constant =  v.frame.size.height
			
		}
		
		
		
		let height: CGFloat = CGRectGetHeight(topInnerView.frame)
		
//		
//		v.constraints.first?.constant = height
		
		if cc != nil {
			
			cc.constant = height
			
			print("AAAASSSS")
//				cc.constant = height
		}

		/*
		
		print(v.constraints.first?.constant)
		
		cc.constant = (v.constraints.first?.constant)!
		
		*/

		if flag_expanded {
			
			if height <= 100 {
				
				topViewHeightConstraint.constant = height
				
				if c != nil {
					c.constant = height
				} else {
					if action {
						self.frame.size.height = height
					}
				}
				
				
			} else {
				
				topViewHeightConstraint.constant = height
				
				if c != nil {
					c.constant = height + CGRectGetHeight(buttonView.frame)
				} else {
					if action {
					
					self.frame.size.height = height + CGRectGetHeight(buttonView.frame)
					}
				}
				
				
			}
			
		} else {
			
			
				topViewHeightConstraint.constant = height > 100 ? 100 : height
			
				if c != nil {
					c.constant = height > 100 ? 100 + CGRectGetHeight(buttonView.frame) : height
				} else {
					if action {
						self.frame.size.height = height > 100 ? 100 + CGRectGetHeight(buttonView.frame) : height
					}
				}
			
					buttonViewHeightConstraint.constant = CGRectGetHeight(buttonView.frame)
		}
		

		if v.respondsToSelector(Selector("contentOffset")) {
			(v as! UIScrollView).contentOffset = CGPointZero
		}
		
		
		print("layoutSubviewssss")
		
		
//		topInnerView.layoutIfNeeded()
		/*
				#if AKDEBUG
					print("Object ::::::: AKExpandView 2")
					print("Method ::::::: layoutSubviews")
					print("               - -")
					print("Properties ::: self > > > \(self)")
					print(":::::::::::::: topInnerView > > > \(topInnerView)")
					print(":::::::::::::: v > > > \(v)")
					print(":::::::::::::: v > > > \(v.constraints.first?.constant)")
					print("")
				#endif*/


//		v.constraints.first?.constant = height
		
//		v.layoutSubviews()
//		v.layoutIfNeeded()
//		v.sizeToFit()

	}
	
	
	
	// MARK: - Actions
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBAction func btnAction(sender: AnyObject) {
		
		if flag_expanded {
			
			flag_expanded = false
//			btn.setTitle(btnOpenTitle, forState: UIControlState.Normal)
			
		} else {
			
			flag_expanded = true
//			btn.setTitle(btnClosedTitle, forState: UIControlState.Normal)
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
