//
//  LMModalItemTableViewCell.m
//  LMAlertViewDemo
//
//  Created by Lee McDermott on 11/12/2013.
//  Copyright (c) 2013 Bestir Ltd. All rights reserved.
//

#import "LMModalItemTableViewCell.h"

@implementation LMModalItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		
		self.textLabel.textAlignment = NSTextAlignmentCenter;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		
		UIView *contentView = self.contentView;
		
		_lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentView.frame.size.height - 0.5, contentView.frame.size.width, 0.5)];
		_lineView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
		_lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[contentView addSubview:_lineView];
    }
    return self;
}

- (void)tintColorDidChange
{
	self.textLabel.textColor = self.tintColor;
}

- (void)setIsEnabled:(BOOL)isEnabled
{
	_isEnabled = isEnabled;
	self.textLabel.enabled = isEnabled;
	self.userInteractionEnabled = isEnabled;
}

@end
