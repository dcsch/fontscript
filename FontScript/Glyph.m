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
  NSArray<NSNumber *> *_unicodes;
  GlyphObject *_pyObject;
}

@end

@implementation Glyph

- (instancetype)initWithName:(nonnull NSString *)name {
  self = [super init];
  if (self) {
    self.name = name;
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

PyTypeObject GlyphType = {
  PyVarObject_HEAD_INIT(NULL, 0)
  .tp_name = "fontParts.Glyph",
  .tp_doc = "Glyph object",
  .tp_basicsize = sizeof(GlyphObject),
  .tp_itemsize = 0,
  .tp_flags = Py_TPFLAGS_DEFAULT,
  .tp_dealloc = (destructor)Glyph_dealloc,
};
