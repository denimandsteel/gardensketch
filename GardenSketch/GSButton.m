//
//  GSButton.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-25.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSButton.h"
#import "Constants.h"

@implementation GSButton

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
	[self.titleLabel setFont:GS_FONT_AVENIR_BODY];
	[self setTitleColor:GS_COLOR_DARK_GREY_TEXT forState:UIControlStateNormal];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	[self setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	[self.layer setCornerRadius:2.0];
	[self.layer setMasksToBounds:YES];
	
//	[[self layer] setBorderWidth:1.2f];
//	[[self layer] setBorderColor:GS_COLOR_PEACHY_HIGHLIGHT.CGColor];

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
