//
//  DailyLogHeaderView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DailyLogHeaderView.h"
#import "NSDate+Utils.h"

static NSDateFormatter *_formatter = nil;

@implementation DailyLogHeaderView {
    __weak IBOutlet UILabel *_headerLabel;
}

__CREATEVIEW(DailyLogHeaderView, @"DailyLogHeaderView", 0);

+ (CGFloat) height {
    return 80;
}

- (void) layoutWithDate:(NSDate*)date {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"dd MMM yyyy";
    });
    
    NSDate *d = [date firstDateOfWeek];
    _headerLabel.text = [NSString stringWithFormat:@"Week of %@", [_formatter stringFromDate:d]]; 
}

@end
