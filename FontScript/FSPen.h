//
//  FSPen.h
//  FontScript
//
//  Created by David Schweinsberg on 6/8/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(Pen)
@protocol FSPen <NSObject>

- (void)moveToPoint:(CGPoint)point;

- (void)lineToPoint:(CGPoint)point;

- (void)curveToPoints:(NSArray<NSValue *> *)points;

- (void)qCurveToPoints:(NSArray<NSValue *> *)points;

- (void)closePath;

- (void)endPath;

- (void)addComponentWithName:(NSString *)glyphName
              transformation:(CGAffineTransform)transformation;

@end
