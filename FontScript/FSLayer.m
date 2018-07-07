//
//  FSLayer.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSLayer.h"
#import "FontScriptPrivate.h"
#include <Python/structmember.h>

@interface FSLayer ()
{
  LayerObject *_pyObject;
}

@end

@implementation FSLayer

- (nonnull instancetype)init {
  self = [super init];
  if (self) {
    NSLog(@"Layer init");

    _glyphs = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (nonnull instancetype)initWithName:(nonnull NSString *)name color:(NSColor *)color {
  self = [self init];
  if (self) {
    self.name = name;
    self.color = color;
  }
  return self;
}

- (void)dealloc {
  NSLog(@"Layer dealloc");

  if (self.pyObject) {
    self.pyObject->layer = nil;
    self.pyObject = NULL;
  }
}

- (LayerObject *)pyObject {
  return _pyObject;
}

- (void)setPyObject:(LayerObject *)pyObject {
  _pyObject = pyObject;
}

- (FSGlyph *)newGlyphWithName:(nonnull NSString *)name clear:(BOOL)clear {
  FSGlyph *glyph;
  if (![_glyphs.allKeys containsObject:name]) {
    glyph = [[FSGlyph alloc] initWithName:name layer:self];
  } else if (clear) {
    [_glyphs removeObjectForKey:name];
  } else {
    glyph = _glyphs[name];
  }
  _glyphs[name] = glyph;
  return glyph;
}

@end

static void Layer_dealloc(LayerObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Layer_newGlyph(LayerObject *self, PyObject *args, PyObject *keywds) {
  FSLayer *layer = self->layer;
  if (!layer) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  GlyphObject *glyphObject = (GlyphObject *)GlyphType.tp_alloc(&GlyphType, 0);
  if (glyphObject) {
    static char *kwlist[] = { "name", "clear", NULL };
    const char *name = NULL;
    bool clear = true;
    if (!PyArg_ParseTupleAndKeywords(args, keywds, "s|p", kwlist, &name, &clear))
      return NULL;
    FSGlyph *glyph = [layer newGlyphWithName:[NSString stringWithUTF8String:name] clear:clear];
    glyphObject->glyph = glyph;
    glyph.pyObject = glyphObject;
  }
  return (PyObject *)glyphObject;
}

static PyMethodDef Layer_methods[] = {
  { "newGlyph", (PyCFunction)Layer_newGlyph, METH_VARARGS | METH_KEYWORDS, NULL },
  { NULL }
};

PyTypeObject LayerType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Layer",
  .tp_doc = "Layer object",
  .tp_basicsize = sizeof(LayerObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Layer_dealloc,
//  .tp_members = Layer_members,
  .tp_methods = Layer_methods,
//  .tp_getset = Layer_getsetters,
};
