//
//  NoteCellView.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NoteCellView.h"

@implementation NoteCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) switchToEditMode
{
	return;
	[self.bodyTextView setText:nil];
	[self.bodyTextView setText:self.bodyLabel.text];
	[self.bodyLabel setHidden:YES];
	[self.bodyTextView setHidden:NO];
}

- (void) switchToViewMode
{
	[self.bodyLabel setText:self.bodyTextView.text];
	[self.bodyLabel setHidden:NO];
	[self.bodyTextView setHidden:YES];
}

- (IBAction)deleteTapped:(id)sender {
	[self.delegate removeNoteForCell:self];
}

- (IBAction)editTapped:(id)sender {
	[self switchToEditMode];
}

@end
