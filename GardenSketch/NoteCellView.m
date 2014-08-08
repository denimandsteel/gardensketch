//
//  NoteCellView.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NoteCellView.h"
#import "Constants.h"

@implementation NoteCellView {
	BOOL isInViewMode;
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
	isInViewMode = NO;
	[self.delegate willSwitchToEditMode:self];
	[self.bodyTextView setText:self.bodyLabel.text];
	[self.bodyLabel setHidden:YES];
	[self.bodyTextView setHidden:NO];
	[self.bodyTextView becomeFirstResponder];
	[self.letterLabel setTextColor:[UIColor whiteColor]];
	[self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.deleteButton setImage:[UIImage imageNamed:@"Done"] forState:UIControlStateNormal];
	[UIView animateWithDuration:.3 animations:^{
		[self setBackgroundColor:GS_COLOR_ACCENT_BLUE];
	}];
}

- (void) switchToViewMode
{
	isInViewMode = YES;
	[self.bodyLabel setText:self.bodyTextView.text];
	[self.bodyLabel setHidden:NO];
	[self.bodyTextView setHidden:YES];
	[self.letterLabel setTextColor:GS_COLOR_DARK_GREY_TEXT];
	[self.deleteButton setTitleColor:GS_COLOR_DARK_GREY_TEXT forState:UIControlStateNormal];
	[self.deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
	[self endEditing:YES];
	[UIView animateWithDuration:.3 animations:^{
		[self setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	}];
}

- (IBAction)deleteTapped:(id)sender {
	if (isInViewMode) {
		[self.delegate removeNoteForCell:self];
	} else {
		[self switchToViewMode];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self switchToViewMode];
	[self.delegate updateNoteForCell:self];
}

@end
