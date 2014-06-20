//
//  PlansViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarContentViewController.h"

@class WDThumbnailView;

@interface PlansViewController : SidebarContentViewController
{
	WDThumbnailView         *editingThumbnail_;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
