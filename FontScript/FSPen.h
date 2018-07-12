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

/*!
 Moves the pen to the specified point without creating a line or curve,
 which then becomes the current point.
 @param point The point to move to.
 */
- (void)moveToPoint:(CGPoint)point;

/*!
 Draws a line from the current point to the specified end point.
 @param point The end point of the line to draw.
 */
- (void)lineToPoint:(CGPoint)point;

- (void)curveToPoints:(nonnull NSArray<NSValue *> *)points;

- (void)qCurveToPoints:(nonnull NSArray<NSValue *> *)points;

- (void)closePath;

- (void)endPath;

- (void)addComponentWithName:(nonnull NSString *)glyphName
              transformation:(CGAffineTransform)transformation
                       error:(NSError **)error;

@end
