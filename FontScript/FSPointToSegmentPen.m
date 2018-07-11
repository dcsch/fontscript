//
//  FSPointToSegmentPen.m
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSPointToSegmentPen.h"
#import "FSPoint.h"

@interface FSPointToSegmentPen ()
{
  NSMutableArray<FSPoint *> *_points;
}

@end

@implementation FSPointToSegmentPen

- (void)beginPath {
  _points = [NSMutableArray array];
}

- (void)beginPathWithIdentifier:(NSString *)identifier {
  [self beginPath];
}

- (void)endPath {

  NSMutableArray<FSSegment *> *segments = [NSMutableArray array];
  if (_points.count == 0) {
    return;
  } else if (_points.count == 1) {
    [segments addObject:[[FSSegment alloc] initWithType:FSSegmentTypeMove
                                                 points:_points]];
    [self flushSegments:segments];
    return;
  }

  if (_points[0].type == FSSegmentTypeMove) {
    // For an open contour, insert a "move" segment for this point
    // and remove it from the point array
    [segments addObject:[[FSSegment alloc] initWithType:FSSegmentTypeMove
                                                 points:[NSArray arrayWithObject:_points[0]]]];
    [_points removeObjectAtIndex:0];
  } else {
    // For a closed contour, locate the first onCurve point and
    // rotate the array so that it ends on that point
    NSInteger firstOnCurve = -1;
    for (NSInteger i = 0; i < _points.count; ++i) {
      FSPoint *point = _points[i];
      if (point.type != FSSegmentTypeOffCurve) {
        firstOnCurve = i;
        break;
      }
    }
    if (firstOnCurve == -1) {
      // Special case for quadratics: a contour with no onCurve
      // points
      [_points addObject:[[FSPoint alloc] initWithPoint:CGPointMake(INFINITY, INFINITY)
                                                   type:FSSegmentTypeQCurve
                                                 smooth:NO]];
    } else {
      NSRange frontRange = NSMakeRange(0, firstOnCurve + 1);
      [_points addObjectsFromArray:[_points subarrayWithRange:frontRange]];
      [_points removeObjectsInRange:frontRange];
    }
  }

  NSMutableArray<FSPoint *> *segmentPoints = [NSMutableArray array];
  for (FSPoint *point in _points) {
    [segmentPoints addObject:point];
    if (point.type == FSSegmentTypeOffCurve) {
      continue;
    }
    [segments addObject:[[FSSegment alloc] initWithType:point.type
                                                 points:segmentPoints]];
    segmentPoints = [NSMutableArray array];
  }
  [self flushSegments:segments];
}

- (void)addPointWithPoint:(CGPoint)pt
              segmentType:(FSSegmentType)segmentType
                   smooth:(BOOL)smooth {
  [self addPointWithPoint:pt
              segmentType:segmentType
                   smooth:smooth
                     name:nil
               identifier:nil];
}

- (void)addPointWithPoint:(CGPoint)pt
              segmentType:(FSSegmentType)segmentType
                   smooth:(BOOL)smooth
                     name:(nullable NSString *)name
               identifier:(nullable NSString *)identifier {
  FSPoint *point = [[FSPoint alloc] initWithPoint:pt type:segmentType smooth:smooth];
  point.name = name;
//  point.identifier = identifier;
  [_points addObject:point];
}

- (void)addComponentWithBaseGlyphName:(nonnull NSString *)baseGlyphName
                       transformation:(CGAffineTransform)transformation
                           identifier:(nullable NSString *)identifier
                                error:(NSError *__autoreleasing *)error {
}

- (void)flushSegments:(nonnull NSArray<FSSegment *> *)segments {
  // TODO
}

@end
