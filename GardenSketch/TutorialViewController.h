//
//  TutorialViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-28.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TutorialDelegate <NSObject>

- (void)letMeGo;

@end

@interface TutorialViewController : UIViewController

@property (nonatomic, strong) NSArray *xibsToShow;
@property (nonatomic, assign) id<TutorialDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *containerView;


- (IBAction)continueTapped:(id)sender;

@end
