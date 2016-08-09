//
//  TypesViewController.swift
//  AKExpandView demo
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit

final class TypesViewController: UIViewController {
  
  //  MARK: Properties

	internal var constraints: Bool!
	private var id: String {
		return constraints == true ? "constraints" : "clear"
	}
  
	// MARK: - Actions
  
	@IBAction func labelProgAction(sender: AnyObject) {
		showNextViewConstroller(id, type: "UILabel")
	}
  
	@IBAction func textareaProgAction(sender: AnyObject) {
		showNextViewConstroller(id, type:"UITextView")
	}
  
	@IBAction func imageProgAction(sender: AnyObject) {
		showNextViewConstroller(id, type:"UIImageView")
	}
  
	@IBAction func webProgAction(sender: AnyObject) {
		showNextViewConstroller(id, type:"AKActivityWebView")
	}
  
	@IBAction func labelAction(sender: AnyObject) {
		showNextViewConstroller(id + "-UILabel")
	}
  
	@IBAction func textareaAction(sender: AnyObject) {
		showNextViewConstroller(id + "-UITextView")
	}
  
	@IBAction func imageAction(sender: AnyObject) {
		showNextViewConstroller(id + "-UIImageView")
	}
  
	@IBAction func webAction(sender: AnyObject) {
		showNextViewConstroller(id + "-AKActivityWebView")
	}
	
	// MARK: - Helper

	private func showNextViewConstroller(id: String, type: String! = nil) {
		
		let nextViewConstroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! DemoViewController
				nextViewConstroller.type = type
		navigationController?.pushViewController(nextViewConstroller, animated: true)
	}
}
