//
//  ContourTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 7/5/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FSGlyph.h"
#import "FSContour.h"

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

- (void)testIdentifier {
  FSContour *contour = [[FSContour alloc] initWithGlyph:nil];
  NSString *identifier = contour.identifier;
  XCTAssertNotNil(identifier);
  XCTAssertEqualObjects(identifier, contour.identifier);
}

- (void)testIndex {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

- (void)testSetIndex {
  FSGlyph *glyph = [[FSGlyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[FSContour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);

  FSContour *contour0 = glyph.contours[0];
  FSContour *contour1 = glyph.contours[1];
  glyph.contours[0].index = 1;

  XCTAssertEqualObjects(contour0, glyph.contours[1]);
  XCTAssertEqualObjects(contour1, glyph.contours[0]);
  XCTAssertEqual(glyph.contours[0].index, 0);
  XCTAssertEqual(glyph.contours[1].index, 1);
}

@end
