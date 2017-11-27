//
//  StockGraphScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockGraphScreen.h"

@interface StockGraphScreen ()

@end

@implementation StockGraphScreen
{
    __weak IBOutlet UIImageView *_backgroundImageView;
    __weak IBOutlet UIView *_holderView;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Layout

- (void) initLayout {
    
    _holderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _holderView.layer.shadowOffset = CGSizeMake(2, 2);
    _holderView.layer.shadowRadius = 10;
    _holderView.layer.shadowOpacity = 0.3;
    [self addBlur];
}

- (void) addBlur {
    
    _backgroundImageView.image = _image;
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithEffect:eff];
    v.frame = _backgroundImageView.bounds;
    v.alpha = 0.9;
    _backgroundImageView.alpha = 0.9;
    
    [_backgroundImageView addSubview:v];
}

@end
