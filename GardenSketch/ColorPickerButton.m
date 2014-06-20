//
//  ColorPickerButton.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-20.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "ColorPickerButton.h"

@implementation ColorPickerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) showColors:(id)sender
{
//    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if (!popover_) {
        colorController = [[ColorPickerViewController alloc] initWithColors:self.colors];
		
		[colorController setPreferredContentSize:CGSizeMake(200, self.colors.count * 40)];
        
        popover_ = [[UIPopoverController alloc] initWithContentViewController:colorController];

        popover_.delegate = self;
        
        [popover_ presentPopoverFromRect:self.bounds inView:self permittedArrowDirections:UIPopoverArrowDirectionUp|UIPopoverArrowDirectionLeft animated:NO];
    }
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == popover_) {
        popover_ = nil;
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
