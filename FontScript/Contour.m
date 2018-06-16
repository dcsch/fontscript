//
//  Contour.m
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Contour.h"
#import "AbstractPen.h"

@implementation Contour

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  Contour *copy = [[Contour allocWithZone:zone] init];
  return copy;
}

- (void)dealloc {
  NSLog(@"Contour dealloc");
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
