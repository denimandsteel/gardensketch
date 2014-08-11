//
//  TooolCell.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-08-06.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "ToolCell.h"
#import "Constants.h"
#import "WDStencilTool.h"
#import "WDFreehandTool.h"
#import "WDShapeTool.h"
#import "WDToolManager.h"

#define COLOR_PICKER_LEFT 225.0

@implementation ToolCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	return self;
}

- (void)initialize
{
	[self setSelected:NO];
	[self.toolButton addTarget:self action:@selector(toolButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.toolNameLabel setText:self.toolButton.tool.toolName];
	[self.layer setCornerRadius:10.0];
	[self.layer setMasksToBounds:YES];
	[self.secondaryView setBackgroundColor:GS_COLOR_DARK_GREY_BACKGROUND];
	[self updateToolSubviews];
}

- (void)updateToolSubviews
{
	if ([self needColorPicker]) {
		[self.colorPicker setHidden:NO];
		[self.colorLabel setHidden:NO];
	} else {
		[self.colorPicker setHidden:YES];
		[self.colorLabel setHidden:YES];
	}
	
	if ([self.toolButton.tool isKindOfClass:[WDShapeTool class]] ||
		[self.toolButton.tool isKindOfClass:[WDFreehandTool class]]) {
		[self.smallButton setImage:[UIImage imageNamed:@"WidthSm_Inactive"] forState:UIControlStateNormal];
		[self.smallButton setImage:[UIImage imageNamed:@"WidthSm_Active"] forState:UIControlStateSelected];
		[self.mediumButton setImage:[UIImage imageNamed:@"WidthMd_Inactive"] forState:UIControlStateNormal];
		[self.mediumButton setImage:[UIImage imageNamed:@"WidthMd_Active"] forState:UIControlStateSelected];
		[self.largeButton setImage:[UIImage imageNamed:@"WidthLg_Inactive"] forState:UIControlStateNormal];
		[self.largeButton setImage:[UIImage imageNamed:@"WidthLg_Active"] forState:UIControlStateSelected];
	} else if ([self.toolButton.tool isKindOfClass:[WDStencilTool class]]) {
		[self.smallButton setImage:[UIImage imageNamed:@"SizeSm_Inactive"] forState:UIControlStateNormal];
		[self.smallButton setImage:[UIImage imageNamed:@"SizeSm_Active"] forState:UIControlStateSelected];
		[self.mediumButton setImage:[UIImage imageNamed:@"SizeMd_Inactive"] forState:UIControlStateNormal];
		[self.mediumButton setImage:[UIImage imageNamed:@"SizeMd_Active"] forState:UIControlStateSelected];
		[self.largeButton setImage:[UIImage imageNamed:@"SizeLg_Inactive"] forState:UIControlStateNormal];
		[self.largeButton setImage:[UIImage imageNamed:@"SizeLg_Active"] forState:UIControlStateSelected];
	}
	
	if ([self.toolButton.tool isKindOfClass:[WDFreehandTool class]] && ([(WDFreehandTool *)self.toolButton.tool closeShape])) {
		self.smallButton.hidden = self.mediumButton.hidden = self.largeButton.hidden = YES;
		[self.sizeLabel setHidden:YES];
		CGRect frame = self.colorPicker.frame;
		frame.origin.x = 0;
		frame.size.width = self.frame.size.width;
		[self.colorPicker setFrame:frame];
		CGRect labelFrame = self.colorLabel.frame;
		labelFrame.origin.x = 0;
		labelFrame.size.width = self.frame.size.width;
		[self.colorLabel setFrame:labelFrame];
	} else {
		self.smallButton.hidden = self.mediumButton.hidden = self.largeButton.hidden = NO;
		[self.sizeLabel setHidden:NO];
		CGRect frame = self.colorPicker.frame;
		frame.origin.x = COLOR_PICKER_LEFT;
		frame.size.width = self.frame.size.width - COLOR_PICKER_LEFT;
		[self.colorPicker setFrame:frame];
		CGRect labelFrame = self.colorLabel.frame;
		labelFrame.origin.x = COLOR_PICKER_LEFT;
		labelFrame.size.width = self.frame.size.width - COLOR_PICKER_LEFT;
		[self.colorLabel setFrame:labelFrame];
	}

	
	// update the selected size button
	ShapeSize activeShapeSize = [[StencilManager sharedInstance] sizeForActiveShape];
	[self setSelectedSizeButton:activeShapeSize];
	
	if ([StencilManager sharedInstance].activeShapeType == kLine) {
		
		CGFloat strokeWidth = 1.0;
		
		switch (activeShapeSize) {
			case kSmall:
				strokeWidth = 1.0;
				break;
			case kMedium:
				strokeWidth = 3.0;
				break;
			case kBig:
				strokeWidth = 6.0;
				break;
			default:
				break;
		}
		
		//		[self.sidebar.canvasController.drawingController setValue:[NSNumber numberWithFloat:strokeWidth]
		//													  forProperty:WDStrokeWidthProperty];
	}
}

- (void)setSelected:(BOOL)selected
{
	[self.toolButton setSelected:selected];
	if (selected) {
		[self.primaryView setBackgroundColor:GS_COLOR_ACCENT_BLUE];
		[self.toolNameLabel setTextColor:[UIColor whiteColor]];
		[self.toolNameLabel setFont:GS_FONT_AVENIR_ACTION_BOLD];
		[self.repeatButton setHidden:NO];
		BOOL isRepeatOn;
		if ([self.toolButton.tool isKindOfClass:[WDStencilTool class]]) {
			isRepeatOn = [(WDStencilTool *)self.toolButton.tool staysOn];
		} else if ([self.toolButton.tool isKindOfClass:[WDFreehandTool class]]) {
			isRepeatOn = [(WDFreehandTool *)self.toolButton.tool staysOn];
		} else if ([self.toolButton.tool isKindOfClass:[WDShapeTool class]]) {
			isRepeatOn = [(WDShapeTool *)self.toolButton.tool staysOn];
		}
		[self.repeatButton setSelected:isRepeatOn];
		[self updateToolSubviews];

		[UIView animateWithDuration:.5 delay:0.0 usingSpringWithDamping:.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect frame = self.frame;
			frame.size.height = 190;
			[self setFrame:frame];
		} completion:^(BOOL finished) {
			
		}];
	} else {
		[self.primaryView setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
		[self.toolNameLabel setTextColor:GS_COLOR_DARK_GREY_TEXT];
		[self.toolNameLabel setFont:GS_FONT_AVENIR_ACTION];
		[self.repeatButton setHidden:YES];
		[UIView animateWithDuration:.5 delay:0.0 usingSpringWithDamping:.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect frame = self.frame;
			frame.size.height = 80;
			[self setFrame:frame];
		} completion:^(BOOL finished) {
			
		}];
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

- (void)activateTool
{
	WDTool *tool = (self.toolButton).tool;
	
	if ([tool isKindOfClass:[WDStencilTool class]]) {
		[(WDStencilTool *)tool setStaysOn:NO];
	} else if ([tool isKindOfClass:[WDFreehandTool class]]) {
		[(WDFreehandTool *)tool setStaysOn:NO];
	} else if ([tool isKindOfClass:[WDShapeTool class]]) {
		[(WDShapeTool *)tool setStaysOn:NO];
	}
    
    [WDToolManager sharedInstance].activeTool = tool;
}

- (void)toolButtonTapped:(id)sender
{
	[self activateTool];
}

- (IBAction)colorPickerTapped:(id)sender {
	ColorPickerButton *button = (ColorPickerButton *)sender;
	[button showColors:self];
}

- (IBAction)sizeButtonTapped:(id)sender {
	UIButton *button = (UIButton *)sender;
	ShapeSize shapeSize = (ShapeSize)(button.tag);
	// tags: 0, 1 and 2
	[self setSelectedSizeButton:shapeSize];
	
	[[StencilManager sharedInstance] setSizeForActiveShape:shapeSize];
	
	if ([StencilManager sharedInstance].activeShapeType == kLine) {
		
		CGFloat strokeWidth = 1.0;
		
		switch (shapeSize) {
			case kSmall:
				strokeWidth = 1.0;
				break;
			case kMedium:
				strokeWidth = 3.0;
				break;
			case kBig:
				strokeWidth = 6.0;
				break;
			default:
				break;
		}
	
		// FIXME:
//	[self.sidebar.canvasController.drawingController setValue:[NSNumber numberWithFloat:strokeWidth]
//													  forProperty:WDStrokeWidthProperty];
	}
}

- (IBAction)repeatTapped:(id)sender {
	WDTool *tool = self.toolButton.tool;
	if ([tool isKindOfClass:[WDStencilTool class]]) {
		((WDStencilTool *)tool).staysOn ^= YES;
	} else if ([tool isKindOfClass:[WDFreehandTool class]]) {
		((WDFreehandTool *)tool).staysOn ^= YES;
	} else if ([tool isKindOfClass:[WDShapeTool class]]) {
		((WDShapeTool *)tool).staysOn ^= YES;
	}
	[self.repeatButton setSelected:!self.repeatButton.selected];
}

- (void)setSelectedSizeButton:(ShapeSize)shapeSize
{
	for (UIButton *button in self.sizeButtons) {
		if (button.tag == shapeSize) {
			[button setSelected:YES];
		} else {
			[button setSelected:NO];
		}
	}
}

- (BOOL)needColorPicker
{
	WDTool *tool = self.toolButton.tool;
	if ([tool isKindOfClass:[WDStencilTool class]]) {
		ShapeType type = [(WDStencilTool *)tool type];
		if (type == kPlant || type == kShrub || type == kTreeDeciduous || type == kTreeConiferous || type == kHedge) {
			return YES;
		}
	} else if ([tool isKindOfClass:[WDFreehandTool class]]) {
		return YES;
	} else if ([tool isKindOfClass:[WDShapeTool class]]) {
		if ([(WDShapeTool *)tool shapeMode] == WDShapeLine) {
			return YES;
		}
	}
	return NO;
}

@end
