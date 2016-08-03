//
//  AKExpandView.swift
//  Demo
//
//  Created by Krachulov Artem  on 2/25/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

public struct AKExpandViewAnimationOptions {
  public var duration: NSTimeInterval
  public var option: UIViewAnimationOptions
}



public class AKExpandView: UIView {
  
  //  MARK: - Outlets
  
  // Self
  private(set) public var heightConstraint: NSLayoutConstraint?
  
  // Wrapper
  @IBOutlet weak var expandWrapperView: UIView!
  @IBOutlet weak var expandWrapperViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var actionView: UIView!
  @IBOutlet weak var actionBtn: UIButton? {
    didSet {
      moreTitle = "read more..."
    }
  }
  
  // Container
  
  @IBOutlet weak var expandContainerView: UIView!
  @IBOutlet weak var expandContainerViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var gradientView: AKExpandGradientView! {
    didSet {
      
      expandWrapperView.bringSubviewToFront(gradientView)
      
//      gradientView.hidden = true
      gradientView.backgroundColor = UIColor.clearColor()
      
      gradienColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
  @IBOutlet weak var gradientViewHeightConstraint: NSLayoutConstraint!  {
    didSet {
		    gradientViewHeightConstraint.constant = 20
    }
  }
  
  
  @IBOutlet weak var gradientView_superView_bottomConstraint: NSLayoutConstraint!
  
  public var expandView: UIView!
  
  /// Height contraint if exist
  private(set) var expandViewHeightContraint: NSLayoutConstraint?

  
  
  //  MARK: Settings


  /// Current state of expand view
  var isExpanded = false
  
  /// Default value is initial expand view height
  var collapsedHeight: CGFloat!
  
  var fixedExpandedHeight: CGFloat!
  
  public var gradientViewEnabled = true
  
  public var moreTitle: String! {
    didSet {
      if !isExpanded {
		    actionBtn?.setTitle(moreTitle, forState: UIControlState.Normal)
      }
    }
  }
  
  public var lessTitle = "read less..." {
    didSet {
      if isExpanded {
        actionBtn?.setTitle(lessTitle, forState: UIControlState.Normal)
      }
    }
  }
  
  public var gradienColor: UIColor! {
    didSet {
      guard gradientView != nil else {
        return
      }

      gradientView.startColor = gradienColor.colorWithAlphaComponent(0)
      gradientView.endColor = gradienColor.colorWithAlphaComponent(1)
      
      gradientView.setNeedsDisplay()
    }
  }
  
  public var enableAnimation = true
  public var animationOptions: AKExpandViewAnimationOptions = AKExpandViewAnimationOptions(duration: 0.3, option: .CurveEaseInOut)
  
  
  /// If we need change non-constraint property in animation block
  private var layoutBeforeAnimation: Bool = false
  
  
  //  MARK: - Initializations
  
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  init() {
    super.init(frame: CGRectZero)
    setup()
  }
  
  private func setup() {
    // Grab height data
    
    collapsedHeight = CGRectGetHeight(frame)
    
    let vc = subviews.first
    
    // Clear all inner view
    // to aviod conflicts
    
    removeSubviews(self)
    
    loadFromNib(nil, bundle: nil)
    
    viewToExpand(vc)
  }
  
  
  public func viewToExpand(view: UIView?) {

    guard let viewToExpand = view else {
      return
    }
    
    heightConstraint = heightContraint(self)
    
    // Clear old views
    
    removeSubviews(expandContainerView)
    expandView = nil
    expandViewHeightContraint = nil
    
    // Save references to view to expand
    
    expandView = viewToExpand
    expandViewHeightContraint = heightContraint(viewToExpand)
    
    // Reset view and prepare to autolayout
    
    viewToExpand.frame = CGRectZero
    viewToExpand.autoresizingMask = UIViewAutoresizing.None
    viewToExpand.translatesAutoresizingMaskIntoConstraints = false
    
    expandContainerView.addSubview(viewToExpand)
    
    let viewsDictionary = ["view": viewToExpand]
    expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-0-[view]-0-|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary))
    expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-0-[view]-0-|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary))
    
    
    
    if let expandViewHeightContraint = expandViewHeightContraint {
       expandContainerViewHeightConstraint.constant = expandViewHeightContraint.constant
    }
    
    
    
    // Get height constraint
   /* expandContainerView.layoutSubviews()
    
    if heightContraint(viewToExpand) == nil {
      
      let newHeight = CGRectGetHeight(self.frame)
      
      //      print("newHeight \(newHeight)")
      
      viewToExpand.frame.size.height = newHeight
      expandViewHeightContraint = NSLayoutConstraint(item: viewToExpand,
                                                     attribute: NSLayoutAttribute.Height,
                                                     relatedBy: NSLayoutRelation.Equal,
                                                     toItem: nil,
                                                     attribute: NSLayoutAttribute(rawValue: 0)!,
                                                     multiplier: 1,
                                                     constant: newHeight)
      
      viewToExpand.addConstraint(expandViewHeightContraint)
    }*/
    
    
    
  }
  
  override public func layoutSubviews() {
    
    var height: CGFloat = collapsedHeight
    
    if let expandView = expandView {
      expandView.layoutIfNeeded()
      expandView.sizeToFit()
      height = expandView.frame.size.height
    }
    
    height = height <= 0 ? collapsedHeight : height
    
    if expandViewHeightContraint != nil {
      height = expandViewHeightContraint!.constant
    }
    
    expandContainerView.frame.size.height = height
    expandContainerViewHeightConstraint.constant = height
    
    
   
    var heightWithActionView = height
    
    if height > collapsedHeight {
      height = isExpanded ? height : collapsedHeight
      heightWithActionView = height + CGRectGetHeight(actionView.frame)
    }
    
    if !layoutBeforeAnimation {
      frame.size.height = heightWithActionView
    }
    
    heightConstraint?.constant = heightWithActionView
    expandWrapperViewHeightConstraint.constant = height
    gradientView_superView_bottomConstraint.constant = isExpanded || (!isExpanded && height <= collapsedHeight) ? -gradientView.frame.size.height : 0
    
    
    
    
    
    /*
    if isExpanded {
      if height <= collapsedHeight {
        
        heightConstraint?.constant = height
        expandWrapperViewHeightConstraint.constant = height
        
        if !layoutBeforeAnimation {
          frame.size.height = height
        }
      } else {
        
        heightConstraint?.constant = height + CGRectGetHeight(actionView.frame)
        expandWrapperViewHeightConstraint.constant = height
        
        gradientView_superView_bottomConstraint.constant = -gradientView.frame.size.height
        
        if !layoutBeforeAnimation {
          frame.size.height = height + CGRectGetHeight(actionView.frame)
        }
      }
    } else {
      if height <= collapsedHeight {
        
        heightConstraint?.constant = height
        expandWrapperViewHeightConstraint.constant = height
        
        gradientView_superView_bottomConstraint.constant = -gradientView.frame.size.height
        
        if !layoutBeforeAnimation {
          frame.size.height = height
        }
        
      } else {
        heightConstraint?.constant = collapsedHeight + CGRectGetHeight(actionView.frame)
        expandWrapperViewHeightConstraint.constant = collapsedHeight
        
        gradientView_superView_bottomConstraint.constant = 0
        
        if !layoutBeforeAnimation {
          frame.size.height = collapsedHeight + CGRectGetHeight(actionView.frame)
        }
      }
    }*/
  }
  
  

  private func layoutSubviewsWithAnumation() {
    if enableAnimation {
      if let superview = superview {
        layoutBeforeAnimation = true
        layoutSubviews()
        layoutBeforeAnimation = false
        UIView.animateWithDuration(animationOptions.duration, delay: 0, options: animationOptions.option, animations: {
          superview.layoutIfNeeded()
          }, completion: nil)
      }
      
    } else {
      layoutSubviews()
    }
  }
  
  // MARK: - Actions
  //         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  
  @IBAction func toggle(sender: AnyObject) {
    toggle()
  }
  
  
  public func toggle() {
    actionBtn?.setTitle(isExpanded ? moreTitle : lessTitle, forState: UIControlState.Normal)
    isExpanded = !isExpanded
    layoutSubviewsWithAnumation()
  }
  
  public func expand() {
    isExpanded = true
    actionBtn?.setTitle(lessTitle, forState: UIControlState.Normal)
    layoutSubviewsWithAnumation()
  }
  
  public func collapse() {
    isExpanded = false
    actionBtn?.setTitle(moreTitle, forState: UIControlState.Normal)
    layoutSubviewsWithAnumation()
  }
  
  
  
  //  MARK: Helper functions
  
  private func removeSubviews(view: UIView) {
    for subview in view.subviews {
      subview.removeFromSuperview()
    }
  }
  
  private func heightContraint(view: UIView) -> NSLayoutConstraint! {
    for constraint in view.constraints {
      if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.secondItem == nil {
        return constraint
      }
    }
    return nil
  }
}