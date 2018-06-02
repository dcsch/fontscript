//
//  Font.m
//  FontScript
//
//  Created by David Schweinsberg on 5/26/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Font.h"
#import "Layer.h"
#import "FontScriptPrivate.h"
#include <Python/structmember.h>

@interface Font ()
{
  NSMutableArray<Layer *> *_layers;
  FontObject *_pyObject;
}

@property(readwrite) NSURL *url;

@end

@implementation Font

- (instancetype)init {
  self = [super init];
  if (self) {
    NSLog(@"Font init");

    _layers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (instancetype)initWithFamilyName:(NSString *)familyName
                         styleName:(NSString *)styleName
                     showInterface:(BOOL)showInterface {
  self = [self init];
  if (self) {

  }
  return self;
}

- (void)dealloc {
  NSLog(@"Font dealloc");

  if (self.pyObject) {
    self.pyObject->font = nil;
    self.pyObject = NULL;
  }
}

- (FontObject *)pyObject {
  return _pyObject;
}

- (void)setPyObject:(FontObject *)pyObject {
  _pyObject = pyObject;
}

- (void)saveToURL:(nonnull NSURL *)url showProgress:(BOOL)progress formatVersion:(NSUInteger)version {

}

- (Layer *)newLayerWithName:(nonnull NSString *)name color:(NSColor *)color {
  Layer *layer = [[Layer alloc] initWithName:name color:color];
  [_layers addObject:layer];
  return layer;
}

@end

static void Font_dealloc(FontObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Font_getpath(FontObject *self, void *closure) {
  Font *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }
  NSString *path = font.url ? font.url.path : @"";
  return PyUnicode_FromString(path.UTF8String);
}

static PyGetSetDef Font_getsetters[] = {
  { "path", (getter) Font_getpath, NULL, NULL, NULL },
  { NULL }
};

static PyObject *Font_save(FontObject *self, PyObject *args, PyObject *keywds) {
  Font *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  const char *path = "";
  int showProgress = 0;
  int formatVersion = 0;
  static char *kwlist[] = { "path", "showProgress", "formatVersion", NULL };

  if (!PyArg_ParseTupleAndKeywords(args, keywds, "|spi", kwlist, &path, &showProgress, &formatVersion))
    return NULL;

  font.url = [NSURL fileURLWithPath:[NSString stringWithUTF8String:path]];

  return PyLong_FromLong(0);
}

extern PyTypeObject LayerType;

static PyObject *Font_newLayer(FontObject *self, PyObject *args, PyObject *keywds) {
  Font *font = self->font;
  if (!font) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  LayerObject *layerObject = (LayerObject *)LayerType.tp_alloc(&LayerType, 0);
  if (layerObject) {
    static char *kwlist[] = { "name", "color", NULL };
    const char *name = NULL;
    PyObject *color = NULL;
    if (!PyArg_ParseTupleAndKeywords(args, keywds, "s|O", kwlist, &name, &color))
      return NULL;
    Layer *layer = [font newLayerWithName:[NSString stringWithUTF8String:name] color:nil];
    layerObject->layer = layer;
  }
  return (PyObject *)layerObject;
}

static PyMethodDef Font_methods[] = {
  { "save", (PyCFunction)Font_save, METH_VARARGS | METH_KEYWORDS, NULL },
  { "newLayer", (PyCFunction)Font_newLayer, METH_VARARGS | METH_KEYWORDS, NULL },
  { NULL }
};

PyTypeObject FontType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Font",
  .tp_doc = "Font object",
  .tp_basicsize = sizeof(FontObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Font_dealloc,
  .tp_methods = Font_methods,
  .tp_getset = Font_getsetters,
};
