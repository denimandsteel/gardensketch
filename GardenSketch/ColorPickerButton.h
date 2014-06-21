//
//  ColorPickerButton.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-20.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerViewController.h"

@interface ColorPickerButton : UIButton <UIPopoverControllerDelegate, ColorPickerDelegate> {
	UIPopoverController			*popover_;
	ColorPickerViewController	*colorController;
}

@property (nonatomic, strong) NSArray *colors;

- (void) showColors:(id)sender;

@end
