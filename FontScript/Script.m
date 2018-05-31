//
//  Script.m
//  FontScript
//
//  Created by David Schweinsberg on 5/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "Script.h"
#import "FontScriptPrivate.h"
#import "Font.h"

@interface Script ()
{
  NSMutableArray<Font *> *_fonts;
}

@end

static PyMODINIT_FUNC PyInit_fontParts(void);

static __weak Script *script;

@implementation Script

- (instancetype)initWithPath:(NSString *)path {
  self = [super init];
  if (self) {
    _fonts = [[NSMutableArray alloc] init];

    wchar_t *p = Py_GetPath();
    size_t len = wcslen(p) * sizeof(wchar_t);
    NSString *pythonPath = [[NSString alloc] initWithBytes:p length:len encoding:NSUTF32LittleEndianStringEncoding];
    pythonPath = [pythonPath stringByAppendingFormat:@":%@", path];
    Py_SetPath((const wchar_t *)[pythonPath cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);

    PyImport_AppendInittab("fontParts", PyInit_fontParts);

    Py_Initialize();

    script = self;
  }
  return self;
}

- (void)dealloc {
  Py_FinalizeEx();
}

- (void)importModule:(NSString *)moduleName {
  PyObject *pName = PyUnicode_DecodeFSDefault(moduleName.UTF8String);
  PyObject *pModule = PyImport_Import(pName);
  Py_DECREF(pName);
  if (pModule == NULL) {
    PyErr_Print();
  }
}

- (void)runModule:(NSString *)moduleName function:(NSString *)functionName arguments:(NSArray *)args {
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
}

- (Font *)newFontWithFamilyName:(NSString *)familyName
                      styleName:(NSString *)styleName
                  showInterface:(BOOL)showInterface {
  Font *font = [[Font alloc] initWithFamilyName:familyName styleName:styleName showInterface:showInterface];
  [_fonts addObject:font];
  return font;
}

@end

static PyObject *fontParts_world_AllFonts(PyObject *self, PyObject *args, PyObject *keywds) {
  PyObject *sortOptions = NULL;
  static char *kwlist[] = { "sortOptions", NULL };

  if (!PyArg_ParseTupleAndKeywords(args, keywds, "|O", kwlist, &sortOptions))
    return NULL;

  

  return PyLong_FromLong(0);
}

static PyObject *fontParts_world_NewFont(PyObject *self, PyObject *args, PyObject *keywds) {
  FontObject *fontObject = (FontObject *)FontType.tp_alloc(&FontType, 0);
  if (fontObject) {
    const char *familyName = "";
    const char *styleName = "";
    bool showInterface = true;
    static char *kwlist[] = { "familyName", "styleName", "showInterface", NULL };
    if (!PyArg_ParseTupleAndKeywords(args, keywds, "|ssp", kwlist,
                                     &familyName, &styleName, &showInterface))
      return NULL;

    Font *font = [script newFontWithFamilyName:[NSString stringWithUTF8String:familyName]
                                     styleName:[NSString stringWithUTF8String:styleName]
                                 showInterface:showInterface];
    fontObject->font = font;
  }
  return (PyObject *)fontObject;
}

static PyMethodDef fontPartsMethods[] = {
  { "AllFonts", (PyCFunction)fontParts_world_AllFonts, METH_VARARGS | METH_KEYWORDS, "Get a list of all open fonts." },
  { "NewFont", (PyCFunction)fontParts_world_NewFont, METH_VARARGS | METH_KEYWORDS, "Create a new font." },
  { NULL, NULL, 0, NULL }
};

static struct PyModuleDef fontPartsModuleDef = {
  PyModuleDef_HEAD_INIT,
  .m_name = "fontParts",
  .m_doc = NULL,
  .m_size = -1,
  .m_methods = fontPartsMethods,
};

PyMODINIT_FUNC PyInit_fontParts() {
  PyObject *fontPartsModule = PyModule_Create(&fontPartsModuleDef);

  if (PyType_Ready(&FontType) < 0)
    return NULL;
  Py_INCREF(&FontType);
  PyModule_AddObject(fontPartsModule, "Font", (PyObject *) &FontType);

  if (PyType_Ready(&LayerType) < 0)
    return NULL;
  Py_INCREF(&LayerType);
  PyModule_AddObject(fontPartsModule, "Layer", (PyObject *) &LayerType);

  return fontPartsModule;
}
