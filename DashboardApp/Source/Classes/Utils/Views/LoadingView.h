//
//  LoadingView.h
//  Auto
//
//  Created by Andrei Ghidoarca on 2/8/12.
//  Copyright (c) 2012 Gambit S.R.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView*) sharedComponent;
+ (void) showLoading:(NSString*)text withYOffset:(float)yOffset;
+ (void) showLoading:(NSString*)text;
+ (void) showShortMessage:(NSString*)text;
+ (void) showShortMessage:(NSString*)text withTime:(double)time;
+ (void) showShortMessage:(NSString*)text withYOffset:(float)yOffset;
+ (void) removeLoading;
+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations;

@end
