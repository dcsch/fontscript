//
//  Contour.m
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Contour.h"
#import "Glyph.h"
#import "Layer.h"
#import "Font.h"
#import "AbstractPen.h"

@implementation Contour

- (instancetype)initWithGlyph:(Glyph *)glyph {
  self = [super init];
  if (self) {
    _glyph = glyph;
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  Contour *copy = [[Contour allocWithZone:zone] initWithGlyph:nil];
  return copy;
}

- (void)dealloc {
  NSLog(@"Contour dealloc");
}

- (Layer *)layer {
  return self.glyph.layer;
}

- (Font *)font {
  return self.glyph.font;
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

- (void)drawWithPen:(NSObject<AbstractPen> *)pen {

  // TESTING
  [pen moveToPoint:CGPointMake(100, 100)];
  [pen lineToPoint:CGPointMake(100, -100)];
  [pen lineToPoint:CGPointMake(-100, -100)];
  [pen lineToPoint:CGPointMake(-100, 100)];
  [pen closePath];
}

- (void)moveBy:(CGPoint)point {
  
}

@end
