//
//  Script.h
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Font;

@interface Script : NSObject

@property(readonly) NSArray<Font *> *fonts;

- (instancetype)initWithPath:(NSString *)path;
- (void)importModule:(NSString *)moduleName;
- (void)runModule:(NSString *)moduleName function:(NSString *)functionName arguments:(NSArray *)args;

- (Font *)newFontWithFamilyName:(NSString *)familyName
                      styleName:(NSString *)styleName
                  showInterface:(BOOL)showInterface;

@end
