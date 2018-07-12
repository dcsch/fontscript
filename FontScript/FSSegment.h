//
//  FSSegment.h
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FSPoint;

typedef NS_ENUM(NSUInteger, FSSegmentType)
{
  FSSegmentTypeMove,
  FSSegmentTypeLine,
  FSSegmentTypeCurve,
  FSSegmentTypeQCurve
} NS_SWIFT_NAME(Segment.Type);

NS_SWIFT_NAME(Segment)
@interface FSSegment : NSObject

- (nonnull instancetype)initWithType:(FSSegmentType)type
                              points:(nonnull NSArray<FSPoint *> *)points NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents

// Identification

// Attributes
@property FSSegmentType type;
@property BOOL smooth;

// Points
@property(nonnull) NSArray<FSPoint *> *points;

// Transformations

// Normalization

// Environment

@end
