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

@property(weak) Layer *layer;
@property(nonnull) NSString *name;
@property(nonnull) NSArray<NSNumber *> *unicodes;
@property(nullable) NSNumber *unicode;

- (instancetype)initWithName:(nonnull NSString *)name layer:(Layer *)layer NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable));

@end
