//
//  AKToggleView.swift
//  Edu Caching
//
//  Created by Artem Krachulov on 7/30/16.
//  Copyright © 2016 Artem Krachulov. All rights reserved.
//

import UIKit

public enum AKToggleActionViewPosition {
  /// Default
  case Bottom
  case Top
}

public class AKToggleView: UIView {
  
  /*
  @IBOutlet weak var expandWrapperView_superView_TopConstraint: NSLayoutConstraint!
  
  
  
  
  var actionViewPosition: AKToggleActionViewPosition = .Top  {
    didSet {
      addActionView(actionViewPosition)
    }
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    addActionView(actionViewPosition)
  }
  
  
  
  
  
  override func layoutSubviews(action: Bool) {
  
    
    
    
    if expandView != nil {
      //			print(expandView)
      expandView.sizeToFit()
      //      print(expandView.constraints)
      
      expandContainerView.frame.size.height = expandView.frame.size.height
    }
    
    let height: CGFloat = CGRectGetHeight(expandContainerView.frame)
    /*
    if expandViewHeightContraint != nil {
      expandViewHeightContraint.constant = height
    }*/
    
    expandWrapperViewHeightConstraint.constant = height
    
    
    expandWrapperView_superView_TopConstraint.constant = CGRectGetHeight(actionView.frame)
    
    if flag_expanded {
      
      print("expanded")
      
      heightConstraint.constant = height + CGRectGetHeight(actionView.frame)
      
    } else {
      
      
      if heightConstraint != nil {
        
        heightConstraint.constant = CGRectGetHeight(actionView.frame)
        
      } else {
//        frame.size.height = 0
   
      }
      
    
    }
  }
  */
  

}