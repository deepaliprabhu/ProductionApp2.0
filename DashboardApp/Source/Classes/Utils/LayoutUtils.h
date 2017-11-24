//
//  LayoutUtils.h
//  iCelsius
//
//  Created by Andrei Ghidoarca on 03/11/14.
//  Copyright (c) 2014 Aginova Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PURPLECOLOR     ccolor(90, 87, 251)

@interface LayoutUtils : NSObject

+ (void) addContraintWidth:(CGFloat)width andHeight:(CGFloat)height forView:(UIView*)view;
+ (NSLayoutConstraint*) addContraintWidth:(CGFloat)width forView:(UIView*)view;
+ (NSLayoutConstraint*) addContraintHeight:(CGFloat)height forView:(UIView*)view;
+ (void) addCenterConstraintFromView:(UIView*)view toView:(UIView*)toView forX:(BOOL)forX forY:(BOOL)forY;
+ (NSLayoutConstraint*) addBottomConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant;
+ (NSLayoutConstraint*) addTopConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant;
+ (NSLayoutConstraint*) addLeadingConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant;
+ (NSLayoutConstraint*) addTrailingConstraintFromView:(UIView*)view toView:(UIView*)toView constant:(CGFloat)constant;
+ (NSLayoutConstraint*) addLeftRightConstraintFromView:(UIView*)left toView:(UIView*)right parent:(UIView*)parent;
+ (NSLayoutConstraint*) addLeftRightConstraintFromView:(UIView*)left toView:(UIView*)right parent:(UIView*)parent constant:(float)constant;
+ (NSLayoutConstraint*) addTopBottomConstraintFromView:(UIView*)top toView:(UIView*)bottom parent:(UIView*)parent constant:(float)constant;
+ (NSLayoutConstraint*) addBottomTopConstraintFromView:(UIView*)top toView:(UIView*)bottom parent:(UIView*)parent constant:(float)constant;
+ (UIView*) createInputAccessoryViewForTarget:(id)target;
+ (UILabel*) redLabel;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (void) addGradientLayoutForView:(UIView*)view;

@end

@interface UIView (Layout)

- (void) setCornerRadius:(float)radius;
- (void) addDefaultShadow;
- (void) removeShadow;
- (void) moveViewLeftWith:(float)offset;

- (void) addDefaultBorder;
- (void) addBorderWithColor:(UIColor*)color andWidth:(float)width;
- (void) fadeIn;
- (void) fadeOut;

@end

@interface UIView (BBQLayout)

- (void) addTrashGradient;
- (void) addTextFieldStyle;

@end

@interface UINavigationController (ProductionLayout)

+ (void) setProductionStyle;

@end

@interface UIBarButtonItem (ProductionLayout)

+ (void) setProductionStyle;

@end
