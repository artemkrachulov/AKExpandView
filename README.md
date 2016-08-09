# AKExpandView

**`AKExpandView`** is lightweight Swift plugin for collapsing and expanding views, with adding "Read more..." and "Read less..." action button.

## Features

* Animation support
* Supported all UIKit views (UILabel, UIImageView, etc.)
* Lightweight
* Customizable

## Usage

```swift
@IBOutlet weak var expandView: AKExpandView!

override func viewDidLoad() {
    super.viewDidLoad()

    var label = UILabel()
    label.numberOfLines = 0
	label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
	
	expandView.viewToExpand(label)
}
```

---

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation

1. Clone or download demo project.
2. Add `AKExpandView` folder to your project.

## Set up

### Content heights

```swift
var collapsedHeight: CGFloat!
```
Content view height when action button will be showed (collapsed state).    
The initial value of this property equals to height when expand view was initialized.

```swift
var expandedHeight: CGFloat!
```
Content view heigth after expand. Useful for UIImageView.   
The initial value of this property is `nil`.

### Gradient

```swift
var gradientEnabled: Bool
```
Show or hide gradient view.   
The initial value of this property is `true`.

```swift
var gradientColor: UIColor! { get set }
```
Color for gradient view.    
The initial value of this property is `UIColor.whiteColor()`. Starts from alpha 0 ends on alpha 1.

```swift
var gradientHeightRatio: CGFloat! { get set }
```

Aspect ratio of expand view (collapsed state) and gradient view heights.    
The initial value of this property is `0.8`.

### Titles

```swift
var moreTitle: String! { get set }
```
Title for action button when expand view is collapsed.   
The initial value of this property is `read more...`.

```swift
var lessTitle: String! { get set }
```
Title for action button when expand view is expanded.   
The initial value of this property is `read less...`

### Layout and spaces

```swift
var actionBtnHeight: CGFloat { get set }
```
Height for action button.   
The initial value of this property is `50` px.

```swift
var spaceHeight: CGFloat { get set }
```
Space between action button and content view.   
The initial value of this property is `16` px.

## Animation

```swift
var animationEnabled: Bool
```
A Boolean value that determines whether animation is enabled.   
The initial value of this property is `false`.

```swift
var animationOptions: AKActivityWebViewAnimationOptions
```
Animation options.

Parameters:

- `duration` : The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
- `option` : A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.

## Flags

```swift
var isExpanded: Bool {get}
```
A Boolean value indicating whether the expand view is expanded. (read-only).    
The initial value of this property is `false`. Resets after adding new subview.

## Objects

```swift
var expandView: UIView {get}
```
The view for processing. (read-only). 


## Accessing the Delegate

```swift
weak var delegate: AKExpandViewDelegate?
```

The delegate object to receive update events.

### AKExpandViewDelegate

```swift
optional func expandView(expandView: AKExpandView, willExpandView view: UIView)
```
Tells the delegate when view will be expanded.

Parameters:

- `expandView` : The main object.
- `view` : Target view to expand.

```swift
optional func expandView(expandView: AKExpandView, didExpandView expandedView: UIView)
```
Tells the delegate when view was expanded.

Parameters:

- `expandView` : The main object.
- `expandedView` : Expanded view.

```swift
optional func expandView(expandView: AKExpandView, willCollapseView view: UIView)
```
Tells the delegate when view will be collapsed.

Parameters:

- `expandView` : The main object.
- `view` :  Target view to collapse.

```swift
optional func expandView(expandView: AKExpandView, didCollapseView collapsedView: UIView)
```
Tells the delegate when view was collapsed.

Parameters:

- `expandView` : The main object.
- `collapsedView` :  Collapsed view.

---

Please do not forget to ★ this repository to increases its visibility and encourages others to contribute.

### Author

Artem Krachulov: [www.artemkrachulov.com](http://www.artemkrachulov.com/)
Mail: [artem.krachulov@gmail.com](mailto:artem.krachulov@gmail.com)

### License

Released under the [MIT license](http://www.opensource.org/licenses/MIT)