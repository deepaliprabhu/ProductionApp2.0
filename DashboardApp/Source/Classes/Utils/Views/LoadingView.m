//
//  LoadingView.m
//  Auto
//
//  Created by Andrei Ghidoarca on 2/8/12.
//  Copyright (c) 2012 Gambit S.R.L. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"

@implementation LoadingView
{
    IBOutlet UIActivityIndicatorView *_spinner;
    IBOutlet UILabel *_textLabel;
    BOOL _keyboardIsShown;
    
    float _xOffset;
    float _yOffset;
}

#pragma mark - Class methods

+ (LoadingView*) sharedComponent
{
    static LoadingView *_loadingView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UINib *nib = [UINib nibWithNibName:@"LoadingView" bundle:nil];
        _loadingView = [nib instantiateWithOwner:nil options:nil][0];
        [_loadingView layout];
        
    });
    
    return _loadingView;
}

+ (void) showLoading:(cstr)text withYOffset:(float)yOffset
{
    [[LoadingView sharedComponent] makeVisibleWithText:text andYAxisOffset:yOffset];
}

+ (void) showLoading:(cstr)text
{
    [[LoadingView sharedComponent] makeVisibleWithText:text];
}

+ (void) showShortMessage:(cstr)text
{
    [self showShortMessage:text withTime:1];
}

+ (void) removeLoading
{
    [[LoadingView sharedComponent] removeFromScreen];
}

+ (void) showShortMessage:(cstr)text withYOffset:(float)yOffset
{
    [[LoadingView sharedComponent] makeVisibleWithTextWithoutSpinner:text andYAxisOffset:yOffset];
    __after(1, ^{
        [[LoadingView sharedComponent] removeFromScreenWithFade];
    });
}

+ (void) showShortMessage:(NSString *)text withTime:(double)time
{
    [[LoadingView sharedComponent] makeVisibleWithTextWithoutSpinner:text];
    __after(time, ^{
        [[LoadingView sharedComponent] removeFromScreenWithFade];
    });
}

+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Initialization

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout

- (void) layout
{   
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:15.0f];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Add and remove

- (void) show:(cstr)title
{
    self.alpha = 1;
    
    if (!iPad)
    {
        float width  = wScr;
        float height = hScr;
        
        if (isLandscape())
            self.center = ccp(height/2,width/2);
        else
            self.center = ccp(width/2, height/2);
    }
    else
    {
        if (isLandscape())
            self.center = ccp(512, 384);
        else
            self.center = ccp(384, 512);
    }
    
    if (_xOffset != 0)
    {
        cf frame = self.frame;
        frame.origin.x += _xOffset;
        self.frame = frame;
    }
    
    if (_yOffset != 0)
    {
        cf frame = self.frame;
        frame.origin.y += _yOffset;
        self.frame = frame;
    }
    
    _textLabel.text = title;
    [self removeFromSuperview];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

- (void) makeVisibleWithText:(NSString*)title
{
    [self removeFromScreen];
    
    if (_keyboardIsShown)
        _yOffset = -80;
    
    _textLabel.frame = ccf(7, 64, 107, 56);
    _textLabel.font  = ccSBFont(16.0f);
    
    if ([_spinner superview] == nil)
        [self addSubview:_spinner];
    
    [self show:title];
}

- (void) makeVisibleWithText:(NSString*)title andYAxisOffset:(float)offset
{
    [self removeFromScreen];
    
    if (offset != 0)
        _yOffset = offset;
    else
    {
        if (_keyboardIsShown)
            _yOffset = -80;
    }
    
    _textLabel.frame = ccf(7, 64, 107, 56);
    _textLabel.font  = ccSBFont(16.0f);
    
    if ([_spinner superview] == nil)
        [self addSubview:_spinner];
    
    [self show:title];
}

- (void) makeVisibleWithTextWithoutSpinner:(NSString *)title
{
    [self removeFromScreen];
    
    if (_keyboardIsShown)
        _yOffset = -80;
    
    _textLabel.frame = ccf(7, 0, 107, 120);
    _textLabel.font  = ccSFont(14.0f);
    
    self.alpha = 1;
    [_spinner removeFromSuperview];
    
    [self show:title];
}

- (void) makeVisibleWithTextWithoutSpinner:(NSString *)title andYAxisOffset:(float)offset
{
    [self removeFromScreen];
    
    if (offset != 0)
        _yOffset = offset;
    else
    {
        if (_keyboardIsShown)
            _yOffset = -80;
    }
    
    _textLabel.frame = ccf(7, 0, 107, 120);
    _textLabel.font  = ccSFont(14.0f);
    
    self.alpha = 1;
    [_spinner removeFromSuperview];
    
    [self show:title];
}

- (void) removeFromScreen
{
    if (_xOffset != 0)
    {
        cf frame = self.frame;
        frame.origin.x -= _xOffset;
        self.frame = frame;
        _xOffset = 0;
    }
    
    if (_yOffset != 0)
    {
        cf frame = self.frame;
        frame.origin.y -= _yOffset;
        self.frame = frame;
        _yOffset = 0;
    }
    
    [self removeFromSuperview];
}

- (void) removeFromScreenWithFade
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromScreen];
    }];
}

#pragma mark - Notifications

- (void) keyboardDidShow
{
    _keyboardIsShown = YES;
}

- (void) keyboardDidHide
{
    _keyboardIsShown = NO;
}

@end
