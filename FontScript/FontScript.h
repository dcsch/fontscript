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
  FontScriptErrorContourNotLocated = -1000,
  FontScriptErrorIndexOutOfRange = -1001,
  FontScriptErrorIdentifierNotUnique = -1002
};

#import <FontScript/FSScript.h>
#import <FontScript/FSFont.h>
#import <FontScript/FSInfo.h>
#import <FontScript/FSLayer.h>
#import <FontScript/FSGlyph.h>
#import <FontScript/FSContour.h>
#import <FontScript/FSSegment.h>
#import <FontScript/FSPoint.h>
#import <FontScript/FSComponent.h>
#import <FontScript/FSInfo.h>
#import <FontScript/FSPen.h>
#import <FontScript/FSPointPen.h>
#import <FontScript/FSPointToSegmentPen.h>
#import <FontScript/FSBoundsPen.h>
#import <FontScript/FSIdentifier.h>
