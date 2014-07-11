//
//  GSSegmentedControl.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-10.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSSegmentedControl.h"
#import "Constants.h"

@implementation GSSegmentedControl

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
	[self setTitleTextAttributes:@{NSForegroundColorAttributeName:GS_COLOR_DARK_GREY,
								   NSFontAttributeName:GS_FONT_AVENIR_BODY}
						forState:UIControlStateNormal];
	
	self.tintColor = GS_COLOR_PEACHY_HIGHLIGHT;
	
	// The attributes dictionary can specify the font, text color, text shadow color, and text
	// shadow offset for the title in the text attributes dictionary
	
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
