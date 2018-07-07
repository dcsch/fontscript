//
//  FSContour.m
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSContour.h"
#import "FSGlyph.h"
#import "FSLayer.h"
#import "FSFont.h"
#import "FSAbstractPen.h"
#import "FSIdentifier.h"

@interface FSContour ()
{
  NSString *_identifier;
  BOOL _clockwise;
  NSMutableArray<FSPoint *> *_points;
}

@end

@implementation FSContour

- (nonnull instancetype)initWithGlyph:(FSGlyph *)glyph {
  self = [super init];
  if (self) {
    _glyph = glyph;
    _points = [[NSMutableArray alloc] init];
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSContour *copy = [[FSContour allocWithZone:zone] initWithGlyph:nil];
  copy->_points = self.points.copy;
  return copy;
}

- (void)dealloc {
  NSLog(@"Contour dealloc");
}

- (FSLayer *)layer {
  return self.glyph.layer;
}

- (FSFont *)font {
  return self.glyph.font;
}

- (NSString *)identifier {
  if (_identifier == nil) {
    _identifier = [FSIdentifier RandomIdentifierWithError: nil];
  }
  return _identifier;
}

- (NSUInteger)index {
  return [self.glyph.contours indexOfObject:self];
}

- (void)setIndex:(NSUInteger)index {
  [self.glyph reorderContour:self toIndex:index error:nil];
}

- (void)setIndex:(NSUInteger)index error:(NSError **)error {
  [self.glyph reorderContour:self toIndex:index error:error];
}

- (BOOL)clockwise {
  return _clockwise;
}

- (void)setClockwise:(BOOL)clockwise {
  if (_clockwise != clockwise) {
    [self reverse];
  }
}

- (void)reverse {

}

- (void)drawWithPen:(NSObject<FSAbstractPen> *)pen {
  for (FSPoint *point in _points) {
    switch (point.type) {
      case FSPointTypeMove:
        [pen moveToPoint:point.cgPoint];
        break;
      case FSPointTypeLine:
        [pen lineToPoint:point.cgPoint];
        break;
      case FSPointTypeCurve:
        // TODO
        break;
      case FSPointTypeQCurve:
        // TODO
        break;
      case FSPointTypeOffCurve:
        // TODO
        break;
    }
  }
}

- (void)appendPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth {
  [_points addObject:[[FSPoint alloc] initWithPoint:point type:type smooth:smooth]];
}

- (void)insertPoint:(CGPoint)point type:(FSPointType)type smooth:(BOOL)smooth atIndex:(NSUInteger)index {
  [_points insertObject:[[FSPoint alloc] initWithPoint:point type:type smooth:smooth] atIndex:index];
}

- (void)removePoint:(CGPoint)point {
  for (FSPoint *pt in _points) {
    if (pt.x == point.x && pt.y == point.y) {
      [_points removeObject:pt];
      break;
    }
  }
}

- (void)moveBy:(CGPoint)point {
  
}

@end
