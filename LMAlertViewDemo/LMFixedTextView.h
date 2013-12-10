//
//  LMFixedTextView.h
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 10/12/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const LMFixedTextAttributeName;

@interface LMFixedTextView : UITextView

@property (nonatomic) NSInteger prefixLength;
@property (nonatomic) NSInteger suffixLength;

@end
