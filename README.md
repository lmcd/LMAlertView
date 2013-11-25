LMAlertView
===========

`LMAlertView` aims to be an end-to-end, customisable clone of `UIAlertView` for iOS 7. Identical frost/gaussian blur effect, colours, `CALayer` animations.

I rushed this together in a few days so it isn't quite perfect, but almost there!

Spot the difference!

<img src="http://lmcd.me/LMAlertView-custom@2x.png" width="320"><img src="http://lmcd.me/LMAlertView-native@2x.png" width="320">

Star rating demo:

![LMAlertView-review@2x](http://lmcd.me/LMAlertView-review@2x.png?2)

Credit card selection demo:

![LMAlertView-card@2x](http://lmcd.me/LMAlertView-card@2x.png?2)

Work in progress - embedded view controllers:

![LMAlertView-storyboard@2x](http://lmcd.me/LMAlertView-storyboard.png)

<img src="http://lmcd.me/LMAlertView-map1@2x.png" width="320"><img src="http://lmcd.me/LMAlertView-map2@2x.png" width="320">

Video:
- https://youtube.com/watch?v=G6n7oNL0-S8&feature=youtu.be (YouTube)
- http://lmcd.me/LMAlertView-3.mov (Original)

## Installation

Use the awesome [CocoaPods](http://cocoapods.org/) to add `LMAlertView` to your project:

```ruby
pod 'LMAlertView', :git => 'https://github.com/lmcd/LMAlertView.git'
```

## Usage

```objc
LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:@"Test"
                                            message:@"Message here"
                                           delegate:nil
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles:nil];

// Add your subviews here to customise
UIView *contentView = alertView.contentView;

[alertView show];
```
