//
//  LayoutUtils.m
//  iCelsius
//
//  Created by Andrei Ghidoarca on 03/11/14.
//  Copyright (c) 2014 Aginova Inc. All rights reserved.
//

#import "LayoutUtils.h"
#import "Defines.h"

@implementation LayoutUtils

+ (void) addContraintWidth:(CGFloat)width andHeight:(CGFloat)height forView:(UIView*)view
{
    NSLayoutConstraint *wC = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    NSLayoutConstraint *hC = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [view addConstraints:@[wC,hC]];
}

+ (NSLayoutConstraint*) addContraintHeight:(CGFloat)height forView:(UIView*)view
{
    NSLayoutConstraint *hC = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [view addConstraint:hC];
    
    return hC;
}

+ (NSLayoutConstraint*) addContraintWidth:(CGFloat)width forView:(UIView*)view
{
    NSLayoutConstraint *wC = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    [view addConstraint:wC];
    
    return wC;
}

+ (NSLayoutConstraint*) addBottomConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant
{
    NSLayoutConstraint *bC = [NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:toView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:constant];
    [toView addConstraint:bC];
    return bC;
}

+ (NSLayoutConstraint*) addTopConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant
{
    NSLayoutConstraint *tC = [NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:toView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:constant];
    [toView addConstraint:tC];
    return tC;
}

+ (NSLayoutConstraint*) addLeadingConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant
{
    NSLayoutConstraint *lC = [NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:toView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:constant];
    
    [toView addConstraint:lC];
    return lC;
}

+ (NSLayoutConstraint*) addTrailingConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant
{
    NSLayoutConstraint *lC = [NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:toView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:constant];
    
    [toView addConstraint:lC];
    return lC;
}

+ (NSLayoutConstraint*) addLeftRightConstraintFromView:(UIView*)left toView:(UIView*)right parent:(UIView*)parent
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:left
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:right
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0];
    
    [parent addConstraint:c];
    return c;
}

+ (NSLayoutConstraint*) addLeftRightConstraintFromView:(UIView*)left toView:(UIView*)right parent:(UIView*)parent constant:(float)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:left
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:right
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:constant];
    
    [parent addConstraint:c];
    return c;
}

+ (NSLayoutConstraint*) addTopBottomConstraintFromView:(UIView*)top toView:(UIView*)bottom parent:(UIView*)parent constant:(float)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:bottom
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:top
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:constant];
    
    [parent addConstraint:c];
    return c;
}

+ (NSLayoutConstraint*) addBottomTopConstraintFromView:(UIView*)top toView:(UIView*)bottom parent:(UIView*)parent constant:(float)constant
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:top
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:bottom
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:constant];
    
    [parent addConstraint:c];
    return c;
}

+ (void) addCenterConstraintFromView:(UIView*)view toView:(UIView*)toView forX:(BOOL)forX forY:(BOOL)forY
{
    NSLayoutConstraint *xC = [NSLayoutConstraint constraintWithItem:toView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0];
    
    NSLayoutConstraint *yC = [NSLayoutConstraint constraintWithItem:toView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0];
    
    
    if (forX)
    {
        [toView.superview addConstraint:xC];
    }
    if (forY)
    {
        [toView.superview addConstraint:yC];
    }
}

+ (void) addGradientLayoutForView:(UIView*)view
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint       = ccp(0, 0);
    layer.endPoint         = ccp(0, 1);
    layer.masksToBounds    = YES;
    
    layer.frame = view.bounds;
    layer.colors = @[(id)[UIColor blackColor].CGColor, (id)cclear.CGColor];
    layer.locations = @[@(0), @(0.6)];
    
    [view.layer insertSublayer:layer atIndex:0];
}

+ (UIView*) createInputAccessoryViewForTarget:(id)target
{
    UIView *view = [[UIView alloc] initWithFrame:ccf(0, 0, 320, 41)];
    view.backgroundColor = cclear;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:ccf(0, 0, 320, 41)];
    img.image = ccimg(@"barbar_white");
    [img addDefaultShadow];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:ccf(255, 0, 60, 41)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setImage:ccimg(@"close_keyboard") forState:UIControlStateNormal];
    SEL selector = NSSelectorFromString(@"cancelTextFieldAction");
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:img];
    [view addSubview:btn];
    
    return view;
}

+ (UILabel*) redLabel
{
    UILabel *redLabel = [[UILabel alloc] initWithFrame:ccf(203, 7, 14, 14)];
    redLabel.backgroundColor = ccolor(235, 87, 95);
    redLabel.textColor = ccwhite;
    redLabel.layer.masksToBounds = YES;
    redLabel.layer.cornerRadius  = 7;
    redLabel.textAlignment = NSTextAlignmentCenter;
    redLabel.font = [UIFont boldSystemFontOfSize:10];
    
    return redLabel;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
    
    float oldWidth = image.size.width;
    float scaleFactor = newSize.width / oldWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIView (Layout)

- (void) fadeIn
{
    self.alpha = 0.0f;
    self.hidden = NO;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1.0f;
    }];
}

- (void) fadeOut
{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0.0f;
    }];
}

- (void) setCornerRadius:(float)radius
{
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = YES;
}

- (void) addDefaultBorder
{
    self.layer.borderColor = ccolor(85, 85, 85).CGColor;
    self.layer.borderWidth = 2;
}

- (void) addDefaultShadow
{
    self.layer.shadowColor   = ccblack.CGColor;
    self.layer.shadowOffset  = ccs(1, 1);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius  = 4;
}

- (void) removeShadow
{
    self.layer.shadowRadius  = 0;
    self.layer.shadowOpacity = 0;
}

- (void) moveViewLeftWith:(float)offset
{
    CGRect frame = self.frame;
    frame.origin.x -= offset;
    self.frame = frame;
}

- (void) addBorderWithColor:(UIColor*)color andWidth:(float)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

@end

@implementation UIView (BBQLayout)

- (void) addTrashGradient
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint       = ccp(0, 0);
    layer.endPoint         = ccp(0, 1);
    layer.masksToBounds    = YES;
    
    layer.frame = self.bounds;
    layer.colors = @[(id)ccolora(66, 213, 81, 0.6).CGColor, (id)ccolora(66, 213, 81, 1).CGColor];
    layer.locations = @[@(0.5), @(1)];
    
    [self.layer insertSublayer:layer atIndex:0];
}

- (void) addTextFieldStyle
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 3.0f;
    
    self.layer.borderColor = ccwhite.CGColor;
    self.layer.borderWidth = 1;
}

@end

@implementation UINavigationController (ProductionLayout)

+ (void) setProductionStyle
{

    [[UINavigationBar appearance] setTintColor:ccwhite];
    [[UINavigationBar appearance] setBarTintColor:ccolor(52, 52, 52)];
    [[UINavigationBar appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys: ccolor(255, 255, 255), NSForegroundColorAttributeName, ccFont(@"Roboto-Light", 21), NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTranslucent:NO];
}

@end

@implementation UIBarButtonItem (ProductionLayout)

+ (void) setProductionStyle
{
    NSDictionary* barButtonItemAttributes = @{NSFontAttributeName:ccFont(@"Roboto-Light", 18), NSForegroundColorAttributeName: ccwhite};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
}

@end
