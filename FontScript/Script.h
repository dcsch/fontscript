//
//  Script.h
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Script : NSObject

- (instancetype)initWithPath:(NSString *)path;
- (void)runModule:(NSString *)moduleName function:(NSString *)functionName arguments:(NSArray *)args;

@end
