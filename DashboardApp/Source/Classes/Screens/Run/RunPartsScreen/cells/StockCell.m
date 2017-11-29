//
//  StockCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockCell.h"

static NSDateFormatter *_formatter = nil;

@implementation StockCell
{
    __weak IBOutlet UILabel *_dateLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"dd MMM yyyy";
    });
}

- (void) layoutWith:(NSDictionary*)data {
 
    NSDate *d = [[data allKeys] firstObject];;
    _dateLabel.text = [_formatter stringFromDate:d];
}

@end
