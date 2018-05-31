//
//  Layer.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface Layer : NSObject

@property NSString *name;
@property NSColor *color;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(nonnull NSString *)name color:(NSColor *)color;

@end
