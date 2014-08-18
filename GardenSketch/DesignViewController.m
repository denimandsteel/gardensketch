//
//  DesignViewController.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-18.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "DesignViewController.h"
#import "WDDocument.h"
#import "WDDrawingManager.h"
#import "WDToolManager.h"
#import "WDSelectionTool.h"
#import "WDFreehandTool.h"
#import "WDStencilTool.h"
#import "WDColor.h"
#import "WDDrawingController.h"
#import "Constants.h"
#import "StencilManager.h"
#import "WDInspectableProperties.h"
#import "WDLayer.h"
#import "ToolCell.h"
#import "ToolCollectionHeaderView.h"

@interface DesignViewController ()

@end

@implementation DesignViewController
{
	NSArray *outlineColors;
	NSArray *areaColors;
	NSArray *plantColors;
	NSArray *shrubColors;
	NSArray *deciduousTreeColors;
	NSArray *coniferousTreeColors;
	
	NSIndexPath *selectedToolIndexPath;
}

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
	
	selectedToolIndexPath = nil;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeToolChanged:) name:WDActiveToolDidChange object:nil];
	
	outlineColors = @[GS_COLOR_STROKE_RED,
							   GS_COLOR_STROKE_DARK_GREY,
							   GS_COLOR_STROKE_LIGHT_GREY];
	
	areaColors = @[GS_COLOR_AREA_WATER,
				   GS_COLOR_AREA_SAND,
				   GS_COLOR_AREA_GREEN,
				   GS_COLOR_AREA_WARM_GREY,
				   GS_COLOR_AREA_COOL_GREY];
	
	plantColors = @[GS_COLOR_PLANT_GOLD,
					GS_COLOR_PLANT_LIGHT_GREEN,
					GS_COLOR_PLANT_GREEN,
					GS_COLOR_PLANT_DARK_GREEN,
					 GS_COLOR_PLANT_INDIGO,
					 GS_COLOR_PLANT_LIGHT_PINK,
					GS_COLOR_PLANT_RED];
	
	shrubColors = @[GS_COLOR_SHRUB_GREEN,
					GS_COLOR_SHRUB_VIRIDIAN,
					GS_COLOR_SHRUB_MAROON,
					GS_COLOR_SHRUB_BROWN];
	
	deciduousTreeColors = @[GS_COLOR_TREE_GREEN,
						   GS_COLOR_TREE_DARK_GREEN,
						   GS_COLOR_TREE_TEAL,
						   GS_COLOR_TREE_VIOLET,
						   GS_COLOR_TREE_BURGUNDY,
							GS_COLOR_TREE_MUSTARD];
	
	coniferousTreeColors = @[GS_COLOR_TREE_GREEN,
							GS_COLOR_TREE_DARK_GREEN,
							GS_COLOR_TREE_TEAL];
	
	// Set initial stroke color:
	UIColor *color = outlineColors[0];
	[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
	
	[self initTools];
	
	[self.toolsCollectionView registerNib:[UINib nibWithNibName:@"ToolCell" bundle:nil] forCellWithReuseIdentifier:@"ToolCellIdentifier"];
	
	[self.toolsCollectionView registerNib:[UINib nibWithNibName:@"ToolCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ToolCollectionHeaderIdentifier"];
	
	[self.toolsCollectionView setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	
	UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolsCollectionViewDoubleTapped:)];
	[doubleTapGestureRecognizer setNumberOfTapsRequired:2];
	[doubleTapGestureRecognizer setNumberOfTouchesRequired:1];
	[self.toolsCollectionView addGestureRecognizer:doubleTapGestureRecognizer];
	[self.toolsCollectionView setAllowsMultipleSelection:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.headerBackgroundView setBackgroundColor:GS_COLOR_DARK_GREY_BACKGROUND];
	
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	NSString *planName = currentDocument.displayName;
	[self.planNameLabel setText:planName];
	[self.planNameLabel setFont:GS_FONT_AVENIR_BODY_BOLD];
	
	[self.gridButton setSelected:[self.sidebar.canvasController.drawing showGrid]];
	
	[self.selectButton setTitleColor:GS_COLOR_DARK_GREY_TEXT forState:UIControlStateNormal];
	[self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.selectButton setImage:[UIImage imageNamed:@"Select_Colour"] forState:UIControlStateNormal];
	[self.selectButton setImage:[UIImage imageNamed:@"Select_White"] forState:UIControlStateSelected];
	
	[self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_background_white"] forState:UIControlStateNormal];
	[self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_background_colour"] forState:UIControlStateSelected];
	
	[self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
	
	[self.selectButton.layer setCornerRadius:3.0];
	[self.selectButton.layer setMasksToBounds:YES];
	
	[self.toolsCollectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
           selector:@selector(selectionChanged:)
               name:WDSelectionChangedNotification
             object:self.sidebar.canvasController.drawingController];
	
	NSUndoManager *undoManager = self.sidebar.canvasController.drawingController.drawing.undoManager;
    [nc addObserver:self selector:@selector(undoStatusDidChange:) name:NSUndoManagerDidUndoChangeNotification object:undoManager];
	[nc addObserver:self selector:@selector(undoStatusDidChange:) name:NSUndoManagerDidRedoChangeNotification object:undoManager];
    [nc addObserver:self selector:@selector(undoStatusDidChange:) name:NSUndoManagerDidCloseUndoGroupNotification object:undoManager];
	
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	NSString *planName = currentDocument.displayName;
	
	[self.planNameLabel setText:planName];
	
	WDDrawing *drawing = self.sidebar.canvasController.drawing;
	WDLayer *planLayer = (WDLayer *)drawing.layers[1];
	WDLayer *notesLayer = (WDLayer *)drawing.layers[2];
	[notesLayer setVisible:NO];
	[planLayer setLocked:NO];
	
	[drawing activateLayerAtIndex:1];
	
	[self selectionChanged:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gridTapped:(id)sender {
	BOOL state = [self.sidebar.canvasController.drawing showGrid];
	[self.sidebar.canvasController.drawing setShowGrid:!state];
	[self.gridButton setSelected:!state];
}

- (IBAction)deleteTapped:(id)sender {
	[self.sidebar.canvasController delete:self];
}

- (IBAction)cloneTapped:(id)sender {
	[self.sidebar.canvasController.drawingController duplicate:self];
}

- (IBAction)redoTapped:(id)sender {
	[self.sidebar.canvasController.document.undoManager redo];
}

- (IBAction)undoTapped:(id)sender {
	[self.sidebar.canvasController.document.undoManager undo];
}

#pragma mark Tools

- (void) chooseTool:(id)sender
{
	WDTool *tool = ((WDToolButton *)sender).tool;
	if ([tool isKindOfClass:[WDStencilTool class]]) {
		[(WDStencilTool *)tool setStaysOn:NO];
	} else if ([tool isKindOfClass:[WDFreehandTool class]]) {
		[(WDFreehandTool *)tool setStaysOn:NO];
	} else if ([tool isKindOfClass:[WDShapeTool class]]) {
		[(WDShapeTool *)tool setStaysOn:NO];
	}
    
    [WDToolManager sharedInstance].activeTool = tool;
}

- (void) drawingChanged:(NSNotification *)aNotification
{
    WDDocument *document = [aNotification object];
    
	if (document == self.sidebar.canvasController.document) {
		[self.planNameLabel setText:document.displayName];
	}
}

- (void) initTools
{
	WDTool *select = [WDToolManager sharedInstance].select;
	self.selectButton.tool = select;
	[self.selectButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) selectionChanged:(NSNotification *)aNotification
{
    self.deleteButton.enabled = self.cloneButton.enabled = (self.sidebar.canvasController.drawingController.selectedObjects.count > 0) ? YES : NO;
}

- (void) undoStatusDidChange:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.undoButton.enabled = [self.sidebar.canvasController.document.undoManager canUndo];
        self.redoButton.enabled = [self.sidebar.canvasController.document.undoManager canRedo];
    });
}

#pragma mark - Color picker delegate methods
- (void)colorPicker:(ColorPickerButton *)colorpicker didSelectIndex:(NSInteger)index
{
	WDTool *tool = colorpicker.tool;
	
	if (tool == [WDToolManager sharedInstance].plant) {
		[[StencilManager sharedInstance] setPlantColor:(PlantColor)index];
	} else if (tool == [WDToolManager sharedInstance].shrub) {
		[[StencilManager sharedInstance] setShrubColor:(ShrubColor)index];
	} else if (tool == [WDToolManager sharedInstance].hedge) {
		[[StencilManager sharedInstance] setHedgeColor:(ShrubColor)index];
	} else if (tool == [WDToolManager sharedInstance].coniferousTree) {
		[[StencilManager sharedInstance] setConiferousTreeColor:(TreeColor)index];
	} else if (tool == [WDToolManager sharedInstance].deciduousTree) {
		[[StencilManager sharedInstance] setDeciduousTreeColor:(TreeColor)index];
	} else if (tool == [WDToolManager sharedInstance].straightLine) {
		[[StencilManager sharedInstance] setStraightLineColor:(OutlineColor)index];
		UIColor *color = colorpicker.colors[index];
		[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
	} else if (tool == [WDToolManager sharedInstance].freehandLine) {
		[[StencilManager sharedInstance] setFreehandLineColor:(OutlineColor)index];
		UIColor *color = colorpicker.colors[index];
		[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
	} else if (tool == [WDToolManager sharedInstance].area) {
		[[StencilManager sharedInstance] setAreaColor:(AreaColor)index];
		UIColor *color = colorpicker.colors[index];
		[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDFillProperty];
	}
}

#pragma mark Tools CollectionView delegates.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 3; // 'Drawing', 'Plants' and 'Structures' sections
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    switch (section) {
		case 0:
			// Drawing section
			return 3;
			break;
		case 1:
			// Plants section
			return 5;
			break;
		case 2:
			// Structures section
			return 5;
			break;
		default:
			return 0;
			break;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	ToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToolCellIdentifier" forIndexPath:indexPath];
	
	[cell.colorPicker setDelegate:self];
	cell.drawingController = self.sidebar.canvasController.drawingController;
	
	WDTool *tool = nil;
	
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 0:
					tool = [WDToolManager sharedInstance].straightLine;
					[cell.colorPicker setTool:tool];
					// TODO move these to the setTool setter in color picker.
					[cell.colorPicker setColors:outlineColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] straightLineColor]];
					break;
				case 1:
					tool = [WDToolManager sharedInstance].freehandLine;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:outlineColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] freehandLineColor]];
					break;
				case 2:
					tool = [WDToolManager sharedInstance].area;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:areaColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] areaColor]];
					break;
			}
			break;
		}
		case 1:
		{
			switch (indexPath.row) {
				case 0:
					tool = [WDToolManager sharedInstance].plant;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:plantColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] plantColor]];
					break;
				case 1:
					tool = [WDToolManager sharedInstance].shrub;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:shrubColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] shrubColor]];
					break;
				case 2:
					tool = [WDToolManager sharedInstance].hedge;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:shrubColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] shrubColor]];
					break;
				case 3:
					tool = [WDToolManager sharedInstance].deciduousTree;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:deciduousTreeColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] deciduousTreeColor]];
					break;
				case 4:
					tool = [WDToolManager sharedInstance].coniferousTree;
					[cell.colorPicker setTool:tool];
					[cell.colorPicker setColors:coniferousTreeColors];
					[cell.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] coniferousTreeColor]];
					break;
			}
			break;
		}
		case 2:
		{
			switch (indexPath.row) {
				case 0:
					tool = [WDToolManager sharedInstance].tile;
					break;
				case 1:
					tool = [WDToolManager sharedInstance].waterFeature;
					break;
				case 2:
					tool = [WDToolManager sharedInstance].shed;
					break;
				case 3:
					tool = [WDToolManager sharedInstance].gazebo;
					break;
				case 4:
					tool = [WDToolManager sharedInstance].flowerPot;
					break;
			}
			break;
		}
			
		default:
			break;
	}
	
	[cell.toolButton setTool:tool];
	
	[cell initialize];
	
	if (selectedToolIndexPath && [selectedToolIndexPath compare:indexPath] == NSOrderedSame) {
		[cell setSelected:YES];
	} else {
		[cell setSelected:NO];
	}
	
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ToolCollectionHeaderView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ToolCollectionHeaderIdentifier" forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) {
		NSString *headerText = @"";
        switch (indexPath.section) {
			case 0:
				headerText = @"Drawing";
				break;
			case 1:
				headerText = @"Plants";
				break;
			case 2:
				headerText = @"Structures";
				break;
			default:
				break;
		}
		[reusableview.label setText:headerText];
    }
	
    return reusableview;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (selectedToolIndexPath) {
		// Deselect if already selected:
		if ([selectedToolIndexPath compare:indexPath] == NSOrderedSame) {
			[collectionView deselectItemAtIndexPath:selectedToolIndexPath animated:YES];
			selectedToolIndexPath = nil;
			[[WDToolManager sharedInstance] setActiveTool:[WDToolManager sharedInstance].select];
			[self.toolsCollectionView performBatchUpdates:nil completion:nil];
			return;
		}
		[collectionView deselectItemAtIndexPath:selectedToolIndexPath animated:YES];
	}
	selectedToolIndexPath = indexPath;
	NSLog(@"Did select tool!");
	ToolCell *toolCell = (ToolCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	toolCell.drawingController = self.sidebar.canvasController.drawingController;
	[self.toolsCollectionView performBatchUpdates:nil completion:nil];
	
	[toolCell activateTool];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Yep!");
	return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize size = CGSizeMake(GS_SIDEBAR_WIDTH - 20, 80);
	
	if (selectedToolIndexPath && [selectedToolIndexPath compare:indexPath] == NSOrderedSame) {
		size = CGSizeMake(GS_SIDEBAR_WIDTH - 20, 190);
	}
	
	return size;
}

- (void)activeToolChanged:(NSNotification *)aNotification
{
    WDTool *tool = [[WDToolManager sharedInstance] activeTool];
	
	NSIndexPath *indexPath = [self indexPathForTool:tool];
	
	if (indexPath) {
		[self.toolsCollectionView selectItemAtIndexPath:[self indexPathForTool:tool] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
		selectedToolIndexPath = indexPath;
	} else {
		[self.toolsCollectionView deselectItemAtIndexPath:selectedToolIndexPath animated:YES];
		selectedToolIndexPath = nil;
	}
	[self.toolsCollectionView performBatchUpdates:nil completion:nil];
}

- (NSIndexPath *)indexPathForTool:(WDTool *)tool
{
	if (tool == [WDToolManager sharedInstance].straightLine) {
		return [NSIndexPath indexPathForItem:0 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].freehandLine) {
		return [NSIndexPath indexPathForItem:1 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].area) {
		return [NSIndexPath indexPathForItem:2 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].plant) {
		return [NSIndexPath indexPathForItem:0 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].shrub) {
		return [NSIndexPath indexPathForItem:1 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].hedge) {
		return [NSIndexPath indexPathForItem:2 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].deciduousTree) {
		return [NSIndexPath indexPathForItem:3 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].coniferousTree) {
		return [NSIndexPath indexPathForItem:4 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].tile) {
		return [NSIndexPath indexPathForItem:0 inSection:2];
	} else if (tool == [WDToolManager sharedInstance].waterFeature) {
		return [NSIndexPath indexPathForItem:1 inSection:2];
	} else if (tool == [WDToolManager sharedInstance].shed) {
		return [NSIndexPath indexPathForItem:2 inSection:2];
	} else if (tool == [WDToolManager sharedInstance].gazebo) {
		return [NSIndexPath indexPathForItem:3 inSection:2];
	} else if (tool == [WDToolManager sharedInstance].flowerPot) {
		return [NSIndexPath indexPathForItem:4 inSection:2];
	} else {
		return nil;
	}
}

- (void)toolsCollectionViewDoubleTapped:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [gestureRecognizer locationInView:self.toolsCollectionView];
        NSIndexPath *indexPath = [self.toolsCollectionView indexPathForItemAtPoint:point];
        if (indexPath)
        {
            NSLog(@"Image was double tapped");
        }
        else
        {
            NSLog(@"Whaaa?!");
        }
    }
}

@end
