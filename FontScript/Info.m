//
//  Info.m
//  FontScript
//
//  Created by David Schweinsberg on 6/1/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Info.h"
#import "FontScriptPrivate.h"

@implementation Info

@end

static void Info_dealloc(InfoObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

PyTypeObject InfoType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Info",
  .tp_doc = "Info object",
  .tp_basicsize = sizeof(InfoObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,
  .tp_dealloc = (destructor)Info_dealloc,
//  .tp_methods = Info_methods,
//  .tp_getset = Info_getsetters,
};
