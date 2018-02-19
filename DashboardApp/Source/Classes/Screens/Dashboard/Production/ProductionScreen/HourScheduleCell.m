//
//  HourScheduleCell.m
//  ProductionMobile
//
//  Created by Andrei Ghidoarca on 19/02/2018.
//  Copyright © 2018 Andrei Ghidoarca. All rights reserved.
//

#import "HourScheduleCell.h"

@implementation HourScheduleCell {
    
    __weak IBOutlet UILabel *_hourLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) layoutWithHour:(int)h {
    
    _hourLabel.text = [NSString stringWithFormat:@"%d", h];
}

@end
