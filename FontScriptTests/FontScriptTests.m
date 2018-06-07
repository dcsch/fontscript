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
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"basics"];
}

- (void)testNewFont {
  Script *script = [[Script alloc] initWithPath:testBundle.resourceURL.path];
  [script importModule:@"new_font"];

  NSArray *fonts = script.fonts;
  XCTAssertEqual(fonts.count, 1);
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

  glyph.name = @"B";
  Glyph *glyphB = glyphs[@"B"];
  XCTAssertEqual(glyph, glyphB);

  [script.fonts[0].layers[0] newGlyphWithName:@"C" clear:NO];
  glyph.name = @"C";
}

@end
