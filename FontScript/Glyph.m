//
//  Glyph.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Glyph.h"
#import "FontScriptPrivate.h"
#include <Python/structmember.h>

@interface Glyph ()
{
  NSString *_name;
  NSArray<NSNumber *> *_unicodes;
  GlyphObject *_pyObject;
}

@end

@implementation Glyph

- (instancetype)initWithName:(nonnull NSString *)name layer:(Layer *)layer {
  self = [super init];
  if (self) {
    self.name = name;
    self.layer = layer;
    self.unicodes = [NSArray array];
  }
  return self;
}

- (void)dealloc {
  NSLog(@"Glyph dealloc");

  if (self.pyObject) {
    self.pyObject->glyph = nil;
    self.pyObject = NULL;
  }
}

- (GlyphObject *)pyObject {
  return _pyObject;
}

- (void)setPyObject:(GlyphObject *)pyObject {
  _pyObject = pyObject;
}

- (nonnull NSString *)name {
  return _name;
}

- (void)setName:(nonnull NSString *)name {
  if ([_name isEqualToString:name]) {
    return;
  }

  if (_layer) {

    // Check that the name doesn't already exist
    if ([_layer.glyphs.allKeys containsObject:name]) {
      return;
    }

    // Relocate the glyph in the dictionary
    [_layer.glyphs removeObjectForKey:_name];
    _layer.glyphs[name] = self;
  }

  _name = name;
}

- (nullable NSNumber *)unicode {
  if (self.unicodes.count > 0) {
    return self.unicodes[0];
  } else {
    return nil;
  }
}

- (void)setUnicode:(nullable NSNumber *)unicode {
  NSMutableArray *copy = [self.unicodes mutableCopy];
  if ([self.unicodes containsObject:unicode]) {
    [copy removeObject:unicode];
  }
  [copy insertObject:unicode atIndex:0];
  self.unicodes = copy;
}

@end

static void Glyph_dealloc(GlyphObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Glyph_getUnicodes(GlyphObject *self, void *closure) {
  Glyph *glyph = self->glyph;
  PyObject *list = PyList_New(0);
  for (NSNumber *unicode in glyph.unicodes) {
    PyList_Append(list, PyLong_FromLong(unicode.longValue));
  }
  return list;
}

static int Glyph_setUnicodes(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !PyList_Check(value)) {
    PyErr_SetString(PyExc_TypeError,
                    "The unicodes attribute value must be a list");
    return -1;
  }
  NSMutableArray<NSNumber *> *unicodes = [[NSMutableArray alloc] init];
  for (Py_ssize_t i = 0; i < PyList_Size(value); ++i) {
    PyObject *item = PyList_GetItem(value, i);
    if (!PyLong_Check(item)) {
      PyErr_SetString(PyExc_TypeError, "Unicode values must be an integer");
      return -1;
    }
    [unicodes addObject:[NSNumber numberWithLong:PyLong_AsLong(item)]];
  }
  Glyph *glyph = self->glyph;
  glyph.unicodes = unicodes;
  return 0;
}

static PyObject *Glyph_getUnicode(GlyphObject *self, void *closure) {
  Glyph *glyph = self->glyph;
  return PyLong_FromLong(glyph.unicode.longValue);
}

static int Glyph_setUnicode(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || value == Py_None)) {
    PyErr_SetString(PyExc_TypeError,
                    "The unicode attribute value must be an integer or None");
    return -1;
  }
  Glyph *glyph = self->glyph;
  if (value == Py_None) {
    glyph.unicodes = [NSArray array];
  } else {
    glyph.unicode = [NSNumber numberWithLong:PyLong_AsLong(value)];
  }
  return 0;
}

static PyGetSetDef Glyph_getsetters[] = {
  { "unicodes", (getter)Glyph_getUnicodes, (setter)Glyph_setUnicodes, NULL, NULL },
  { "unicode", (getter)Glyph_getUnicode, (setter)Glyph_setUnicode, NULL, NULL },
  { NULL }
};

PyTypeObject GlyphType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Glyph",
  .tp_doc = "Glyph object",
  .tp_basicsize = sizeof(GlyphObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Glyph_dealloc,
  .tp_getset = Glyph_getsetters,
};
