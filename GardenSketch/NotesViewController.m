//
//  NotesViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-16.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteCellView.h"
#import "WDDrawing.h"
#import "Constants.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

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
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"NoteCellView" bundle:nil] forCellWithReuseIdentifier:@"NoteCellIdentifier"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CollectionView delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.sidebar.canvasController.drawing.notes.count;
}

#pragma mark Collection View delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	NoteCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCellIdentifier" forIndexPath:indexPath];
	[cell.bodyLabel setText:self.sidebar.canvasController.drawing.notes[indexPath.row]];
	return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Did select!");
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// TODO: call invalidateLayout after a note has been edited, to receive a call here:
	// TODO: Use
	
	NSString *text = self.sidebar.canvasController.drawing.notes[indexPath.row];
	
	NSDictionary *attributes = @{NSFontAttributeName:GS_FONT_AVENIR_BODY};
	// NSString class method: boundingRectWithSize:options:attributes:context is
	// available only on ios7.0 sdk.
	CGRect rect = [text boundingRectWithSize:CGSizeMake(210.0, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
	
	rect.size.width = 280;
	return rect.size;
}

@end
