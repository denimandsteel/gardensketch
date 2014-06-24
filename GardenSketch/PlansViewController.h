//
//  PlansViewController.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarContentViewController.h"
#import "WDThumbnailView.h"

@interface PlansViewController : SidebarContentViewController <WDThumbnailViewDelegate>
{
	WDThumbnailView         *editingThumbnail_;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
