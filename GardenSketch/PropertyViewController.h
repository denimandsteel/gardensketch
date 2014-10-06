//
//  PropertyViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-13.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarContentViewController.h"
#import "PropertyShapeButton.h"
#import "GSButton.h"
#import "GSLabelHead.h"

@interface PropertyViewController : SidebarContentViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(PropertyShapeButton) NSArray *shapes;
@property (weak, nonatomic) IBOutlet UITextField *firstField;
@property (weak, nonatomic) IBOutlet UITextField *secondField;
@property (weak, nonatomic) IBOutlet GSButton *doneButton;

@property (weak, nonatomic) IBOutlet GSLabelHead *feetLabel;
@property (weak, nonatomic) IBOutlet GSLabelHead *metersLabel;

@property (weak, nonatomic) IBOutlet UIButton *unitsButton;
- (IBAction)unitsTapped:(id)sender;

- (IBAction)shapeSelected:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
