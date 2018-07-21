//
//  FSGlyph.m
//  FontScript
//
//  Created by David Schweinsberg on 5/28/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSGlyph.h"
#import "FontScriptPrivate.h"
#import "FSComponent.h"
#import "FSBoundsPen.h"
#include <Python/structmember.h>

@interface FSGlyph ()
{
  NSString *_name;
  NSArray<NSNumber *> *_unicodes;
  NSMutableArray<FSContour *> *_contours;
  NSMutableArray<FSComponent *> *_components;
  GlyphObject *_pyObject;
}

@end

@implementation FSGlyph

- (nonnull instancetype)initWithName:(nonnull NSString *)name layer:(nullable FSLayer *)layer {
  self = [super init];
  if (self) {
    _name = name;
    self.layer = layer;
    self.unicodes = [NSArray array];
    _contours = [NSMutableArray array];
    _components = [NSMutableArray array];
  }
  return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  FSGlyph *glyph = [[FSGlyph allocWithZone:zone] initWithName:self.name layer:nil];
  glyph.unicodes = [self.unicodes copyWithZone:zone];
  glyph->_contours = [self.contours copyWithZone:zone];
  glyph->_components = [self.contours copyWithZone:zone];
  return glyph;
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
  [self setName:name error:nil];
}

- (BOOL)setName:(nonnull NSString *)name error:(NSError **)error {
  if ([_name isEqualToString:name]) {
    return YES;
  }

  if (_layer) {

    // Check that the name doesn't already exist
    if ([_layer.glyphs.allKeys containsObject:name]) {
      if (error) {
        NSString *desc = [NSString stringWithFormat:
                          LocalizedString(@"A glyph with the name '%@' already exists"),
                          name];
        NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
        *error = [NSError errorWithDomain:FontScriptErrorDomain
                                     code:FontScriptErrorGlyphNameInUse
                                 userInfo:dict];
      }
      return NO;
    }

    // Relocate the glyph in the dictionary
    [_layer.glyphs removeObjectForKey:_name];
    _layer.glyphs[name] = self;
  }
  _name = name;
  return YES;
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

- (CGFloat)leftMargin {
  return CGRectGetMinX(self.bounds);
}

- (void)setLeftMargin:(CGFloat)leftMargin {
  CGFloat delta = leftMargin - self.leftMargin;
  [self moveBy:CGPointMake(delta, 0)];
  self.width += delta;
}

- (CGFloat)rightMargin {
  return self.width - CGRectGetMaxX(self.bounds);
}

- (void)setRightMargin:(CGFloat)rightMargin {
  self.width = CGRectGetMaxX(self.bounds) + rightMargin;
}

- (CGRect)bounds {
  FSBoundsPen *pen = [[FSBoundsPen alloc] init];
  [self drawWithPen:pen];
  return pen.bounds;
}

- (nonnull FSContour *)appendContour:(nonnull FSContour *)contour offset:(CGPoint)offset {
  FSContour *copy = [contour copy];
  if (!CGPointEqualToPoint(offset, CGPointZero)) {
    [copy moveBy:offset];
  }
  [_contours addObject:copy];
  copy.glyph = self;
  return copy;
}

- (BOOL)removeContour:(nonnull FSContour *)contour error:(NSError **)error {
  NSUInteger index = [_contours indexOfObject:contour];
  if (index == NSNotFound) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"Contour not located in Glyph"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  [self removeContourAtIndex:index error:error];
  return YES;
}

- (BOOL)removeContourAtIndex:(NSUInteger)index error:(NSError **)error {
  if (index < _contours.count) {
    FSContour *contour = [_contours objectAtIndex:index];
    contour.glyph = nil;
    [_contours removeObjectAtIndex:index];
  } else {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"No contour located at index %u"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  return YES;
}

- (void)clearContours {
  for (FSContour *contour in _contours) {
    contour.glyph = nil;
  }
  [_contours removeAllObjects];
}

- (BOOL)reorderContour:(nonnull FSContour *)contour toIndex:(NSUInteger)index error:(NSError **)error {
  if (index >= _contours.count) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"Index %u is out-of-range"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIndexOutOfRange
                               userInfo:dict];
    }
    return NO;
  }
  [self removeContour:contour error:error];
  if (error && *error) {
    return NO;
  }
  [_contours insertObject:contour atIndex:index];
  contour.glyph = self;
  return YES;
}

- (FSComponent *)appendComponentWithGlyphName:(nonnull NSString *)glyphName
                                       offset:(CGPoint)offset
                                        scale:(CGPoint)scale {
  FSComponent *component = [[FSComponent alloc] initWithBaseGlyphName:glyphName];
  component.offset = offset;
  component.scale = scale;
  [_components addObject:component];
  component.glyph = self;
  return component;
}

- (FSComponent *)appendComponent:(nonnull FSComponent *)component {
  FSComponent *copy = [component copy];
  [_components addObject:copy];
  copy.glyph = self;
  return copy;
}

- (BOOL)removeComponent:(nonnull FSComponent *)component error:(NSError **)error {
  NSUInteger index = [_components indexOfObject:component];
  if (index == NSNotFound) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"Component not located in Glyph"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  [self removeComponentAtIndex:index error:error];
  return YES;
}

- (BOOL)removeComponentAtIndex:(NSUInteger)index error:(NSError **)error {
  if (index < _components.count) {
    FSComponent *component = [_components objectAtIndex:index];
    component.glyph = nil;
    [_components removeObjectAtIndex:index];
  } else {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"No component located at index %u"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorContourNotLocated
                               userInfo:dict];
    }
    return NO;
  }
  return YES;
}

- (void)clearComponents {
  for (FSComponent *component in _components) {
    component.glyph = nil;
  }
  [_components removeAllObjects];
}

- (BOOL)reorderComponent:(nonnull FSComponent *)component toIndex:(NSUInteger)index error:(NSError **)error {
  if (index >= _components.count) {
    if (error) {
      NSString *desc = [NSString stringWithFormat:
                        LocalizedString(@"Index %u is out-of-range"),
                        index];
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorIndexOutOfRange
                               userInfo:dict];
    }
    return NO;
  }
  [self removeComponent:component error:error];
  if (error && *error) {
    return NO;
  }
  [_components insertObject:component atIndex:index];
  component.glyph = self;
  return YES;
}

- (BOOL)decomposeWithError:(NSError **)error {
  for (FSComponent *component in self.components) {
    if (![component decomposeWithError:error]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)decomposeComponent:(nonnull FSComponent *)component error:(NSError **)error {
  if (!self.layer) {
    if (error) {
      NSString *desc = LocalizedString(@"Glyph is not a member of a layer");
      NSDictionary *dict = @{ NSLocalizedDescriptionKey : desc };
      *error = [NSError errorWithDomain:FontScriptErrorDomain
                                   code:FontScriptErrorGlyphNotFoundInLayer
                               userInfo:dict];
    }
    return NO;
  }

  FSGlyph *glyph = self.layer.glyphs[component.baseGlyphName];
  for (FSContour *contour in glyph.contours) {
    [contour transformBy:component.transformation];
    [self appendContour:contour offset:CGPointZero];
  }
  return [self removeComponent:component error:error];
}

- (void)moveBy:(CGPoint)point {
}

- (void)drawWithPen:(NSObject<FSPen> *)pen {
  for (FSContour *contour in self.contours) {
    [contour drawWithPen:pen];
  }
  for (FSComponent *component in self.components) {
    [component drawWithPen:pen];
  }
}

- (void)drawWithPointPen:(NSObject<FSPointPen> *)pointPen {
  for (FSContour *contour in self.contours) {
    [contour drawWithPointPen:pointPen];
  }
  for (FSComponent *component in self.components) {
    [component drawWithPointPen:pointPen];
  }
}

@end

static void Glyph_dealloc(GlyphObject *self) {
  Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *Glyph_getName(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyUnicode_FromString(glyph.name.UTF8String);
}

static int Glyph_setName(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !PyUnicode_Check(value)) {
    PyErr_SetString(PyExc_TypeError,
                    "The name attribute value must be a string");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  NSError *error = nil;
  [glyph setName:[NSString stringWithUTF8String:PyUnicode_AsUTF8(value)] error:&error];
  if (error) {
    PyErr_SetString(PyExc_ValueError, error.localizedDescription.UTF8String);
    return -1;
  }
  return 0;
}

static PyObject *Glyph_getUnicodes(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
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
  FSGlyph *glyph = self->glyph;
  glyph.unicodes = unicodes;
  return 0;
}

static PyObject *Glyph_getUnicode(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyLong_FromLong(glyph.unicode.longValue);
}

static int Glyph_setUnicode(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || value == Py_None)) {
    PyErr_SetString(PyExc_TypeError,
                    "The unicode attribute value must be an integer or None");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  if (value == Py_None) {
    glyph.unicodes = [NSArray array];
  } else {
    glyph.unicode = [NSNumber numberWithLong:PyLong_AsLong(value)];
  }
  return 0;
}

static PyObject *Glyph_getWidth(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.width);
}

static int Glyph_setWidth(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The width attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.width = PyFloat_AsDouble(value);
  return 0;
}

static PyObject *Glyph_getLeftMargin(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.leftMargin);
}

static int Glyph_setLeftMargin(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The leftMargin attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.leftMargin = PyFloat_AsDouble(value);
  return 0;
}

static PyObject *Glyph_getRightMargin(GlyphObject *self, void *closure) {
  FSGlyph *glyph = self->glyph;
  return PyFloat_FromDouble(glyph.rightMargin);
}

static int Glyph_setRightMargin(GlyphObject *self, PyObject *value, void *closure) {
  if (value == NULL || !(PyLong_Check(value) || PyFloat_Check(value))) {
    PyErr_SetString(PyExc_TypeError,
                    "The rightMargin attribute value must be an integer or float");
    return -1;
  }
  FSGlyph *glyph = self->glyph;
  glyph.rightMargin = PyFloat_AsDouble(value);
  return 0;
}

static PyGetSetDef Glyph_getsetters[] = {
  { "name", (getter)Glyph_getName, (setter)Glyph_setName, NULL, NULL },
  { "unicodes", (getter)Glyph_getUnicodes, (setter)Glyph_setUnicodes, NULL, NULL },
  { "unicode", (getter)Glyph_getUnicode, (setter)Glyph_setUnicode, NULL, NULL },
  { "width", (getter)Glyph_getWidth, (setter)Glyph_setWidth, NULL, NULL },
  { "leftMargin", (getter)Glyph_getLeftMargin, (setter)Glyph_setLeftMargin, NULL, NULL },
  { "rightMargin", (getter)Glyph_getRightMargin, (setter)Glyph_setRightMargin, NULL, NULL },
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
