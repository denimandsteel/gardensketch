//
//  GSLabelHead.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-25.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSLabelHead.h"
#import "Constants.h"

@implementation GSLabelHead

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
	[self setTextColor:GS_COLOR_DARK_GREY];
	[self setFont:GS_FONT_AVENIR_HEAD];
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
