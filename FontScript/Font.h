//
//  Font.h
//  FontScript
//
//  Created by David Schweinsberg on 5/26/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <AppKit/AppKit.h>

@class Layer;

@interface Font : NSObject

@property(readonly) NSURL *url;
@property(readonly) NSArray<Layer *> *layers;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFamilyName:(NSString *)familyName
                         styleName:(NSString *)styleName
                     showInterface:(BOOL)showInterface;

// File Operations
- (void)saveToURL:(nonnull NSURL *)url showProgress:(BOOL)progress formatVersion:(NSUInteger)version;

// Layers
- (Layer *)newLayerWithName:(nonnull NSString *)name color:(NSColor *)color;

@end
