//
//  UIView+Screenshot.h
//  iFly
//
//  Created by Andrei Ghidoarca on 3/13/13.
//  Copyright (c) 2013 xtpl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage*)screenshot;
- (UIImage*)screenshotInRect:(CGRect)rect;

@end
