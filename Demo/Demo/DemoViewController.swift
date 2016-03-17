//
//  DemoViewController.swift
//  Demo
//
//  Created by Krachulov Artem.
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, UIActivityWebViewDelegate {
	
	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBOutlet weak var expandView: AKExpandView!
	
	@IBOutlet weak var label: UILabel!
	
	@IBOutlet weak var textView: UITextView!
	
	@IBOutlet weak var imageView: UIImageView!
	
	
	@IBOutlet weak var activityWebView: UIActivityWebView!  {
		didSet {
			activityWebView.delagate = self
		}
	}
	
	var progLabel: UILabel!
	
	var progTextView: UITextView!
	
	var progImageView: UIImageView!
	@IBOutlet weak var progImageViewHeightConstraint: NSLayoutConstraint!
	
	var progActivityWebView: UIActivityWebView!
	
	// MARK: - Properties
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	var type: String!

	let text = [
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
		"Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.",
		"Vivamus",
		"Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex. Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat."
	]
	
	let html = [
		"<h2>Lorem Ipsum is simply dummy</h2><p>text of the printing and typesetting industry.</p><img srg=\"http://lorempixel.com/300/150/sports/\"><p>Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p><p>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p><h1>It was popularised</h1><p>In the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>",
		"<p>Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.</p>",
		"<p>Vivamus</p><img srg=\"http://lorempixel.com/100/100/city/\">",
		"<img srg=\"http://lorempixel.com/200/150/abstract/\"><p>Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex.</p><p>Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat.</p><img srg=\"http://lorempixel.com/400/300/animals/\">"
	]
	
	
	
	
	func random(max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(max)))
	}

	
	// MARK: - Properties
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if type != nil {
			switch type {
			case "UILabel":
				
				progLabel = UILabel()
				progLabel.numberOfLines = 0
				
				expandView.viewToExpand(progLabel)
				
				progLabel.text = text[random(text.count)]
				
			case "UITextView":
				
				progTextView = UITextView()
				progTextView.scrollEnabled = false
				progTextView.font = UIFont(name: "Helvetica", size: 17)
				
				expandView.viewToExpand(progTextView)
				
				progTextView.text = text[random(text.count)]

			case "UIImageView":
				
				progImageView = UIImageView()
				progImageView.contentMode = UIViewContentMode.ScaleAspectFit
				
				expandView.viewToExpand(progImageView)
				
				progImageView.image = UIImage(named: "img\(random(3))")
				
			case "UIActivityWebView":
				
				progActivityWebView = UIActivityWebView()
				progActivityWebView.delagate = self
				
				expandView.viewToExpand(progActivityWebView)

				progActivityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
				
			default: ()
			}
		}
		
		if let id = self.restorationIdentifier {
			switch id {
			case "scroll-vc-web", "single-vc-web":
				
				activityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
				
			default: ()
			}
		}
	}
	
	// MARK: - UIActivityWebViewDelegate
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func webViewDidFinishLoad(webView: UIActivityWebView) {
		expandView.layoutSubviews()
	}
	
	@IBAction func switchAction(sender: AnyObject) {

		switch (type ?? self.restorationIdentifier)! {
			case "UILabel":
				
				progLabel.text = text[random(text.count)]
			
			case "single-vc-label", "scroll-vc-label":
				
				label.text = text[random(text.count)]
			
			case "UITextView":
				
				progTextView.text = text[random(text.count)]
			
			case "single-vc-textarea", "scroll-vc-textarea":
				
				textView.text = text[random(text.count)]
			
			case "UIImageView":
				
				progImageView.image = UIImage(named: "img\(random(3))")
	
			case "single-vc-image", "scroll-vc-image":
				
				imageView.image = UIImage(named: "img\(random(3))")

			case "UIActivityWebView":
				
				progActivityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	
			case "single-vc-web", "scroll-vc-web":
				
				activityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
			
			default: ()
		}

		expandView.layoutSubviews()
	}
}
