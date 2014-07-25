//
//  ColorPickerViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-20.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerPopoverDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index;

@end

@interface ColorPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) id<ColorPickerPopoverDelegate> delegate;

-(id)initWithColors:(NSArray *)colors;

@end
