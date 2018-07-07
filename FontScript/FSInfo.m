//
//  FSInfo.m
//  FontScript
//
//  Created by David Schweinsberg on 6/1/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSInfo.h"
#import "FontScriptPrivate.h"

@interface FSInfo ()
{
  InfoObject *_pyObject;
}

@end

@implementation FSInfo

- (void)dealloc {
  NSLog(@"Info dealloc");

  if (self.pyObject) {
    self.pyObject->info = nil;
    self.pyObject = NULL;
  }
}

- (InfoObject *)pyObject {
  return _pyObject;
}

- (void)setPyObject:(InfoObject *)pyObject {
  _pyObject = pyObject;
}

@end

static void Info_dealloc(InfoObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Info_getAttr(PyObject *self, PyObject *name) {
  FSInfo *info = ((InfoObject *)self)->info;
  if (!info) {
    PyErr_SetString(FontScriptError, "Peer object has been unloaded");
    return NULL;
  }

  NSString *attrName = [NSString stringWithUTF8String:PyUnicode_AsUTF8(name)];
  PyObject *value = NULL;
  if ([attrName isEqualToString:@"familyName"]) {
    value = PyUnicode_FromString(info.familyName.UTF8String);
  } else if ([attrName isEqualToString:@"styleName"]) {
    value = PyUnicode_FromString(info.styleName.UTF8String);
  } else {
    value = PyObject_GenericGetAttr(self, name);
  }
  return value;
}

PyTypeObject InfoType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Info",
  .tp_doc = "Info object",
  .tp_basicsize = sizeof(InfoObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Info_dealloc,
  .tp_getattro = Info_getAttr,
};
