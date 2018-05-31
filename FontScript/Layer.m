//
//  Layer.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Layer.h"
#import "FontScriptPrivate.h"
#include <Python/structmember.h>

@implementation Layer

- (instancetype)init {
  self = [super init];
  if (self) {
    NSLog(@"Layer init");
  }
  return self;
}

- (instancetype)initWithName:(nonnull NSString *)name color:(NSColor *)color {
  self = [self init];
  if (self) {
    self.name = name;
    self.color = color;
  }
  return self;
}

- (void)dealloc {
  NSLog(@"Layer dealloc");
}

@end

static void Layer_dealloc(LayerObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

PyTypeObject LayerType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Layer",
  .tp_doc = "Layer object",
  .tp_basicsize = sizeof(LayerObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Layer_dealloc,
//  .tp_members = Layer_members,
//  .tp_methods = Layer_methods,
//  .tp_getset = Layer_getsetters,
};
