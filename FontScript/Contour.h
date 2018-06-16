//
//  Contour.h
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractPen;

@interface Contour : NSObject <NSCopying>

// Parents

// Identification

// Winding Direction

// Queries

// Pens and Drawing
- (void)drawWithPen:(NSObject<AbstractPen> *)pen;

// Segments

// bPoints

// Points

// Transformations
- (void)moveBy:(CGPoint)point;

// Normalization

// Environment

@end
