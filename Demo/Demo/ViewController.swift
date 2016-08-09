//
//  ViewController.swift
//  AKExpandView demo
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit

final class ViewController: UIViewController {
  
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let typesViewController = segue.destinationViewController as? TypesViewController {
      
			typesViewController.constraints = segue.identifier == "constraints"
		}
	}
}