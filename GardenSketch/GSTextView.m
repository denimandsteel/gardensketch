//
//  GSTextView.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-17.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSTextView.h"
#import "Constants.h"

@implementation GSTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
	[self setFont:GS_FONT_AVENIR_BODY];
	[self.layer setCornerRadius:3.0];
	[self.layer setMasksToBounds:YES];
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
