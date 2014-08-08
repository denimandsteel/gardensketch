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

@implementation ToolCell

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
	[self setSelected:NO];
	[self.toolButton addTarget:self action:@selector(toolButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.toolNameLabel setText:self.toolButton.tool.toolName];
	[self.layer setCornerRadius:10.0];
	[self.layer setMasksToBounds:YES];
	[self.secondaryView setBackgroundColor:GS_COLOR_DARK_GREY_BACKGROUND];
	[self customizeToolSubviews];
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

- (void)customizeToolSubviews
{
	if ([self needColorPicker]) {
		[self.colorPicker setHidden:NO];
	} else {
		[self.colorPicker setHidden:YES];
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
