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

@interface DesignViewController ()

@end

@implementation DesignViewController

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
	
	NSArray *outlineColors = @[[[WDColor randomColor] UIColor],
							   [[WDColor randomColor] UIColor],
							   [[WDColor randomColor] UIColor]];
	[self.outlineColorPicker setColors:outlineColors];
	
	[self initTools];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@"did appear!");
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Plan Navigation

// Needs to save the current plan, and open prev or next one
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
	// TODO: disable next/previous buttons when there's no point
	
	WDDocument *document = [[WDDrawingManager sharedInstance] openDocumentAtIndex:planIndex withCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:document];
	
}

- (IBAction)colorPickerTapped:(id)sender {
	ColorPickerButton *button = (ColorPickerButton *)sender;
	[button showColors:self];
}

- (IBAction)deleteTapped:(id)sender {
	[self.sidebar.canvasController delete:self];
}

- (IBAction)cloneTapped:(id)sender {
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
	//    if (self.owner) {
	//        [self.owner didChooseTool:self];
	//    }
    
    [WDToolManager sharedInstance].activeTool = ((WDToolButton *)sender).tool;
}

- (void) drawingChanged:(NSNotification *)aNotification
{
    WDDocument *document = [aNotification object];
    
    [self.planNameLabel setText:document.displayName];
}

- (void) initTools
{
	WDTool *select = nil;
	WDTool *freehand = nil;
	WDTool *enclosed = nil;
	WDTool *bigPlant = nil;
	WDTool *smallPlant = nil;
	WDTool *gazebo = nil;
	
	for (WDTool *tool in [WDToolManager sharedInstance].tools) {
		if ([tool isKindOfClass:[WDFreehandTool class]]) {
			if ([(WDFreehandTool *)tool closeShape]) {
				enclosed = tool;
			} else {
				freehand = tool;
			}
		} else if ([tool isKindOfClass:[WDStencilTool class]]) {
			switch ([(WDStencilTool *)tool type]) {
				case kPlantBig:
					bigPlant = tool;
					break;
				case kPlantSmall:
					smallPlant = tool;
					break;
				case kGazebo:
					gazebo = tool;
					break;
				default:
					NSLog(@"hmm.. wierd");
			}
			
		} else if ([tool isKindOfClass:[WDSelectionTool class]]) {
			select = tool;
		}
	}
	
	self.selectButton.tool = select;
	[self.selectButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.freehandButton.tool = freehand;
	[self.freehandButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.enclosedButton.tool = enclosed;
	[self.enclosedButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.bigPlantButton.tool = bigPlant;
	[self.bigPlantButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.smallPlantButton.tool = smallPlant;
	[self.smallPlantButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
	
	self.gazeboButton.tool = gazebo;
	[self.gazeboButton addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) selectionChanged:(NSNotification *)aNotification
{
    self.deleteButton.enabled = (self.sidebar.canvasController.drawingController.selectedObjects.count > 0) ? YES : NO;
    
}

- (void) undoStatusDidChange:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.undoButton.enabled = [self.sidebar.canvasController.document.undoManager canUndo];
        self.redoButton.enabled = [self.sidebar.canvasController.document.undoManager canRedo];
    });
}


@end
