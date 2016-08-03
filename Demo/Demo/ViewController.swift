//
//  ViewController.swift
//  Demo
//
//  Created by Krachulov Artem  on 2/25/16.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let typesViewController = segue.destinationViewController as? TypesViewController {
      
			typesViewController.constraints = segue.identifier == "constraints"
		}
	}
}