//
//  PropertyViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-13.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "PropertyViewController.h"

@interface PropertyViewController ()

@end

@implementation PropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 Property Boundaries
 The red lines mark the property boundaries.
 
 You can draw and write notes outside the red lines, but be mindful of where you can actually plant.
 
*/

- (IBAction)shapeSelected:(id)sender {
	[self.shapesView setHidden:YES];
	[self.sizeView setHidden:NO];
}

- (IBAction)changeShapeTapped:(id)sender {
	[self.shapesView setHidden:NO];
	[self.sizeView setHidden:YES];
}

@end
