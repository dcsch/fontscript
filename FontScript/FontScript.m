//
//  FSFontScript.m
//  FontScript
//
//  Created by David Schweinsberg on 6/7/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FontScript.h"

NSString *LocalizedString(NSString *string) {
  return
  NSLocalizedStringFromTableInBundle(string,
                                     nil,
                                     [NSBundle bundleWithIdentifier:@"com.typista.FontScript"],
                                     nil);
}
