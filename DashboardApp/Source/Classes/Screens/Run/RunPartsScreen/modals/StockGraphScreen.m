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
    
    NSMutableArray <NSDictionary*> *_days;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    [self computeData];
}

#pragma mark - Actions

- (IBAction) closeButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
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

#pragma mark - Utils

- (void) computeData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (ActionModel *a in _part.audit.actions) {
        
        if (dict[a.date] == nil) {
            [dict setObject:@[a] forKey:a.date];
        } else {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:dict[a.date]];
            [arr addObject:a];
            [dict setObject:arr forKey:a.date];
        }
    }
    
    _days = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:key];
        [_days addObject:dict];
    }];
    
    [_days sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[[obj1 allKeys] firstObject] compare:[[obj2 allKeys] firstObject]];
    }];
}

@end
