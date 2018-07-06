//
//  Glyph.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Font;
@class Layer;
@class Contour;
@protocol AbstractPen;

@interface Glyph : NSObject <NSCopying>

- (instancetype)initWithName:(nonnull NSString *)name layer:(nullable Layer *)layer NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) Layer *layer;
@property(weak) Font *font;

// Identification
@property(nonnull) NSString *name;
- (BOOL)setName:(nonnull NSString *)name error:(NSError **)error;
@property(nonnull) NSArray<NSNumber *> *unicodes;
@property(nullable) NSNumber *unicode;

// Metrics
@property CGFloat width;
@property CGFloat leftMargin;
@property CGFloat rightMargin;
@property CGFloat height;
@property CGFloat bottomMargin;
@property CGFloat topMargin;

// Queries
@property(readonly) CGRect bounds;

// Pens and Drawing
- (void)drawWithPen:(NSObject<AbstractPen> *)pen;

// Layers

// Global

// Contours
@property(nonnull, readonly) NSArray<Contour *> *contours;
- (Contour *)appendContour:(nonnull Contour *)contour offset:(CGPoint)offset;
- (BOOL)removeContour:(nonnull Contour *)contour error:(NSError **)error;
- (BOOL)removeContourAtIndex:(NSUInteger)index error:(NSError **)error;
- (void)clearContours;
- (BOOL)reorderContour:(nonnull Contour *)contour toIndex:(NSUInteger)index error:(NSError **)error;

// Components

// Anchors

// Guidelines

// Image

// Note

// Sub-Objects

// Transformations
- (void)moveBy:(CGPoint)point;

// Interpolation

// Normalization

// Environment

@end
