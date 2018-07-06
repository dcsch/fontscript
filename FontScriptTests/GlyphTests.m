//
//  GlyphTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 6/14/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FontScript.h"

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

- (void)testCopy {
  Glyph *glyph1 = [[Glyph alloc] initWithName:@"A" layer:nil];
  glyph1.unicodes = @[@20U, @30U, @40U];
  glyph1.unicode = @10U;

  Contour *contour = [[Contour alloc] initWithGlyph:nil];
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

  glyph1.name = @"B";
  XCTAssertNotEqualObjects(glyph1.name, glyph2.name);

  glyph2.unicode = @5U;
  XCTAssertNotEqualObjects(glyph1.unicodes, glyph2.unicodes);
}

- (void)testAppendContour {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  Contour *contour = [[Contour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
//  XCTAssertEqualObjects(glyph.contours[0], contour);
}

- (void)testRemoveContour {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  Contour *contour = [[Contour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  contour = glyph.contours[0];
  NSError *error = nil;
  XCTAssertTrue([glyph removeContour:contour error:&error]);
  XCTAssertNil(error);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testRemoveContourAtIndex {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  Contour *contour = [[Contour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  NSError *error = nil;
  XCTAssertTrue([glyph removeContourAtIndex:0 error:&error]);
  XCTAssertNil(error);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testRemoveContourFail {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  XCTAssertEqual([glyph.contours count], 0);
  Contour *contour = [[Contour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);

  // Try to remove with the same contour, which is not equal (since the array
  // has a copy and equivilance is based on object address - is this how we
  // really want things?)
  NSError *error = nil;
  XCTAssertFalse([glyph removeContour:contour error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorContourNotLocated);
  XCTAssertEqual([glyph.contours count], 1);
}

- (void)testRemoveContourAtIndexFail {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  NSError *error = nil;
  XCTAssertFalse([glyph removeContourAtIndex:0 error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorContourNotLocated);
  XCTAssertEqual([glyph.contours count], 0);
}

- (void)testReorderContour {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  Contour *contour0 = glyph.contours[0];
  NSError *error = nil;
  XCTAssertTrue([glyph reorderContour:contour0 toIndex:1 error:&error]);
  XCTAssertNil(error);
  XCTAssertEqualObjects(contour0, glyph.contours[1]);
}

- (void)testReorderContourOutOfRange {
  Glyph *glyph = [[Glyph alloc] initWithName:@"A" layer:nil];
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 1);
  [glyph appendContour:[[Contour alloc] initWithGlyph:nil] offset:CGPointZero];
  XCTAssertEqual([glyph.contours count], 2);

  Contour *contour0 = glyph.contours[0];
  NSError *error = nil;
  XCTAssertFalse([glyph reorderContour:contour0 toIndex:2 error:&error]);
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorIndexOutOfRange);
  XCTAssertEqualObjects(contour0, glyph.contours[0]);
}

@end
