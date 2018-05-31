//
//  FontScriptPrivate.h
//  FontScript
//
//  Created by David Schweinsberg on 5/30/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#ifndef FontScriptPrivate_h
#define FontScriptPrivate_h

#include <Python/Python.h>

@class Font;
@class Layer;

typedef struct {
  PyObject_HEAD
  __unsafe_unretained Font *font;
} FontObject;

typedef struct _LayerObject {
  PyObject_HEAD
  __unsafe_unretained Layer *layer;
} LayerObject;

extern PyTypeObject FontType;
extern PyTypeObject LayerType;

#endif /* FontScriptPrivate_h */
