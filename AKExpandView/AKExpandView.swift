//
//  AKExpandView.swift
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// v. 0.1
//

import UIKit

public struct AKExpandViewAnimationOptions {
  /// The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
  public var duration: NSTimeInterval
  /// A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
  public var option: UIViewAnimationOptions
}

//  MARK: - AKExpandViewDelegate

@objc public protocol AKExpandViewDelegate {
  
  /// Tells the delegate when view will be expanded.
  ///
  /// - parameter expandView: The main object.
  /// - parameter view: Target view to expand.
  optional func expandView(expandView: AKExpandView, willExpandView view: UIView)

  /// Tells the delegate when view was expanded.
  ///
  /// - parameter expandView: The main object.
  /// - parameter expandedView: Expanded view.
  optional func expandView(expandView: AKExpandView, didExpandView expandedView: UIView)
  
  /// Tells the delegate when view will be collapsed.
  ///
  /// - parameter expandView: The main object.
  /// - parameter view: Target view to collapse.
  optional func expandView(expandView: AKExpandView, willCollapseView view: UIView)
  
  /// Tells the delegate when view was collapsed.
  ///
  /// - parameter expandView: The main object.
  /// - parameter collapsedView: Collapsed view.
  optional func expandView(expandView: AKExpandView, didCollapseView collapsedView: UIView)
}

/// A lightweight Swift plugin for collapsing and expanding views, with adding "Read more..." and "Read less..." action button.
///
/// Example of usage:
///
/// ```
/// @IBOutlet weak var expandView: AKExpandView!
///
/// override func viewDidLoad() {
///   super.viewDidLoad()
///
///   var label = UILabel()
///   label.numberOfLines = 0
///   label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
///
///   expandView.viewToExpand(label)
/// }
/// ```
///
/// For more information click here [GitHub](https://github.com/artemkrachulov/AKExpandView)

public class AKExpandView: UIView {
  
  //  MARK: - Properties
  //  MARK:   Views & Constraints
  
  private var heightConstraint: NSLayoutConstraint?
  
  private var expandWrapperView: UIView!
  private var expandWrapperViewHeightConstraint: NSLayoutConstraint!
    //
    private var expandContainerView: UIView!
    private var expandContainerViewHeightConstraint: NSLayoutConstraint?
  
      /// A view which you want to expand
      private(set) var expandView: UIView!
      private var expandViewHeightContraint: NSLayoutConstraint?
  
    private var gradientView: AKExpandGradientView!
    private var gradientViewHeightConstraint: NSLayoutConstraint!
    private var gradientView_superView_bottomConstraint: NSLayoutConstraint!
  
  private var actionViewVericalSpaceConstraint: NSLayoutConstraint!
  private var actionView: UIView!
  private var actionBtnHeightConstraint: NSLayoutConstraint!
  public var actionBtn: UIButton!
  
  //  MARK: Set up
  //  MARK: Content heights
  
  /// Content view height when action button will be showed (collapsed state).
  /// The initial value of this property is height when expand view was initialized.
  public var collapsedHeight: CGFloat!
  
  /// Content view heigth after expand. Useful for UIImageView.
  /// The initial value of this property is `nil`
  public var expandedHeight: CGFloat!
  
  //  MARK: Gradient
  
  /// Show or hide gradient view.
  /// The initial value of this property is `true`.
  public var gradientEnabled = true
  
  /// Color for gradient view.
  /// The initial value of this property is `UIColor.whiteColor()`. Starts from alpha 0 ends on alpha 1.
  public var gradientColor: UIColor! {
    didSet {
      guard gradientView != nil else {
        return
      }
      
      let components = CGColorGetComponents(gradientColor.CGColor)
      
      var duplicateComponent: Bool = false
      if CGColorGetNumberOfComponents(gradientColor.CGColor) == 2 {
        duplicateComponent = true
      }
      
      gradientView.startColor = UIColor(red: components[0], green: duplicateComponent ? components[0] : components[1], blue: duplicateComponent ? components[0] : components[2], alpha: 0.0)
      gradientView.endColor = UIColor(red: components[0], green: duplicateComponent ? components[0] : components[1], blue: duplicateComponent ? components[0] : components[2], alpha: 1.0)
      
      gradientView.setNeedsDisplay()
    }
  }
  
  /// Aspect ratio of expand view (collapsed state) and gradient view heights.
  /// The initial value of this property is `0.8`.
  public var gradientHeightRatio: CGFloat! {
    didSet {
      guard collapsedHeight != nil else {
        return
      }
      gradientViewHeightConstraint?.constant = collapsedHeight * gradientHeightRatio
    }
  }
  
  //  MARK: Titles

  /// Title for action button when expand view is collapsed.
  /// The initial value of this property is `read more...`.
  public var moreTitle: String! {
    didSet {
      if !isExpanded {
		    actionBtn?.setTitle(moreTitle, forState: UIControlState.Normal)
      }
    }
  }
  
  /// Title for action button when expand view is expanded.
  /// The initial value of this property is `read less...`
  public var lessTitle = "read less..." {
    didSet {
      if isExpanded {
        actionBtn?.setTitle(lessTitle, forState: UIControlState.Normal)
      }
    }
  }
  
  //  MARK: Layout and spaces
  
  /// Height for action button.
  /// The initial value of this property is `50` px.
  public var actionBtnHeight: CGFloat = 50 {
    didSet {
      actionBtnHeightConstraint?.constant = actionBtnHeight
    }
  }
  
  /// Space between action button and content view.
  /// The initial value of this property is `16` px.
  public var spaceHeight: CGFloat = 16 {
    didSet {
      actionViewVericalSpaceConstraint?.constant = spaceHeight
    }
  }
  
  //  MARK: Animation
  
  /// A Boolean value that determines whether animation is enabled.
  /// The initial value of this property is `false`.
  public var enableAnimation = false
  
  /// Animation options
  ///
  /// - parameter duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
  /// - parameter options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
  public var animationOptions = AKExpandViewAnimationOptions(duration: 0.3, option: .CurveEaseInOut)
  
  //  MARK: Flags
  
  /// Current state of expand view.
  /// The initial value of this property is `false`. Resets after adding new subview.
  private(set) var isExpanded: Bool = false
  
  //  MARK: Accessing the Delegate
  
  /// Delegate
  weak var delegate: AKExpandViewDelegate?
  
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
    
    // Get subview to expand if exist
    let view = subviews.first
    
    // Clear all inner view to aviod conflicts
    removeSubviews(self)
    
    // Create UI
    createUI()
    
    // Setup UI
    clipsToBounds = true
    expandWrapperView.clipsToBounds = true
    expandWrapperView.backgroundColor = UIColor.clearColor()
    expandWrapperView.bringSubviewToFront(gradientView)
    expandContainerView.backgroundColor = UIColor.clearColor()
    gradientView.backgroundColor = UIColor.clearColor()
    gradientColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    actionView.backgroundColor = UIColor.clearColor()
    actionBtn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
    actionBtn.addTarget(self, action: #selector(toggleActionBtn), forControlEvents: UIControlEvents.TouchUpInside)
    moreTitle = "read more..."
    
    viewToExpand(view)
  }
  
  private func createUI() {
    
    expandWrapperView = UIView()
    expandWrapperView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(expandWrapperView)
    
    if #available(iOS 9.0, *) {
      expandWrapperView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
      expandWrapperView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
      expandWrapperView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
      
      expandWrapperViewHeightConstraint = expandWrapperView.heightAnchor.constraintEqualToConstant(0.0)
      expandWrapperViewHeightConstraint.active = true
 
    } else {
      let viewsDictionary = ["expandWrapperView": expandWrapperView]
      
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-0-[expandWrapperView]",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: viewsDictionary))
      
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[expandWrapperView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      
      expandWrapperViewHeightConstraint = NSLayoutConstraint(
        item: expandWrapperView,
        attribute: .Height,
        relatedBy: .Equal,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 0
      )
      
      expandWrapperView.addConstraint(expandWrapperViewHeightConstraint)
    }
  
    actionView = UIView()
    actionView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(actionView)
    
    if #available(iOS 9.0, *) {
      actionView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
      actionView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
      expandWrapperView.bottomAnchor.constraintEqualToAnchor(actionView.topAnchor).active = true
    } else {
      let viewsDictionary = ["actionView": actionView, "expandWrapperView": expandWrapperView ]
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[actionView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[expandWrapperView]-[actionView]",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: viewsDictionary))
    }
    
    actionBtn = UIButton()
    actionBtn.translatesAutoresizingMaskIntoConstraints = false
    actionView.addSubview(actionBtn)
    
    if #available(iOS 9.0, *) {
      let l = actionBtn.leadingAnchor.constraintLessThanOrEqualToAnchor(actionView.leadingAnchor)
      l.active = true
      l.priority = 250
      
     let t =  actionBtn.trailingAnchor.constraintLessThanOrEqualToAnchor(actionView.trailingAnchor)
      t.active = true
      t.priority = 250

      actionBtn.centerXAnchor.constraintEqualToAnchor(actionView.centerXAnchor).active = true
      
      actionViewVericalSpaceConstraint = actionBtn.topAnchor.constraintEqualToAnchor(actionView.topAnchor, constant: spaceHeight)        
      actionViewVericalSpaceConstraint.active = true
      
      actionBtnHeightConstraint = actionBtn.heightAnchor.constraintEqualToConstant(actionBtnHeight)
      actionBtnHeightConstraint.active = true
      
      actionBtn.bottomAnchor.constraintEqualToAnchor(actionView.bottomAnchor).active = true
    } else {
      let l = NSLayoutConstraint(
        item: actionBtn,
        attribute: .Leading,
        relatedBy: .Equal,
        toItem: actionView,
        attribute: .Leading,
        multiplier: 1,
        constant: 0
      )
      l.priority = 250
      
      let t = NSLayoutConstraint(
        item: actionBtn,
        attribute: .Trailing,
        relatedBy: .Equal,
        toItem: actionView,
        attribute: .Trailing,
        multiplier: 1,
        constant: 0
      )
      t.priority = 250
      
      let c = NSLayoutConstraint(
        item: actionBtn,
        attribute: .CenterX,
        relatedBy: .Equal,
        toItem: actionView,
        attribute: .CenterX,
        multiplier: 1,
        constant: 0
      )
      
      actionViewVericalSpaceConstraint = NSLayoutConstraint(
        item: actionBtn,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: actionView,
        attribute: .Top,
        multiplier: 1,
        constant: spaceHeight
      )
      
      actionBtnHeightConstraint = NSLayoutConstraint(
        item: actionBtn,
        attribute: .Height,
        relatedBy: .Equal,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: actionBtnHeight
      )
      
      actionBtn.addConstraint(actionBtnHeightConstraint)
      
      let b = NSLayoutConstraint(
        item: actionBtn,
        attribute: .Bottom,
        relatedBy: .Equal,
        toItem: actionView,
        attribute: .Bottom,
        multiplier: 1,
        constant: 0
      )
      
      actionView.addConstraints([l, t, c, actionViewVericalSpaceConstraint, b])
    }
    
    expandContainerView = UIView()
    expandContainerView.translatesAutoresizingMaskIntoConstraints = false
    expandWrapperView.addSubview(expandContainerView)
    
    if #available(iOS 9.0, *) {
      expandContainerView.topAnchor.constraintEqualToAnchor(expandWrapperView.topAnchor).active = true
      expandContainerView.leadingAnchor.constraintEqualToAnchor(expandWrapperView.leadingAnchor).active = true
      expandContainerView.trailingAnchor.constraintEqualToAnchor(expandWrapperView.trailingAnchor).active = true
      
      expandContainerViewHeightConstraint = expandContainerView.heightAnchor.constraintEqualToConstant(0.0)
      expandContainerViewHeightConstraint!.active = true
    } else {
      let viewsDictionary = ["expandContainerView": expandContainerView]
      
      expandWrapperView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-0-[expandContainerView]",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: viewsDictionary))
      
      expandWrapperView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[expandContainerView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      
      expandContainerViewHeightConstraint = NSLayoutConstraint(
        item: expandContainerView,
        attribute: .Height,
        relatedBy: .Equal,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 0
      )
      
      expandContainerView.addConstraint(expandContainerViewHeightConstraint!)
    }
    
    gradientView = AKExpandGradientView()
    gradientView.translatesAutoresizingMaskIntoConstraints = false
    expandWrapperView.addSubview(gradientView)
    
    if #available(iOS 9.0, *) {
      gradientView.leadingAnchor.constraintEqualToAnchor(expandWrapperView.leadingAnchor).active = true
      gradientView.trailingAnchor.constraintEqualToAnchor(expandWrapperView.trailingAnchor).active = true
    
      gradientView_superView_bottomConstraint = gradientView.bottomAnchor.constraintEqualToAnchor(expandWrapperView.bottomAnchor, constant: 0.0)
      gradientView_superView_bottomConstraint.active = true
      
      gradientViewHeightConstraint = gradientView.heightAnchor.constraintEqualToConstant(0.0)
      
      gradientHeightRatio = 0.8
      gradientViewHeightConstraint.active = true
    } else {
      let viewsDictionary = ["gradientView": gradientView]
      expandWrapperView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[gradientView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      
      gradientViewHeightConstraint = NSLayoutConstraint(
        item: gradientView,
        attribute: .Height,
        relatedBy: .Equal,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 0.0
      )
      gradientHeightRatio = 0.8
      
      gradientView.addConstraint(gradientViewHeightConstraint)
      
      gradientView_superView_bottomConstraint = NSLayoutConstraint(
        item: expandWrapperView,
        attribute: .Bottom,
        relatedBy: .Equal,
        toItem: gradientView,
        attribute: .Bottom,
        multiplier: 1,
        constant: 0
      )
      
      expandWrapperView.addConstraint(gradientView_superView_bottomConstraint)
    }
  }
  
  
  public func viewToExpand(view: UIView?) {
    guard let viewToExpand = view else {
      return
    }
 
    heightConstraint = heightContraint(self)
    
    // Clear all inner view to aviod conflicts
    
    isExpanded = false
    
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
    
    if #available(iOS 9.0, *) {
      viewToExpand.topAnchor.constraintEqualToAnchor(expandContainerView.topAnchor).active = true
      viewToExpand.bottomAnchor.constraintEqualToAnchor(expandContainerView.bottomAnchor).active = true
      viewToExpand.leadingAnchor.constraintEqualToAnchor(expandContainerView.leadingAnchor).active = true
      viewToExpand.trailingAnchor.constraintEqualToAnchor(expandContainerView.trailingAnchor).active = true                      
    } else {
      let viewsDictionary = ["viewToExpand": viewToExpand]
      expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-0-[viewToExpand]-0-|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views:
      viewsDictionary))
      
      expandContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-0-[viewToExpand]-0-|",
      options: NSLayoutFormatOptions(rawValue: 0),
      metrics: nil,
      views: viewsDictionary))
    }
    if expandViewHeightContraint != nil {
      expandContainerViewHeightConstraint?.constant = expandViewHeightContraint!.constant
    }
  }
  
  override public func layoutSubviews() {
    super.layoutIfNeeded()
    
    var height = collapsedHeight
    
    if let expandView = expandView {
      
      if !layoutBeforeAnimation {
        expandView.sizeToFit()
      }
      height = CGRectGetHeight(expandView.frame)
    }

    height = height <= 0 ? collapsedHeight : height
    
    if expandViewHeightContraint != nil {
      height = expandViewHeightContraint!.constant
    }
    
    expandContainerView.frame.size.height = height
    expandContainerViewHeightConstraint?.constant = height
    
    if expandViewHeightContraint != nil {
    } else {
      expandView.frame.size.height = height
    }
    
    var heightWithActionView = height
    
    var sign: CGFloat = -1.0
    if #available(iOS 9.0, *) {
      sign = 1.0
    }
    gradientView_superView_bottomConstraint.constant = isExpanded || (!isExpanded && height <= collapsedHeight) ? gradientView.frame.size.height * sign : 0
    
    if height > collapsedHeight {
      height = isExpanded ? height : collapsedHeight
      heightWithActionView = height + CGRectGetHeight(actionView.frame)
    }
    
    if !layoutBeforeAnimation {
      frame.size.height = heightWithActionView
    }
    
    heightConstraint?.constant = heightWithActionView
    expandWrapperViewHeightConstraint.constant = height
    
    super.layoutSubviews()
    
    #if AKExpandViewDEBUG
      print("\(self.dynamicType) \(#function)")
      print("AKExpandView: \(self.frame)")
      print("expandWrapperView: \(expandWrapperView.frame)")
      print("expandWrapperViewHeightConstraint: \(expandWrapperViewHeightConstraint.constant)")
      print("      expandContainerView: \(expandContainerView.frame)")
      print("      expandContainerViewHeightConstraint: \(expandContainerViewHeightConstraint?.constant)")
      print("            expandView: \(expandView.frame)")
      print("            expandViewHeightContraint: \(expandViewHeightContraint?.constant)")
      print("      gradientView: \(gradientView.frame)")
      print("      gradientView_superView_bottomConstraint: \(gradientView_superView_bottomConstraint.constant)")
      print("actionView: \(actionView.frame)")
      print("")
    #endif
  }
  
  private func _layoutSubviews(animated: Bool! = nil) {
    if let animated = animated {
      if animated {
        layoutSubviewsWithAnimation()
      } else {
        if isExpanded {
          delegate?.expandView?(self, willExpandView: expandView)
        } else {
          delegate?.expandView?(self, willCollapseView: expandView)
        }
        layoutSubviews()
        if isExpanded {
          delegate?.expandView?(self, didExpandView: expandView)
        } else {
          delegate?.expandView?(self, didCollapseView: expandView)
        }
      }
    } else {
      layoutSubviewsWithAnimation()
    }
  }
  
  private func layoutSubviewsWithAnimation() {
    if let superview = superview {
      if isExpanded {
        delegate?.expandView?(self, willExpandView: expandView)
      } else {
        delegate?.expandView?(self, willCollapseView: expandView)
      }
      layoutBeforeAnimation = true
      layoutSubviews()
      layoutBeforeAnimation = false
      UIView.animateWithDuration(animationOptions.duration, delay: 0, options: animationOptions.option, animations: {
        superview.layoutIfNeeded()
        }, completion: { done in
          if self.isExpanded {
            self.delegate?.expandView?(self, didExpandView: self.expandView)
          } else {
            self.delegate?.expandView?(self, didCollapseView: self.expandView)
          }
      })
    }
  }
  
  //  MARK: - Actions
  
  @objc private func toggleActionBtn() {
    actionBtn?.setTitle(isExpanded ? moreTitle : lessTitle, forState: UIControlState.Normal)
    isExpanded = !isExpanded
    _layoutSubviews(enableAnimation)
  }
  
  /// Toggle view to expand
  ///
  /// - parameter animated : Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
  
  public func toggle(animated: Bool! = nil) {
    actionBtn?.setTitle(isExpanded ? moreTitle : lessTitle, forState: UIControlState.Normal)
    isExpanded = !isExpanded
    _layoutSubviews(animated)
  }
  
  /// Calls expand action
  ///
  /// - parameter animated : Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
  
  public func expand(animated: Bool! = nil) {
    isExpanded = true
    actionBtn?.setTitle(lessTitle, forState: UIControlState.Normal)
    _layoutSubviews(animated)
  }
  
  /// Calls collapse action
  ///
  /// - parameter animated : Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
  
  public func collapse(animated: Bool! = nil) {
    isExpanded = false
    actionBtn?.setTitle(moreTitle, forState: UIControlState.Normal)
    _layoutSubviews(animated)
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