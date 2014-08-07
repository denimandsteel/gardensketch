//
//  PropertyShapeButton.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-04.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "PropertyShapeButton.h"
#import "Constants.h"

@implementation PropertyShapeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self initialize];
	}
	
	return self;
}

- (void)initialize
{
	[[self layer] setBorderWidth:2.0f];
	[[self layer] setBorderColor:GS_COLOR_ACCENT_BLUE.CGColor];
	self.backgroundColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	
	
	if (highlighted) {
		[UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.backgroundColor = GS_COLOR_CANVAS;
		} completion:^(BOOL success){}];
	} else {
		[UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.backgroundColor = [UIColor whiteColor];
		} completion:^(BOOL success){}];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
