//
//  DemoViewController.swift
//  AKExpandView demo
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit

final class DemoViewController: UIViewController {
  
  //  MARK: - Properties
  @IBOutlet weak var scrollView: UIView!
  @IBOutlet weak var expandView: AKExpandView! {
    didSet {
      expandView.delegate = self
    }
  }
  
  internal var type: String!
  
  // Storyboard
  
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var activityWebView: AKActivityWebView!  {
		didSet {
			activityWebView.delegate = self
      activityWebView.webView.scrollView.scrollEnabled = false

      activityWebView.backgroundColor = UIColor.clearColor()
      activityWebView.webView.opaque = false
      activityWebView.webView.backgroundColor = UIColor.clearColor()
//      activityWebView.webView.scrollView.backgroundColor = UIColor.clearColor()
      
		}
	}
	
  // Programmatically

  lazy private var progLabel: UILabel! = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = self.text[self.random(self.text.count)]
    return label
  }()
  lazy private var progTextView: UITextView! = {
    let textView = UITextView()
    textView.scrollEnabled = false
    textView.font = UIFont(name: "Helvetica", size: 17)
    textView.backgroundColor = UIColor.clearColor()
    textView.text = self.text[self.random(self.text.count)]
    return textView
  }()
  lazy private var progImageView: UIImageView! = {
    let imageView = UIImageView()
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    imageView.image = UIImage(named: "img\(self.random(3))")
    return imageView
  }()
  lazy private var progActivityWebView: AKActivityWebView! =  {
    let activityWebVi = AKActivityWebView()
    activityWebVi.delegate = self
    activityWebVi.webView.scrollView.scrollEnabled = false
    activityWebVi.webView.opaque = true
    
    return activityWebVi
 }()
	
	// MARK: - Other

	private let text = [
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
		"Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.",
		"Vivamus",
		"Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex. Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat."
	]
	
	private let html = [
		"<h2>Lorem Ipsum is simply dummy</h2><p>text of the printing and typesetting industry.</p><img srg=\"http://lorempixel.com/300/150/sports/\"><p>Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p><p>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p><h1>It was popularised</h1><p>In the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>"/*,
		"<p>Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.</p>",
		"<p>Vivamus</p><img srg=\"http://lorempixel.com/100/100/city/\">",
		"<img srg=\"http://lorempixel.com/200/150/abstract/\"><p>Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex.</p><p>Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat.</p><img srg=\"http://lorempixel.com/400/300/animals/\">"*/
	]
	
	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
    
    #if AKExpandViewDEBUG
      if scrollView != nil {
        scrollView?.backgroundColor = UIColor.grayColor()
      } else {
        view.backgroundColor = UIColor.grayColor()
      }
    
    expandView.gradienColor = UIColor.grayColor()
    #endif
    
    let toolbar = UIToolbar()
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    toolbar.items = [
      UIBarButtonItem(title: "Toggle", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(toggleAction)),
      UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Expand", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(expandAction)),
      UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Collapse", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(collapseAction)),
    ]
    
    view.addSubview(toolbar)
    view.bringSubviewToFront(toolbar)
    
    toolbar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    toolbar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    toolbar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    
		if type != nil {
      navigationItem.title = "\(type) \(navigationItem.title!)"
			switch type {
			case "UILabel": expandView.viewToExpand(progLabel)
			case "UITextView": expandView.viewToExpand(progTextView)
			case "UIImageView": expandView.viewToExpand(progImageView)
			case "AKActivityWebView":
        
        expandView.viewToExpand(progActivityWebView)
//        progActivityWebView.webView.loadHTMLString(self.html[self.random(self.html.count)], baseURL: nil)
        
			default: ()
			}
		}


	}

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    print("viewDidAppear")
    print(" ")
    print(" ")
    print(" ")
    print(" ")
    print(" ")
    print(" ")
    if let id = self.restorationIdentifier {
      switch id {
      case "constraints-AKActivityWebView", "clear-AKActivityWebView": ()
      
      
        print(activityWebView.webView.request)
        
        
        activityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
        
        print(activityWebView.webView.request)
        
      default: ()
      }
    }
    
  }

	@IBAction func switchAction(sender: AnyObject) {

		switch (type ?? self.restorationIdentifier)! {
			case "UILabel":
				
				progLabel.text = text[random(text.count)]
			
			case "constraints-UILabel", "clear-UILabel":
				
				label.text = text[random(text.count)]
			
			case "UITextView":
				
				progTextView.text = text[random(text.count)]
			
			case "constraints-UITextView", "clear-UITextView":
				
				textView.text = text[random(text.count)]
			
			case "UIImageView":
				
				progImageView.image = UIImage(named: "img\(random(3))")
	
			case "constraints-UIImageView", "clear-UIImageView":
				
				imageView.image = UIImage(named: "img\(random(3))")

			case "AKActivityWebView":
				
				progActivityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	
			case "constraints-AKActivityWebView", "clear-AKActivityWebView":
				
        
        
				activityWebView.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
			
			default: ()
		}

    expandView.layoutSubviews()
	}
  
  func toggleAction() {
    expandView.toggle(true)
  }
  
  func expandAction() {
    expandView.expand(true)
  }
  func collapseAction() {
    expandView.collapse(true)
  }
  
  private func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }
}

extension DemoViewController: AKExpandViewDelegate {
  func expandView(expandView: AKExpandView, willCollapseView viewToExpand: UIView) {
    print("willCollapseView")
  }
  func expandView(expandView: AKExpandView, didCollapseView viewToExpand: UIView) {
    print("didCollapseView")
  }
  func expandView(expandView: AKExpandView, willExpandView viewToExpand: UIView) {
    print("willExpandView")
  }
  func expandView(expandView: AKExpandView, didExpandView viewToExpand: UIView) {
    print("didExpandView")
  }
}

extension DemoViewController: AKActivityWebViewDelegate {
  
  func wwebViewDidFinishLoad(webView: AKActivityWebView) {
    
    print("wwebViewDidFinishLoad")
    print(activityWebView.webView.request)
    
    expandView.layoutSubviews()
  }
  
}
