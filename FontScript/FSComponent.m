//
//  FSComponent.m
//  FontScript
//
//  Created by David Schweinsberg on 7/19/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSComponent.h"
#import "FSPen.h"
#import "FSPointToSegmentPen.h"

@implementation FSComponent

- (instancetype)initWithBaseGlyphName:(NSString *)baseGlyphName {
  self = [super init];
  if (self) {
    _baseGlyphName = baseGlyphName;
    _transformation = CGAffineTransformIdentity;
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSComponent *copy = [[FSComponent allocWithZone:zone] initWithBaseGlyphName:_baseGlyphName];
  return copy;
}

- (void)dealloc {
  NSLog(@"Component dealloc");
}

- (CGPoint)offset {
  return CGPointMake(_transformation.tx, _transformation.ty);
}

- (void)setOffset:(CGPoint)offset {
  _transformation.tx = offset.x;
  _transformation.ty = offset.y;
}

- (CGPoint)scale {
  return CGPointMake(_transformation.a, _transformation.d);
}

- (void)setScale:(CGPoint)scale {
  _transformation.a = scale.x;
  _transformation.d = scale.y;
}

- (void)drawWithPen:(NSObject<FSPen> *)pen {
  FSPointToSegmentPen *pointToSegmentPen = [[FSPointToSegmentPen alloc] initWithPen:pen];
  [self drawWithPointPen:pointToSegmentPen];
}

- (void)drawWithPointPen:(NSObject<FSPointPen> *)pointPen {
  [pointPen beginPath];
  NSError *error;
  [pointPen addComponentWithBaseGlyphName:_baseGlyphName
                           transformation:_transformation
                               identifier:_identifier
                                    error:&error];
  [pointPen endPath];
}

@end
