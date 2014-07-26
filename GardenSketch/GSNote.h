//
//  GSNote.h
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-22.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSNote : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, assign) NSInteger letterIndex;
@property (nonatomic, assign) CGPoint position;

@end
