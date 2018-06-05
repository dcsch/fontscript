//
//  FontScriptPrivate.h
//  FontScript
//
//  Created by David Schweinsberg on 5/30/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#include <FontScript/FontScript.h>
#include <Python/Python.h>

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Font *font;
} FontObject;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Info *info;
} InfoObject;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Layer *layer;
} LayerObject;

typedef struct  {
  PyObject_HEAD
  __unsafe_unretained Glyph *glyph;
} GlyphObject;

@interface Font (PyObject)
@property FontObject *pyObject;
@end

@interface Info (PyObject)
@property InfoObject *pyObject;
@end

@interface Layer (PyObject)
@property LayerObject *pyObject;
@end

@interface Glyph (PyObject)
@property GlyphObject *pyObject;
@end

extern PyTypeObject FontType;
extern PyTypeObject InfoType;
extern PyTypeObject LayerType;
extern PyTypeObject GlyphType;
extern PyObject *FontScriptError;
