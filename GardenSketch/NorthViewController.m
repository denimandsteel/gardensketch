//
//  NorthViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-03.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NorthViewController.h"

@interface NorthViewController ()
{
@private CGFloat imageAngle;
@private OneFingerRotationGestureRecognizer *gestureRecognizer;
}
@end

@implementation NorthViewController

@synthesize image;

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
	
	imageAngle = 0;
	
	[self setupGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CircularGestureRecognizerDelegate protocol

- (void) rotation: (CGFloat) angle
{
    // calculate rotation angle
    imageAngle += angle;
    if (imageAngle > 360)
        imageAngle -= 360;
    else if (imageAngle < -360)
        imageAngle += 360;
    
    // rotate image and update text field
    image.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
}

CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt){
    const CGFloat fx = pt.x;
    const CGFloat fy = pt.y;
    const CGFloat fcos = cos(angle);
    const CGFloat fsin = sin(angle);
    return CGAffineTransformMake(fcos, fsin, -fsin, fcos, fx - fx * fcos + fy * fsin, fy - fx * fsin - fy * fcos);
}

- (void) finalAngle: (CGFloat) angle
{
    // circular gesture ended, update text field
    NSLog(@"angle adjusted: %f", angle);
}

#pragma mark - Helper methods

// Addes gesture recognizer to the view (or any other parent view of image. Calculates midPoint
// and radius, based on the image position and dimension.
- (void) setupGestureRecognizer
{
    // calculate center and radius of the control
    CGPoint midPoint = CGPointMake(image.frame.origin.x + image.frame.size.width / 2,
                                   image.frame.origin.y + image.frame.size.height / 2);
    CGFloat outRadius = image.frame.size.width / 2;
    
    // outRadius / 3 is arbitrary, just choose something >> 0 to avoid strange
    // effects when touching the control near of it's center
    gestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint: midPoint
																		 innerRadius: outRadius / 4
																		 outerRadius: outRadius * 3 / 2
																			  target: self];
    [self.view addGestureRecognizer: gestureRecognizer];
}


@end
