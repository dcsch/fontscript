//
//  FontScriptTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Script.h"

@interface FontScriptTests : XCTestCase
{
  NSBundle *testBundle;
}
@end

@implementation FontScriptTests

- (void)setUp {
  [super setUp];

  NSUInteger i = [NSBundle.allBundles indexOfObjectPassingTest:^BOOL(NSBundle * _Nonnull obj,
                                                                     NSUInteger idx,
                                                                     BOOL * _Nonnull stop) {
    return [obj.bundleIdentifier isEqualToString:@"com.typista.FontScriptTests"];
  }];
  testBundle = NSBundle.allBundles[i];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  NSString *bundlePath = testBundle.resourceURL.path;
  Script *script = [[Script alloc] initWithPath:bundlePath];
  [script runModule:@"multiply" function:@"multiply" arguments:@[@3, @2]];
}

- (void)testBasics {
  NSString *bundlePath = testBundle.resourceURL.path;
  Script *script = [[Script alloc] initWithPath:bundlePath];
  [script importModule:@"basics"];
}

@end
