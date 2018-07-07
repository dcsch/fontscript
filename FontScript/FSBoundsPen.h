//
//  BoundsPen.h
//  FontScript
//
//  Created by David Schweinsberg on 6/8/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSAbstractPen.h"

NS_SWIFT_NAME(BoundsPen)
@interface FSBoundsPen : NSObject <FSAbstractPen>

@property CGRect bounds;

@end
