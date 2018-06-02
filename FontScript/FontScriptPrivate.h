//
//  FontScriptPrivate.h
//  FontScript
//
//  Created by David Schweinsberg on 5/30/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#ifndef FontScriptPrivate_h
#define FontScriptPrivate_h

#include <FontScript/FontScript.h>
#include <Python/Python.h>

@class Font;
@class Layer;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Font *font;
} FontObject;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Info *info;
} InfoObject;

typedef struct _LayerObject {
  PyObject_HEAD
  __unsafe_unretained Layer *layer;
} LayerObject;

@interface Font (PyObject)
@property FontObject *pyObject;
@end

@interface Info (PyObject)
@property InfoObject *pyObject;
@end

extern PyTypeObject FontType;
extern PyTypeObject InfoType;
extern PyTypeObject LayerType;
extern PyObject *FontScriptError;

#endif /* FontScriptPrivate_h */
