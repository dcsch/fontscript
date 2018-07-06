//
//  Contour.h
//  FontScript
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Glyph;
@class Layer;
@class Font;
@protocol AbstractPen;

@interface Contour : NSObject <NSCopying>

- (instancetype)initWithGlyph:(nullable Glyph *)glyph NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) Glyph *glyph;
@property(readonly, weak) Layer *layer;
@property(readonly, weak) Font *font;

// Identification
@property NSUInteger index;

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
