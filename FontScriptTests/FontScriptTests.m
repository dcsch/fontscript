//
//  FontScriptTests.m
//  FontScriptTests
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FontScript.h"

@interface FontScriptTests : XCTestCase
{
  NSBundle *testBundle;
}
@end

@implementation FontScriptTests

- (void)setUp {
  [super setUp];
  testBundle = [NSBundle bundleWithIdentifier:@"com.typista.FontScriptTests"];
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
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"basics"];
}

- (void)testNewFont {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_font"];

//  NSArray *fonts = script.fonts;
//  XCTAssertEqual(fonts.count, 1);
}

- (void)testAccessFontsAlreadyLoaded {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];

  [script newFontWithFamilyName:@"Test Family" styleName:@"Test Style" showInterface:NO];

  [script importModule:@"list_fonts"];
}

- (void)testNewGlyph {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_glyph"];

  NSArray<Font *> *fonts = script.fonts;
  XCTAssertEqual(fonts.count, 1);

  NSArray<Layer *> *layers = fonts[0].layers;
  XCTAssertEqual(layers.count, 1);

  NSDictionary<NSString *, Glyph *> *glyphs = layers[0].glyphs;
  XCTAssertEqual(glyphs.count, 1);
}

- (void)testGlyphNameChange {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_glyph"];
  NSDictionary<NSString *, Glyph *> *glyphs = script.fonts[0].layers[0].glyphs;
  Glyph *glyph = glyphs[@"A"];
  XCTAssertNotNil(glyph);
  XCTAssertTrue([glyph.name isEqualToString:@"A"]);

  NSError *error = nil;
  [glyph setName:@"B" error:&error];
  XCTAssertNil(error);

  Glyph *glyphB = glyphs[@"B"];
  XCTAssertEqual(glyph, glyphB);

  [script.fonts[0].layers[0] newGlyphWithName:@"C" clear:NO];
  [glyph setName:@"C" error:&error];
  XCTAssertNotNil(error);
  XCTAssertTrue([error.domain isEqualToString:FontScriptErrorDomain]);
  XCTAssertEqual(error.code, FontScriptErrorGlyphNameInUse);
}

- (void)testScriptedGlyphNameChange {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"rename_glyph"];
}

- (void)testGlyphBounds {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  Font *font = [script newFontWithFamilyName:@"Test Family"
                                   styleName:@"Test Style"
                               showInterface:NO];
  Layer *layer = [font newLayerWithName:@"Test Layer" color:nil];
  Glyph *glyph = [layer newGlyphWithName:@"A" clear:NO];
  Contour *contour = [[Contour alloc] initWithGlyph:nil];
  [glyph appendContour:contour offset:CGPointZero];

  CGRect bounds = glyph.bounds;
  XCTAssertEqual(CGRectGetMinX(bounds), -100);
  XCTAssertEqual(CGRectGetMinY(bounds), -100);
  XCTAssertEqual(CGRectGetMaxX(bounds), 100);
  XCTAssertEqual(CGRectGetMaxY(bounds), 100);
}

- (void)testRandomIdentifier {
  NSMutableArray<NSString *> *existing = [NSMutableArray array];
  NSError *error = nil;
  for (NSUInteger i = 0; i < 1000; ++i) {
    NSString *identifier = RandomIdentifier(existing, &error);
    XCTAssertNotNil(identifier);
    XCTAssertNil(error);
    [existing addObject:identifier];
  }
}

@end
