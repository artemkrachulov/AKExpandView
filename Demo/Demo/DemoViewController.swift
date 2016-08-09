//
//  DemoViewController.swift
//  Demo
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//  Website: http://www.artemkrachulov.com/
//

import UIKit

final class DemoViewController: UIViewController {
  
  //  MARK: - Properties

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
      activityWebView.activityIndicator.color = UIColor.blackColor()
      activityWebView.adjustingDimensions = .Enable
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
    let activityWebView = AKActivityWebView()
    activityWebView.delegate = self
    activityWebView.opaque = false
    activityWebView.backgroundColor = UIColor.whiteColor()
    activityWebView.activityIndicator.color = UIColor.blackColor()
    activityWebView.adjustingDimensions = .Enable
    return activityWebView
 }()
	
	// MARK: - Other

	final let text = [
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
		"Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.",
		"Vivamus",
		"Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex. Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat."
	]
	
	final let html = [
		"<h2>Lorem Ipsum is simply dummy</h2><p>text of the printing and typesetting industry.</p><img srg=\"http://lorempixel.com/300/150/sports/\"><p>Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p><p>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p><h1>It was popularised</h1><p>In the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>",
		"<p>Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.</p>",
		"<p>Vivamus</p><img srg=\"http://lorempixel.com/100/100/city/\">",
		"<img srg=\"http://lorempixel.com/200/150/abstract/\"><p>Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex.</p><p>Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat.</p><img srg=\"http://lorempixel.com/400/300/animals/\">"
	]
	
	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()    
    
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
    if #available(iOS 9.0, *) {
      toolbar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
      toolbar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
      toolbar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    } else {
      let viewsDictionary = ["toolbar": toolbar]
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[toolbar]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[toolbar]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: viewsDictionary))
    }
    
		if type != nil {
      navigationItem.title = "\(type) \(navigationItem.title!)"
			switch type {
			case "UILabel": expandView.viewToExpand(progLabel)
			case "UITextView": expandView.viewToExpand(progTextView)
			case "UIImageView": expandView.viewToExpand(progImageView)
			case "AKActivityWebView": expandView.viewToExpand(progActivityWebView)
			default: ()
			}
		}
	}

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    activityWebView?.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
    progActivityWebView?.webView.loadHTMLString(self.html[self.random(self.html.count)], baseURL: nil)
  }

	@IBAction func switchAction(sender: AnyObject) {

    label?.text = text[random(text.count)]
    progLabel?.text = text[random(text.count)]
    textView?.text = text[random(text.count)]
    progTextView?.text = text[random(text.count)]
    imageView?.image = UIImage(named: "img\(random(3))")
    progImageView?.image = UIImage(named: "img\(random(3))")
    activityWebView?.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
    progActivityWebView?.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
    
    expandView.layoutSubviews()
	}
  
  @objc private func toggleAction() {
    expandView.toggle(true)
  }
  
  @objc private func expandAction() {
    expandView.expand(true)
  }
  
  @objc private func collapseAction() {
    expandView.collapse(true)
  }
  
  private func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }
}

//  MARK: - AKExpandViewDelegate

extension DemoViewController: AKExpandViewDelegate {
  
  func expandView(expandView: AKExpandView, willCollapseView view: UIView) {
    print("willCollapseView")
  }
  
  func expandView(expandView: AKExpandView, didCollapseView expandedView: UIView) {
    print("didCollapseView")
  }
  
  func expandView(expandView: AKExpandView, willExpandView view: UIView) {
    print("willExpandView")
  }
  
  func expandView(expandView: AKExpandView, didExpandView collapsedView: UIView) {
    print("didExpandView")
  }
}

extension DemoViewController: AKActivityWebViewDelegate {
  
  func activityWebViewFinishLoad(activityWebView: AKActivityWebView, webView: UIWebView) {
    expandView.layoutSubviews()
  }
}
