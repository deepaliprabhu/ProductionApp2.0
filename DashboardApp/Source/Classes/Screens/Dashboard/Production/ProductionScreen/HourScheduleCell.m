//
//  HourScheduleCell.m
//  ProductionMobile
//
//  Created by Andrei Ghidoarca on 19/02/2018.
//  Copyright © 2018 Andrei Ghidoarca. All rights reserved.
//

#import "HourScheduleCell.h"
#import "Defines.h"

@implementation HourScheduleCell {
    
    __weak IBOutlet UILabel *_hourLabel;
    __weak IBOutlet UIView *_separatorView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) layoutWithHour:(int)h selected:(BOOL)s {
    
    if (h%2 == 0)
        _hourLabel.text = [NSString stringWithFormat:@"%d", h];
    else
        _hourLabel.text = @"";
    
    _separatorView.backgroundColor = (s == false) ? [UIColor whiteColor] : ccolor(233, 233, 233);
}

@end
