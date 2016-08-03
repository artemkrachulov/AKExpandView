//
//  TypesViewController.swift
//  Demo
//
//  Created by Krachulov Artem  on 3/2/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class TypesViewController: UIViewController {
  
  //  MARK: Properties

	var constraints: Bool!
	var id: String {
		return constraints == true ? "constraints" : "clear"
	}
  
	// MARK: - Actions
  
	@IBAction func labelProgAction(sender: AnyObject) {
		showVC(id, type: "UILabel")
	}
	@IBAction func textareaProgAction(sender: AnyObject) {
		showVC(id, type:"UITextView")
	}
	@IBAction func imageProgAction(sender: AnyObject) {
		showVC(id, type:"UIImageView")
	}
	@IBAction func webProgAction(sender: AnyObject) {
		showVC(id, type:"AKActivityWebView")
	}
	@IBAction func labelAction(sender: AnyObject) {
		showVC(id + "-UILabel")
	}
	@IBAction func textareaAction(sender: AnyObject) {
		showVC(id + "-UITextView")
	}
	@IBAction func imageAction(sender: AnyObject) {
		showVC(id + "-UIImageView")
	}
	@IBAction func webAction(sender: AnyObject) {
		showVC(id + "-AKActivityWebView")
	}
	
	// MARK: - Helper

	private func showVC(id: String, type: String! = nil) {
		
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! DemoViewController
				vc.type = type
		navigationController?.pushViewController(vc, animated: true)
	}
}
