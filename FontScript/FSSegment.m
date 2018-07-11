//
//  FSSegment.m
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSSegment.h"

@interface FSSegment ()
{
}

@end

@implementation FSSegment

- (nonnull instancetype)initWithType:(FSSegmentType)type
                              points:(nonnull NSArray<FSPoint *> *)points {
  self = [super init];
  if (self) {
    _type = type;
    _points = points;
  }
  return self;
}

//- (nonnull instancetype)init {
//  return [self initWithPoints:[NSArray array]];
//}

@end
