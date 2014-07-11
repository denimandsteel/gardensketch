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
	[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[self setBackgroundColor:[UIColor colorWithWhite:249/255.0 alpha:1.0]];
	[self.layer setCornerRadius:2.0];
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
