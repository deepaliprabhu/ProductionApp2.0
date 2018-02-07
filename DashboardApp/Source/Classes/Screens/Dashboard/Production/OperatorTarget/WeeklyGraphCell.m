//
//  WeeklyGraphCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 07/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "WeeklyGraphCell.h"
#import "WeeklyGraphBar.h"
#import "LayoutUtils.h"

static NSDateFormatter *_formatter = nil;

@implementation WeeklyGraphCell {
    __weak IBOutlet UILabel *_dayLabel;
    __weak IBOutlet UIView *_holderView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"dd MMM";
    });
}

+ (CGFloat) widthForProcessCount:(NSUInteger)c {
    return 20 + (c == 0 ? 50 : (c*22+(c-1)*6));
}

- (void) layoutWithDay:(NSDate*)day processes:(NSArray*)prs max:(long)max {
    
    NSArray *arr = [_holderView subviews];
    for (UIView *v in arr) {
        [v removeFromSuperview];
    }
    
    _dayLabel.text = [_formatter stringFromDate:day];
    
    for (int i=0; i<prs.count; i++) {
        
        NSDictionary *d = prs[i];
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@", d[@"run"], d[@"process"]];
        float goal = [d[@"goal"] floatValue];
        float proc = [d[@"processed"] floatValue];
        
        float valTarget = goal/max * 179.0f;
        float valProc   = proc/max * 179.0f;
        
        WeeklyGraphBar *bar = [WeeklyGraphBar createView];
        bar.translatesAutoresizingMaskIntoConstraints = false;
        [LayoutUtils addContraintWidth:22 andHeight:179 forView:bar];
        [_holderView addSubview:bar];
        [LayoutUtils addLeadingConstraintFromView:bar toView:_holderView constant:10+i*28];
        [LayoutUtils addTopConstraintFromView:bar toView:_holderView constant:0];
        [bar layoutWithText:text statusHeight:valProc targetHeight:valTarget];
    }
}

@end
