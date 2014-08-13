//
//  ColorPickerButton.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-20.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"
#import "WDTool.h"

@protocol ColorPickerButtonDelegate;

@interface ColorPickerButton : UIButton <UIPopoverControllerDelegate, ColorPickerPopoverDelegate> {
	UIPopoverController			*popover_;
	ColorPickerViewController	*colorController;
}

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) id<ColorPickerButtonDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedColorIndex;
@property (nonatomic, weak) WDTool *tool;

- (void) showColors:(id)sender;
- (void) setSelectedColorIndex:(NSInteger)index;

@end

@protocol ColorPickerButtonDelegate <NSObject>

- (void)colorPicker:(ColorPickerButton *)colorpicker didSelectIndex:(NSInteger)index;

@end