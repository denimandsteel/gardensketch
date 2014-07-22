//
//  GSNote.m
//  GardenSketch
//
//  Created by Arian Khosravi on 2014-07-22.
//  Copyright (c) 2014 Denim & Steel. All rights reserved.
//

#import "GSNote.h"

NSString *GSNoteTextKey = @"GSNoteTextKey";
NSString *GSNoteLetterKey = @"GSNoteLetterKey";

@implementation GSNote

@synthesize bodyText = bodyText_;
@synthesize letterIndex = letterIndex_;

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
    
    bodyText_ = [decoder decodeObjectForKey:GSNoteTextKey];
	letterIndex_ = [decoder decodeIntegerForKey:GSNoteLetterKey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:bodyText_ forKey:GSNoteTextKey];
	[encoder encodeInteger:letterIndex_ forKey:GSNoteLetterKey];
}

- (id)copyWithZone:(NSZone *)zone
{
	GSNote *result = [[[self class] allocWithZone:zone] init];
    
    result->bodyText_ = bodyText_;
	result->letterIndex_ = letterIndex_;
    
    return result;
}

@end
