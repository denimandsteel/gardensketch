//
//  NorthViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-03.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "SidebarContentViewController.h"
#import "OneFingerRotationGestureRecognizer.h"
#import "GSButton.h"

@interface NorthViewController : SidebarContentViewController <OneFingerRotationGestureRecognizerDelegate>

@property  (nonatomic, strong) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet GSButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *gestureView;

- (IBAction)doneTapped:(id)sender;


@end
