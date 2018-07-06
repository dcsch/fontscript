//
//  ContourTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/5/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Glyph.h"
#import "Contour.h"

@interface ContourTests : XCTestCase

@end

@implementation ContourTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndex {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

- (void)testSetIndex {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);

  Contour *contour0 = glyph.contours[0];
  Contour *contour1 = glyph.contours[1];
  glyph.contours[0].index = 1;

  XCTAssertEqualObjects(contour0, glyph.contours[1]);
  XCTAssertEqualObjects(contour1, glyph.contours[0]);
  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

@end
