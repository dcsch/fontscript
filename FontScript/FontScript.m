//
//  FontScript.m
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

NSString *_RandomIdentifier(NSArray<NSString *> *existing, NSUInteger recursionDepth, NSError **error) {

  // UFO identifier implementation
  if (recursionDepth >= 50) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"Failed to create a unique identifier"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIdentifierNotUnique
                               userInfo:dict];
    }
    return nil;
  }
  const NSString *characters = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  const NSUInteger identifierLength = 10;
  NSMutableString *identifier = [NSMutableString stringWithCapacity:identifierLength];
  for (NSUInteger i = 0; i < identifierLength; ++i) {
    NSRange range = NSMakeRange(rand() % characters.length, 1);
    [identifier appendString:[characters substringWithRange:range]];
  }
  if ([existing containsObject:identifier]) {
    return _RandomIdentifier(existing, recursionDepth + 1, error);
  } else {
    return identifier;
  }
}

NSString *RandomIdentifier(NSArray<NSString *> *existing, NSError **error) {
  return _RandomIdentifier(existing, 0, error);
}
