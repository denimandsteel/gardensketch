//
//  NoteCellView.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NoteCellView.h"

@implementation NoteCellView {
	BOOL willBeRemoved;
}

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
	[self.delegate willSwitchToEditMode:self];
	[self.bodyTextView setText:self.bodyLabel.text];
	[self.bodyLabel setHidden:YES];
	[self.bodyTextView setHidden:NO];
	[self.bodyTextView becomeFirstResponder];
}

- (void) switchToViewMode
{
	[self.bodyLabel setText:self.bodyTextView.text];
	[self.bodyLabel setHidden:NO];
	[self.bodyTextView setHidden:YES];
}

- (IBAction)deleteTapped:(id)sender {
	willBeRemoved = YES;
	[self.delegate removeNoteForCell:self];
}

- (IBAction)editTapped:(id)sender {
	[self switchToEditMode];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSLog(@"Did end editing!");
	if (!willBeRemoved) {
		[self switchToViewMode];
		[self.delegate updateNoteForCell:self];
	}
}

@end
