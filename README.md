LMAlertView
===========

`LMAlertView` aims to be an end-to-end, customisable clone of `UIAlertView` for iOS 7. Identical frost/gaussian blur effect, colours, CALayer animations.

I rushed this together in a few days so it isn't quite perfect, but almost there!

Spot the difference!

![UIAlertView](http://lmcd.me/UIAlertView-cutout.png)![LMAlertView](http://lmcd.me/LMAlertView-cutout.png)

Star rating demo:

![LMAlertView-review@2x](http://lmcd.me/LMAlertView-review@2x.png)

Credit card selection demo:

![LMAlertView-review@2x](http://lmcd.me/LMAlertView-card@2x.png)

Video:
- https://youtube.com/watch?v=G6n7oNL0-S8&feature=youtu.be (YouTube)
- http://lmcd.me/LMAlertView-3.mov (Original)

## Installation

Use the awesome CocoaPods to add `LMAlertView` to your project:

    pod 'LMAlertView', :git => 'https://github.com/lmcd/LMAlertView.git'

## Usage

    LMAlertView *alertView = [[LMAlertView alloc] initWithTitle:@"Test"
                                                        message:@"Message here"
                                                       delegate:nil
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
                                           
    // Add your subviews here to customise
    UIView *contentView = alertView.contentView;
    
    [alertView show];
