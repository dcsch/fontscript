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
  NSObject<FSPen> *_pen;
}

@end

@implementation FSPointToSegmentPen

- (nonnull instancetype)initWithPen:(nonnull NSObject<FSPen> *)pen {
  self = [super init];
  if (self) {
    _pen = pen;
  }
  return self;
}

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
      if (point.type != FSPointTypeOffCurve) {
        firstOnCurve = i;
        break;
      }
    }
    if (firstOnCurve == -1) {
      // Special case for quadratics: a contour with no onCurve
      // points
      [_points addObject:[[FSPoint alloc] initWithPoint:CGPointMake(INFINITY, INFINITY)
                                                   type:FSPointTypeQCurve
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
    FSSegmentType segmentType;
    switch (point.type) {
      case FSPointTypeMove:
        segmentType = FSSegmentTypeMove;
        break;
      case FSPointTypeLine:
        segmentType = FSSegmentTypeLine;
        break;
      case FSPointTypeCurve:
        segmentType = FSSegmentTypeCurve;
        break;
      case FSPointTypeQCurve:
        segmentType = FSSegmentTypeQCurve;
        break;
      case FSPointTypeOffCurve:
        continue;
    }
    [segments addObject:[[FSSegment alloc] initWithType:segmentType
                                                 points:segmentPoints]];
    segmentPoints = [NSMutableArray array];
  }
  [self flushSegments:segments];
}

- (void)addPoint:(nonnull FSPoint *)point {
  [_points addObject:point];
}

- (void)addPoints:(nonnull NSArray<FSPoint *> *)points {
  [_points addObjectsFromArray:points];
}

- (void)addPointWithPoint:(CGPoint)pt
                pointType:(FSPointType)pointType
                   smooth:(BOOL)smooth {
  [self addPointWithPoint:pt
                pointType:pointType
                   smooth:smooth
                     name:nil
               identifier:nil];
}

- (void)addPointWithPoint:(CGPoint)pt
                pointType:(FSPointType)pointType
                   smooth:(BOOL)smooth
                     name:(nullable NSString *)name
               identifier:(nullable NSString *)identifier {
  FSPoint *point = [[FSPoint alloc] initWithPoint:pt type:pointType smooth:smooth];
  point.name = name;
//  point.identifier = identifier;
  [_points addObject:point];
}

- (void)addComponentWithBaseGlyphName:(nonnull NSString *)baseGlyphName
                       transformation:(CGAffineTransform)transformation
                           identifier:(nullable NSString *)identifier
                                error:(NSError *__autoreleasing *)error {
  [_pen addComponentWithName:baseGlyphName transformation:transformation error:error];
}

- (void)flushSegments:(nonnull NSArray<FSSegment *> *)segments {
  BOOL closed;
  FSPoint *movePoint;
  if (segments[0].type == FSSegmentTypeMove) {
    // Open path
    closed = NO;
    if (segments[0].points.count > 1) {
      NSLog(@"Bad move segment point count: %lu", (unsigned long)segments[0].points.count);
    }
    movePoint = segments[0].points[0];
    segments = [segments subarrayWithRange:NSMakeRange(1, segments.count - 1)];
  } else {
    // Closed path. moveTo the last point of the last segment
    closed = YES;
    movePoint = segments.lastObject.points.lastObject;
  }

  if (movePoint.x == INFINITY && movePoint.y == INFINITY) {
    // Special QCurve case
  } else {
    [_pen moveToPoint:movePoint.cgPoint];
  }

  NSUInteger segmentCount = segments.count;
  for (NSUInteger i = 0; i < segmentCount; ++i) {
    FSSegment *segment = segments[i];
    NSMutableArray<NSValue *> *cgPoints = [NSMutableArray array];
    for (FSPoint *point in segment.points) {
      if (point.x != INFINITY && point.y != INFINITY) {
        [cgPoints addObject:@(point.cgPoint)];
      }
    }
    switch (segment.type) {
      case FSSegmentTypeLine:
        if (cgPoints.count > 1) {
          NSLog(@"Bad line segment point count: %lu", (unsigned long)cgPoints.count);
        }
        if (segmentCount != i + 1 || !closed) {
          [_pen lineToPoint:[cgPoints[0] pointValue]];
        }
        break;
      case FSSegmentTypeCurve:
        [_pen curveToPoints:cgPoints];
        break;
      case FSSegmentTypeQCurve:
        [_pen qCurveToPoints:cgPoints];
        break;
      case FSSegmentTypeMove:
        NSLog(@"Move segment not at beginning of contour");
        break;
    }
  }
  if (closed) {
    [_pen closePath];
  } else {
    [_pen endPath];
  }
}

@end
