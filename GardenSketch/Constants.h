//
//  Constants.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-06-25.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#ifndef GardenSketch_Constants_h
#define GardenSketch_Constants_h

#define		GS_BASE_PLAN_FILE_NAME			@"_GS_BASE_PLAN.inkpad"

#define		GS_SIDEBAR_WIDTH				340.0

#define		CG_DEFAULT_CANVAS_SIZE			CGSizeMake(2048, 2048)

#define		NOTE_CELL_MIN_HEIGHT			100.0

#define		GS_FONT_AVENIR_BODY				[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
#define		GS_FONT_AVENIR_ACTION_BOLD		[UIFont fontWithName:@"AvenirNext-Medium" size:20.0]
#define		GS_FONT_AVENIR_ACTION			[UIFont fontWithName:@"AvenirNext-Regular" size:20.0]
#define		GS_FONT_AVENIR_HEAD				[UIFont fontWithName:@"AvenirNext-Regular" size:28.0]
#define		GS_FONT_AVENIR_HEAD_BOLD		[UIFont fontWithName:@"AvenirNext-DemiBold" size:28.0]
#define		GS_FONT_AVENIR_SMALL			[UIFont fontWithName:@"AvenirNext-Regular" size:14.0]
#define		GS_FONT_AVENIR_TINY				[UIFont fontWithName:@"AvenirNext-Regular" size:8.0]
#define		GS_FONT_AVENIR_BODY_BOLD		[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]
#define		GS_FONT_AVENIR_EXPORT_LETTER	[UIFont fontWithName:@"AvenirNext-DemiBold" size:75.0]
#define		GS_FONT_AVENIR_EXPORT_BODY		[UIFont fontWithName:@"AvenirNext-Regular" size:48.0]



// APP CHROME COLORS:

#define		GS_COLOR_ACCENT_BLUE			[UIColor colorWithRed:0.345 green:0.784 blue:0.796 alpha:1.000]
#define		GS_COLOR_LIGHT_GREY_BACKGROUND	[UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1.000]
#define		GS_COLOR_DARK_GREY_BACKGROUND	[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1.000]
#define		GS_COLOR_DARK_GREY_TEXT			[UIColor colorWithRed:0.216 green:0.204 blue:0.204 alpha:1.000]

// DRAWING COLORS:

// yellow paper canvas background
#define		GS_COLOR_CANVAS					[UIColor colorWithRed:251/255.0 green:250/255.0 blue:241/255.0 alpha:0.9]

// area colors
#define		GS_COLOR_AREA_WATER				[UIColor colorWithRed:0.4 green:0.78 blue:0.86 alpha:0.4]
#define		GS_COLOR_AREA_SAND				[UIColor colorWithRed:0.9 green:0.87 blue:0.73 alpha:0.4]
#define		GS_COLOR_AREA_GREEN				[UIColor colorWithRed:0.78 green:0.9 blue:0.8 alpha:0.4]
#define		GS_COLOR_AREA_WARM_GREY			[UIColor colorWithRed:0.8 green:0.8 blue:0.83 alpha:0.4]
#define		GS_COLOR_AREA_COOL_GREY			[UIColor colorWithRed:0.79 green:0.76 blue:0.74 alpha:0.4]

// stroke colors:
#define		GS_COLOR_STROKE_RED				[UIColor colorWithRed:167/255.0 green:59/255.0 blue:57/255.0 alpha:1.0]
#define		GS_COLOR_STROKE_DARK_GREY		[UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]
#define		GS_COLOR_STROKE_LIGHT_GREY		[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1.0]

// plant colors:
#define		GS_COLOR_PLANT_DARK_GREEN		[UIColor colorWithRed:0.565 green:0.620 blue:0.549 alpha:1.000]
#define		GS_COLOR_PLANT_GOLD				[UIColor colorWithRed:0.843 green:0.757 blue:0.486 alpha:1.000]
#define		GS_COLOR_PLANT_GREEN			[UIColor colorWithRed:0.710 green:0.859 blue:0.608 alpha:1.000]
#define		GS_COLOR_PLANT_GREY_GREEN		[UIColor colorWithRed:0.553 green:0.553 blue:0.541 alpha:1.000]
#define		GS_COLOR_PLANT_INDIGO			[UIColor colorWithRed:0.561 green:0.553 blue:0.718 alpha:1.000]
#define		GS_COLOR_PLANT_LIGHT_GREEN		[UIColor colorWithRed:0.792 green:0.871 blue:0.569 alpha:1.000]
#define		GS_COLOR_PLANT_LIGHT_PINK		[UIColor colorWithRed:0.945 green:0.663 blue:0.639 alpha:1.000]

// shrub colors
#define		GS_COLOR_SHRUB_BROWN			[UIColor colorWithRed:0.545 green:0.435 blue:0.353 alpha:1.000]
#define		GS_COLOR_SHRUB_GREEN			[UIColor colorWithRed:0.651 green:0.725 blue:0.424 alpha:1.000]
#define		GS_COLOR_SHRUB_MAROON			[UIColor colorWithRed:0.663 green:0.337 blue:0.365 alpha:1.000]
#define		GS_COLOR_SHRUB_VIRIDIAN			[UIColor colorWithRed:0.380 green:0.525 blue:0.400 alpha:1.000]

// tree colors
#define		GS_COLOR_TREE_BURGUNDY			[UIColor colorWithRed:0.835 green:0.369 blue:0.420 alpha:1.000]
#define		GS_COLOR_TREE_DARK_GREEN		[UIColor colorWithRed:0.400 green:0.565 blue:0.447 alpha:1.000]
#define		GS_COLOR_TREE_GREEN				[UIColor colorWithRed:0.514 green:0.765 blue:0.486 alpha:1.000]
#define		GS_COLOR_TREE_MUSTARD			[UIColor colorWithRed:0.796 green:0.741 blue:0.451 alpha:1.000]
#define		GS_COLOR_TREE_TEAL				[UIColor colorWithRed:0.522 green:0.698 blue:0.604 alpha:1.000]
#define		GS_COLOR_TREE_VIOLET			[UIColor colorWithRed:0.424 green:0.427 blue:0.659 alpha:1.000]

#define		GS_NORTH_ANGLE					@"GS_NORTH_ANGLE"

#define		GS_HAS_LAUNCHED_ONCE			@"GS_HAS_LAUNCHED_ONCE"

#define		GS_VISITED_PROPERTY_TAB			@"GS_VISITED_PROPERTY_TAB"
#define		GS_VISITED_HOUSE_TAB			@"GS_VISITED_HOUSE_TAB"
#define		GS_VISITED_NORTH_TAB			@"GS_VISITED_NORTH_TAB"
#define		GS_VISITED_PLANS_TAB			@"GS_VISITED_PLANS_TAB"
#define		GS_VISITED_DESIGN_TAB			@"GS_VISITED_DESIGN_TAB"
#define		GS_VISITED_NOTES_TAB			@"GS_VISITED_NOTES_TAB"
#define		GS_VISITED_MORE_TAB				@"GS_VISITED_MORE_TAB"

#endif
