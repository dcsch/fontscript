//
//  Glyph.h
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Glyph : NSObject

@property(nonnull) NSString *name;
@property(nonnull) NSArray<NSNumber *> *unicodes;
@property(nullable) NSNumber *unicode;

- (instancetype)initWithName:(nonnull NSString *)name;

@end
