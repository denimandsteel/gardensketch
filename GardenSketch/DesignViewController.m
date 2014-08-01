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

@interface DesignViewController ()

@end

@implementation DesignViewController
{
	NSArray *outlineColors;
	NSArray *plantColors;
	NSArray *shrubColors;
	NSArray *treeColors;
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];
	
	outlineColors = @[GS_COLOR_STROKE_RED,
							   GS_COLOR_STROKE_DARK_GREY,
							   GS_COLOR_STROKE_LIGHT_GREY];
	
	plantColors = @[GS_COLOR_PLANT_DARK_GREEN,
							 GS_COLOR_PLANT_GOLD,
							 GS_COLOR_PLANT_GREEN,
							 GS_COLOR_PLANT_GREY_GREEN,
							 GS_COLOR_PLANT_INDIGO,
							 GS_COLOR_PLANT_LIGHT_GREEN,
							 GS_COLOR_PLANT_LIGHT_PINK];
	
	shrubColors = @[GS_COLOR_SHRUB_BROWN,
							 GS_COLOR_SHRUB_GREEN,
							 GS_COLOR_SHRUB_MAROON,
							 GS_COLOR_SHRUB_VIRIDIAN];
	
	treeColors = @[GS_COLOR_TREE_BURGUNDY,
							GS_COLOR_TREE_DARK_GREEN,
							GS_COLOR_TREE_GREEN,
							GS_COLOR_TREE_MUSTARD,
							GS_COLOR_TREE_TEAL,
							GS_COLOR_TREE_VIOLET];
	
	[self.colorPicker setColors:outlineColors];
	[self.colorPicker setDelegate:self];
	
	// Set initial stroke color:
	UIColor *color = self.colorPicker.colors[0];
	[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
	
	[self initTools];
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

#pragma mark Plan Navigation

// Needs to save the current plan, and open prev or next one
- (IBAction)toolsTabChanged:(id)sender {
	NSUInteger index = [((UISegmentedControl *)sender) selectedSegmentIndex];
	if (index == 0) {
		[self.plantsView setHidden:NO];
		[self.structuresView setHidden:YES];
	} else {
		[self.plantsView setHidden:YES];
		[self.structuresView setHidden:NO];
	}
}

- (IBAction)gridTapped:(id)sender {
	BOOL state = [self.sidebar.canvasController.drawing showGrid];
	[self.sidebar.canvasController.drawing setShowGrid:!state];
	[self.gridButton setSelected:!state];
}

- (IBAction)changePlan:(id)sender {
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	
	NSInteger planIndex = [[WDDrawingManager sharedInstance].drawingNames indexOfObject:currentDocument.filename];
	
	UIButton *button = (UIButton *)sender;
	if (button.tag == 0) {
		// previous
		planIndex--;
	} else {
		// next
		planIndex++;
	}
	
	if (planIndex < 0 || planIndex >= [WDDrawingManager sharedInstance].numberOfDrawings) {
		return;
	}
	
	// TODO: make sure current document is saved
	// TODO: make sure the selection view is cleared, selected path points show up in the next plan
	
	WDDocument *document = [[WDDrawingManager sharedInstance] openDocumentAtIndex:planIndex withCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:document];
	
}

- (IBAction)colorPickerTapped:(id)sender {
	ColorPickerButton *button = (ColorPickerButton *)sender;
	[button showColors:self];
}

- (IBAction)sizeButtonTapped:(id)sender {
	UIButton *button = (UIButton *)sender;
	ShapeSize shapeSize = (ShapeSize)(button.tag);
	// tags: 0, 1 and 2
	[self setSelectedSizeButton:shapeSize];
	
	[[StencilManager sharedInstance] setSizeForActiveShape:shapeSize];
	
	if ([StencilManager sharedInstance].activeShapeType == kLine) {
		
		CGFloat strokeWidth = 1.0;
		
		switch (shapeSize) {
			case kSmall:
				strokeWidth = 1.0;
				break;
			case kMedium:
				strokeWidth = 3.0;
				break;
			case kBig:
				strokeWidth = 6.0;
				break;
			default:
				break;
		}
		
		[self.sidebar.canvasController.drawingController setValue:[NSNumber numberWithFloat:strokeWidth]
													  forProperty:WDStrokeWidthProperty];
	}
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
	// TODO: make this more sane by moving actions to IB
	// TODO: also having one property per tool on the tool manager, to get rid of the massive loop down here:
	
	WDTool *select = nil;
	WDTool *freehand = nil;
	WDTool *line = nil;
	WDTool *enclosed = nil;
	WDTool *plant = nil;
	WDTool *shrub = nil;
	WDTool *verticalHedge = nil;
	WDTool *horizontalHedge = nil;
	WDTool *deciduousTree = nil;
	WDTool *coniferousTree = nil;
	WDTool *sidewalk = nil;
	WDTool *gazebo = nil;
	WDTool *shed = nil;
	WDTool *waterFeature = nil;
	
	for (WDTool *tool in [WDToolManager sharedInstance].tools) {
		if ([tool isKindOfClass:[WDFreehandTool class]]) {
			if ([(WDFreehandTool *)tool closeShape]) {
				enclosed = tool;
			} else {
				freehand = tool;
			}
		} else if ([tool isKindOfClass:[WDStencilTool class]]) {
			switch ([(WDStencilTool *)tool type]) {
				case kPlant:
					plant = tool;
					break;
				case kShrub:
					shrub = tool;
					break;
				case kHedge:
					if ([((WDStencilTool *)tool) initialRotation] > 0.0) {
						horizontalHedge = tool;
					} else {
						verticalHedge = tool;
					}
					break;
				case kTreeDeciduous:
					deciduousTree = tool;
					break;
				case kTreeConiferous:
					coniferousTree = tool;
					break;
				case kSidewalk:
					sidewalk = tool;
					break;
				case kGazebo:
					gazebo = tool;
					break;
				case kShed:
					shed = tool;
					break;
				case kWaterFeature:
					waterFeature = tool;
					break;
				default:
					NSLog(@"hmm.. weird");
			}
			
		} else if ([tool isKindOfClass:[WDSelectionTool class]]) {
			select = tool;
		} else if ([tool isKindOfClass:[WDShapeTool class]]) {
			line = tool;
		}
		
	}
	
	self.selectButton.tool = select;
	[self.selectButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.freehandButton.tool = freehand;
	[self.freehandButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.straightLineButton.tool = line;
	[self.straightLineButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.enclosedButton.tool = enclosed;
	[self.enclosedButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.plantButton.tool = plant;
	[self.plantButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.shrubButton.tool = shrub;
	[self.shrubButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.verticalHedgeButton.tool = verticalHedge;
	[self.verticalHedgeButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.horizontalHedgeButton.tool = horizontalHedge;
	[self.horizontalHedgeButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.deciduousTreeButton.tool = deciduousTree;
	[self.deciduousTreeButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.coniferousTreeButton.tool = coniferousTree;
	[self.coniferousTreeButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.tileButton.tool = sidewalk;
	[self.tileButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.gazeboButton.tool = gazebo;
	[self.gazeboButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.shedButton.tool = shed;
	[self.shedButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.waterFeatureButton.tool = waterFeature;
	[self.waterFeatureButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
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
	
	switch (type) {
		case kPlant:
			[self.colorPicker setEnabled:YES];
			[self.colorPicker setColors:plantColors];
			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] plantColor]];
			break;
		case kShrub:
		case kHedge:
			[self.colorPicker setEnabled:YES];
			[self.colorPicker setColors:shrubColors];
			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] shrubColor]];
			break;
		case kTreeConiferous:
		case kTreeDeciduous:
			[self.colorPicker setEnabled:YES];
			[self.colorPicker setColors:treeColors];
			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] treeColor]];
			break;
		case kLine:
			[self.colorPicker setEnabled:YES];
			[self.colorPicker setColors:outlineColors];
			[self.colorPicker setSelectedColorIndex:[[StencilManager sharedInstance] outlineColor]];
						
			break;
		case kArea:
			[self.colorPicker setEnabled:NO];
		default:
			break;
	}
	
	// update the selected size button
	ShapeSize activeShapeSize = [[StencilManager sharedInstance] sizeForActiveShape];
	[self setSelectedSizeButton:activeShapeSize];
	
	if (type == kLine) {
		
		CGFloat strokeWidth = 1.0;
		
		switch (activeShapeSize) {
			case kSmall:
				strokeWidth = 1.0;
				break;
			case kMedium:
				strokeWidth = 3.0;
				break;
			case kBig:
				strokeWidth = 6.0;
				break;
			default:
				break;
		}
		
		[self.sidebar.canvasController.drawingController setValue:[NSNumber numberWithFloat:strokeWidth]
													  forProperty:WDStrokeWidthProperty];
	}
}

- (void)setSelectedSizeButton:(ShapeSize)shapeSize
{
	for (UIButton *button in self.sizeButtons) {
		if (button.tag == shapeSize) {
			[button setSelected:YES];
		} else {
			[button setSelected:NO];
		}
	}
}

- (void) undoStatusDidChange:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.undoButton.enabled = [self.sidebar.canvasController.document.undoManager canUndo];
        self.redoButton.enabled = [self.sidebar.canvasController.document.undoManager canRedo];
    });
}

#pragma mark - Color cpiker delegate methods
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
			UIColor *color = self.colorPicker.colors[index];
			[self.sidebar.canvasController.drawingController setValue:[WDColor colorWithUIColor:color] forProperty:WDStrokeColorProperty];
			break;
		}
		default:
			break;
	}
}

@end
