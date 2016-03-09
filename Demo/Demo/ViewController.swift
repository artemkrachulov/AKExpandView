//
//  ViewController.swift
//  Demo
//
//  Created by Krachulov Artem  on 2/25/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let i = UIImageView(frame: CGRectMake(0,0,100,100))
				i.image = UIImage(named: "img")
				view.addSubview(i)
		print("AA")
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let yourVC = segue.destinationViewController as? TypesViewController {
			yourVC.scroll = segue.identifier == "scroll"
		}
	}
	
	
	
	
}

