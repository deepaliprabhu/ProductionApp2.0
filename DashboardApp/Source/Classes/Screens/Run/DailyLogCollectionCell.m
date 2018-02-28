//
//  DailyLogCollectionCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DailyLogCollectionCell.h"

static NSDateFormatter *_formatter = nil;

@implementation DailyLogCollectionCell {
    
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_reworkLabel;
    __weak IBOutlet UILabel *_goodLabel;
    __weak IBOutlet UILabel *_rejectLabel;
    __weak IBOutlet UILabel *_totalLabel;
    
    __weak IBOutlet NSLayoutConstraint *_reworkHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_rejectHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_goodHeightConstraint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"dd MMM yyyy";
    });
}

- (void) layoutWithDayLog:(NSArray*)logs maxVal:(int)max {
    
    _timeLabel.text = [_formatter stringFromDate:[[logs firstObject] date]];
    
    if (max == 0) {
        
        _rejectHeightConstraint.constant = 0;
        _reworkHeightConstraint.constant = 0;
        _goodHeightConstraint.constant = 0;
        _reworkLabel.text = @"";
        _rejectLabel.text = @"";
        _goodLabel.text = @"";
    } else {
        
        int rework = 0;
        int reject = 0;
        int good = 0;
        for (DayLogModel *day in logs) {
            rework += day.rework;
            good += day.good;
            reject += day.reject;
        }
        
        [self layoutLabel:_reworkLabel andConstraint:_reworkHeightConstraint withValue:rework andMax:max];
        [self layoutLabel:_rejectLabel andConstraint:_rejectHeightConstraint withValue:reject andMax:max];
        [self layoutLabel:_goodLabel andConstraint:_goodHeightConstraint withValue:good andMax:max];
    }
    
    int total = 0;
    for (DayLogModel *day in logs)
        total += [day totalWork];
    _totalLabel.text = [NSString stringWithFormat:@"%d", total];
    
    [self layoutIfNeeded];
}

- (void) layoutLabel:(UILabel*)label andConstraint:(NSLayoutConstraint*)c withValue:(int)value andMax:(int)max {
 
    float h = value/(CGFloat)(max) * 180.0f;
    c.constant = h;
    if (h > 12) {
        label.text = [NSString stringWithFormat:@"%d", value];
    } else {
        label.text = @"";
    }
}

@end
