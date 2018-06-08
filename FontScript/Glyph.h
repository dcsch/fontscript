//
//  Glyph.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Layer;

@interface Glyph : NSObject

- (instancetype)initWithName:(nonnull NSString *)name layer:(Layer *)layer NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

// Parents
@property(weak) Layer *layer;

// Identification
@property(nonnull, readonly) NSString *name;
- (BOOL)rename:(nonnull NSString *)name error:(NSError **)error;
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

// Transformations
- (void)moveBy:(CGPoint)point;

@end
