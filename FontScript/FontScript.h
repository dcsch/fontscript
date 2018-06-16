//
//  FontScript.h
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for FontScript.
FOUNDATION_EXPORT double FontScriptVersionNumber;

//! Project version string for FontScript.
FOUNDATION_EXPORT const unsigned char FontScriptVersionString[];

FOUNDATION_EXPORT NSErrorDomain const FontScriptErrorDomain;

NSString *LocalizedString(NSString *string);

NS_ERROR_ENUM(FontScriptErrorDomain)
{
  FontScriptErrorUnknown = -1,
  FontScriptErrorGlyphNameInUse = -999,
};

#import <FontScript/Script.h>
#import <FontScript/Font.h>
#import <FontScript/Info.h>
#import <FontScript/Layer.h>
#import <FontScript/Glyph.h>
#import <FontScript/Contour.h>
