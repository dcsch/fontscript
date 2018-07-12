//
//  FSPointPen.h
//  FontScript
//
//  Created by David Schweinsberg on 7/9/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSegment.h"
#import "FSPoint.h"

NS_SWIFT_NAME(PointPen)
@protocol FSPointPen <NSObject>
- (void)beginPath;
- (void)beginPathWithIdentifier:(nullable NSString *)identifier;
- (void)endPath;
- (void)addPoint:(nonnull FSPoint *)point;
- (void)addPoints:(nonnull NSArray<FSPoint *> *)points;
- (void)addPointWithPoint:(CGPoint)pt
                pointType:(FSPointType)pointType
                   smooth:(BOOL)smooth;
- (void)addPointWithPoint:(CGPoint)pt
                pointType:(FSPointType)pointType
                   smooth:(BOOL)smooth
                     name:(nullable NSString *)name
               identifier:(nullable NSString *)identifier;
- (void)addComponentWithBaseGlyphName:(nonnull NSString *)baseGlyphName
                       transformation:(CGAffineTransform)transformation
                           identifier:(nullable NSString *)identifier
                                error:(NSError **)error;
@end
