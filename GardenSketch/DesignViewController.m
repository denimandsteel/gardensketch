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
	
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	NSString *planName = currentDocument.displayName;
	
	[self.planNameLabel setText:planName];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawingChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) chooseTool:(id)sender
//{
//    if (self.owner) {
//        [self.owner didChooseTool:self];
//    }
//    
//    [WDToolManager sharedInstance].activeTool = ((WDToolButton *)sender).tool;
//}
//
//- (void) setTools:(NSArray *)tools
//{
//    tools_ = tools;
//	
//    // build tool buttons
//    CGRect buttonRect = CGRectMake(0, 0, [WDToolButton dimension], [WDToolButton dimension]);
//    
//    for (id tool in tools_) {
//        WDToolButton *button = [WDToolButton buttonWithType:UIButtonTypeCustom];
//        
//        if ([tool isKindOfClass:[NSArray class]]) {
//            button.tools = tool;
//        } else {
//            button.tool = tool;
//        }
//        
//        button.frame = buttonRect;
//        [button addTarget:self action:@selector(chooseTool:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
//        
//        if (tool == [WDToolManager sharedInstance].activeTool) {
//            button.selected = YES;
//        }
//        
//        buttonRect = CGRectOffset(buttonRect, 0, [WDToolButton dimension]);
//    }
//}


// Needs to save the current plan, and open prev or next one
- (IBAction)changePlan:(id)sender {
	WDDocument *currentDocument = self.sidebar.canvasController.document;
	
	NSInteger planIndex = [[WDDrawingManager sharedInstance].drawingNames indexOfObject:currentDocument.filename];
	
	UIButton *button = (UIButton *)sender;
	if (button.tag == 0) {
		// previous
		NSLog(@"previous!");
		planIndex--;
	} else {
		// next
		NSLog(@"next!");
		planIndex++;
	}
	
	if (planIndex < 0 || planIndex >= [WDDrawingManager sharedInstance].numberOfDrawings) {
		return;
	}
	
	// TODO: make sure current document is saved
	
	WDDocument *document = [[WDDrawingManager sharedInstance] openDocumentAtIndex:planIndex withCompletionHandler:nil];
	[self.sidebar.canvasController setDocument:document];
	
}

- (void) drawingChanged:(NSNotification *)aNotification
{
    WDDocument *document = [aNotification object];
    
    [self.planNameLabel setText:document.displayName];
}


@end
