//
//  TypesViewController.swift
//  Demo
//
//  Created by Krachulov Artem  on 3/2/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class TypesViewController: UIViewController {
	
	// MARK: - Preperties
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	var scroll: Bool!
	
	var id: String {
		return scroll == true ? "scroll-vc" : "single-vc"
	}
	
	// MARK: - Actions
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
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
		showVC(id, type:"UIActivityWebView")
	}

	@IBAction func labelAction(sender: AnyObject) {
		showVC(id + "-label", type: nil)
	}
	
	@IBAction func textareaAction(sender: AnyObject) {
		showVC(id + "-textarea", type: nil)
	}
	
	@IBAction func imageAction(sender: AnyObject) {
		showVC(id + "-image", type: nil)
	}
	
	@IBAction func webAction(sender: AnyObject) {
		showVC(id + "-web", type: nil)
	}
	
	// MARK: - Helper
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func showVC(id: String, type: String!) {
		
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(id) as! DemoViewController
				vc.type = type
		
		navigationController?.pushViewController(vc, animated: true)
	}
}
