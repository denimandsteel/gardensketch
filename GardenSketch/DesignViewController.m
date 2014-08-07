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
	NSArray *treeColors;
	
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
					 GS_COLOR_PLANT_GREY_GREEN,
					 GS_COLOR_PLANT_INDIGO,
					 GS_COLOR_PLANT_LIGHT_PINK];
	
	shrubColors = @[GS_COLOR_SHRUB_GREEN,
					GS_COLOR_SHRUB_VIRIDIAN,
					GS_COLOR_SHRUB_MAROON,
					GS_COLOR_SHRUB_BROWN];
	
	treeColors = @[GS_COLOR_TREE_MUSTARD,
				   GS_COLOR_TREE_GREEN,
				   GS_COLOR_TREE_DARK_GREEN,
				   GS_COLOR_TREE_TEAL,
				   GS_COLOR_TREE_VIOLET,
				   GS_COLOR_TREE_BURGUNDY];
	
//	[self.colorPicker setColors:outlineColors];
//	[self.colorPicker setDelegate:self];
//	
	// Set initial stroke color:
	UIColor *color = outlineColors[0];
	[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
	
	[self initTools];
	
	[self.toolsCollectionView registerNib:[UINib nibWithNibName:@"ToolCell" bundle:nil] forCellWithReuseIdentifier:@"ToolCellIdentifier"];
	
	[self.toolsCollectionView registerNib:[UINib nibWithNibName:@"ToolCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ToolCollectionHeaderIdentifier"];
	
	[self.toolsCollectionView setBackgroundColor:GS_COLOR_LIGHT_GREY_BACKGROUND];
	
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
	
	[nc addObserver:self
           selector:@selector(activeShapeChanged:)
               name:WDStencilShapeChanged
             object:nil];
	
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	NSString *planName = currentDocument.displayName;
	
	[self.gridButton setSelected:[self.sidebar.canvasController.drawing showGrid]];
	
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

- (void) activeShapeChanged:(NSNotification *)aNotification
{
	ShapeType type = (ShapeType)[aNotification.userInfo[@"shapeType"] integerValue];
    // TODO: update the selected size, and the color picker palette and active colors.
	NSLog(@"active shape changed to: %lu", [aNotification.userInfo[@"shapeType"] integerValue]);
	
//	switch (type) {
//		case kPlant:
//			[self.colorPicker setEnabled:YES];
//			[self.colorPicker setColors:plantColors];
//			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] plantColor]];
//			break;
//		case kShrub:
//		case kHedge:
//			[self.colorPicker setEnabled:YES];
//			[self.colorPicker setColors:shrubColors];
//			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] shrubColor]];
//			break;
//		case kTreeConiferous:
//		case kTreeDeciduous:
//			[self.colorPicker setEnabled:YES];
//			[self.colorPicker setColors:treeColors];
//			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] treeColor]];
//			break;
//		case kLine:
//			[self.colorPicker setEnabled:YES];
//			[self.colorPicker setColors:outlineColors];
//			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] outlineColor]];
//						
//			break;
//		case kArea:
//			[self.colorPicker setEnabled:YES];
//			[self.colorPicker setColors:areaColors];
//			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] areaColor]];
//		default:
//			break;
//	}
//	
//	// update the selected size button
//	ShapeSize activeShapeSize = [[StencilManager sharedInstance] sizeForActiveShape];
//	[self setSelectedSizeButton:activeShapeSize];
//	
//	if (type == kLine) {
//		
//		CGFloat strokeWidth = 1.0;
//		
//		switch (activeShapeSize) {
//			case kSmall:
//				strokeWidth = 1.0;
//				break;
//			case kMedium:
//				strokeWidth = 3.0;
//				break;
//			case kBig:
//				strokeWidth = 6.0;
//				break;
//			default:
//				break;
//		}
//		
//		[self.sidebar.canvasController.drawingController setValue:[NSNumber numberWithFloat:strokeWidth]
//													  forProperty:WDStrokeWidthProperty];
//	}
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
	ShapeType activeType = [StencilManager sharedInstance].activeShapeType;
	
	switch (activeType) {
		case kPlant:
			[[StencilManager sharedInstance] setPlantColor:(PlantColor)index];
			break;
		case kShrub:
		case kHedge:
			[[StencilManager sharedInstance] setShrubColor:(ShrubColor)index];
			break;
		case kTreeConiferous:
		case kTreeDeciduous:
			[[StencilManager sharedInstance] setTreeColor:(TreeColor)index];
			break;
		case kLine:
		{
			[[StencilManager sharedInstance] setOutlineColor:(OutlineColor)index];
			UIColor *color = colorpicker.colors[index];
			[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
			break;
		}
		case kArea:
		{
			[[StencilManager sharedInstance] setAreaColor:(AreaColor)index];
			UIColor *color = colorpicker.colors[index];
			[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDFillProperty];
			break;
		}
		default:
			break;
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
	
	WDTool *tool = nil;
	
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 0:
					tool = [WDToolManager sharedInstance].line;
					break;
				case 1:
					tool = [WDToolManager sharedInstance].freehand;
					break;
				case 2:
					tool = [WDToolManager sharedInstance].enclosed;
					break;
			}
			break;
		}
		case 1:
		{
			switch (indexPath.row) {
				case 0:
					tool = [WDToolManager sharedInstance].plant;
					break;
				case 1:
					tool = [WDToolManager sharedInstance].shrub;
					break;
				case 2:
					tool = [WDToolManager sharedInstance].horizontalHedge;
					break;
				case 3:
					tool = [WDToolManager sharedInstance].deciduousTree;
					break;
				case 4:
					tool = [WDToolManager sharedInstance].coniferousTree;
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
	
	if (selectedToolIndexPath == indexPath) {
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
	selectedToolIndexPath = indexPath;
	NSLog(@"Did select tool!");
	ToolCell *toolCell = (ToolCell *)[collectionView cellForItemAtIndexPath:indexPath];
	
	[self.toolsCollectionView performBatchUpdates:nil completion:nil];
	
	[toolCell activateTool];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// TODO: call invalidateLayout after a cell has changed size, to receive a call here:
	CGSize size = CGSizeMake(GS_SIDEBAR_WIDTH - 20, 80);
	
	if (selectedToolIndexPath == indexPath) {
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
	if (tool == [WDToolManager sharedInstance].line) {
		return [NSIndexPath indexPathForItem:0 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].freehand) {
		return [NSIndexPath indexPathForItem:1 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].enclosed) {
		return [NSIndexPath indexPathForItem:2 inSection:0];
	} else if (tool == [WDToolManager sharedInstance].plant) {
		return [NSIndexPath indexPathForItem:0 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].shrub) {
		return [NSIndexPath indexPathForItem:1 inSection:1];
	} else if (tool == [WDToolManager sharedInstance].horizontalHedge) {
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

@end
