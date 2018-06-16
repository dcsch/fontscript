//
//  GlyphTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Glyph.h"
#import "Contour.h"

@interface GlyphTests : XCTestCase

@end

@implementation GlyphTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testGlyphCopy {
  Glyph *glyph1 = [[Glyph alloc] initWithName:@"A" layer:nil];
  glyph1.unicodes = @[[NSNumber numberWithUnsignedInteger:20],
                      [NSNumber numberWithUnsignedInteger:30],
                      [NSNumber numberWithUnsignedInteger:40]];
  glyph1.unicode = @10U;

  Contour *contour = [[Contour alloc] init];
  [glyph1 appendContour:contour offset:CGPointZero];

  Glyph *glyph2 = [glyph1 copy];
  XCTAssertNotEqualObjects(glyph1, glyph2);
  XCTAssertEqualObjects(glyph1.name, glyph2.name);
  XCTAssertEqualObjects(glyph1.unicodes, glyph2.unicodes);
  XCTAssertEqualObjects(glyph1.contours, glyph2.contours);
  XCTAssertEqual(glyph1.width, glyph2.width);
  XCTAssertEqual(glyph1.leftMargin, glyph2.leftMargin);
  XCTAssertEqual(glyph1.rightMargin, glyph2.rightMargin);
  XCTAssertEqual(glyph1.height, glyph2.height);
  XCTAssertEqual(glyph1.bottomMargin, glyph2.bottomMargin);
  XCTAssertEqual(glyph1.topMargin, glyph2.topMargin);

  [glyph1 rename:@"B" error:nil];
  XCTAssertNotEqualObjects(glyph1.name, glyph2.name);

  glyph2.unicode = @5U;
  XCTAssertNotEqualObjects(glyph1.unicodes, glyph2.unicodes);
}

@end
