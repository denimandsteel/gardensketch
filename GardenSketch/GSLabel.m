//
//  GSLabel.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-25.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSLabel.h"
#import "Constants.h"

@implementation GSLabel

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
	[self setTextColor:GS_COLOR_DARK_GREY_TEXT];
	[self setFont:GS_FONT_AVENIR_BODY];
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
