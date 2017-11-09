//
//  UIView+Screenshot.m
//  iFly
//
//  Created by Andrei Ghidoarca on 3/13/13.
//  Copyright (c) 2013 xtpl. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

- (UIImage*)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
//    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
//    image = [UIImage imageWithData:imageData];
    
    return image;
}

- (UIImage*)screenshotInRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(img, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    CGImageRelease(imageRef);
    
    return image;
}

@end
