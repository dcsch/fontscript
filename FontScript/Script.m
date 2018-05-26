//
//  Script.m
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Script.h"
#include <Python/Python.h>

@implementation Script

- (instancetype)initWithPath:(NSString *)path {
  self = [super init];
  if (self) {
    wchar_t *p = Py_GetPath();
    size_t len = wcslen(p) * sizeof(wchar_t);
    NSString *pythonPath = [[NSString alloc] initWithBytes:p length:len encoding:NSUTF32LittleEndianStringEncoding];
    pythonPath = [pythonPath stringByAppendingFormat:@":%@", path];
    Py_SetPath((const wchar_t *)[pythonPath cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
  }
  return self;
}

- (void)runModule:(NSString *)moduleName function:(NSString *)functionName arguments:(NSArray *)args {
  Py_Initialize();
  PyObject *pName = PyUnicode_DecodeFSDefault(moduleName.UTF8String);
  PyObject *pModule = PyImport_Import(pName);
  Py_DECREF(pName);

  if (pModule != NULL) {
    PyObject *pFunc = PyObject_GetAttrString(pModule, functionName.UTF8String);

    if (pFunc && PyCallable_Check(pFunc)) {

      PyObject *pArgs = PyTuple_New(args.count);
      PyObject *pValue = NULL;
      int i = 0;
      for (NSNumber *arg in args) {
        pValue = PyLong_FromLong(arg.longValue);
        if (!pValue) {
          Py_DECREF(pArgs);
          Py_DECREF(pModule);
          NSLog(@"Cannot convert argument");
          return;
        }
        PyTuple_SetItem(pArgs, i, pValue);
        ++i;
      }
      pValue = PyObject_CallObject(pFunc, pArgs);
      Py_DECREF(pArgs);
      if (pValue != NULL) {
        NSLog(@"Result of call: %ld", PyLong_AsLong(pValue));
        Py_DECREF(pValue);
      } else {
        Py_DECREF(pFunc);
        Py_DECREF(pModule);
        PyErr_Print();
        NSLog(@"Call failed");
        return;
      }
    } else {
      if (PyErr_Occurred())
        PyErr_Print();
      NSLog(@"Cannot find function \"%@\"", functionName);
    }
    Py_XDECREF(pFunc);
    Py_DECREF(pModule);
  } else {
    PyErr_Print();
  }
  Py_FinalizeEx();
}

@end
