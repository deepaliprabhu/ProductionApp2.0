//
//  DailyLogCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DailyLogCell.h"
#import "DataManager.h"

static NSDateFormatter *_formatter = nil;

@implementation DailyLogCell {
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_reworkLabel;
    __weak IBOutlet UILabel *_goodLabel;
    __weak IBOutlet UILabel *_rejectLabel;
    __weak IBOutlet UILabel *_operatorLabel;
    __weak IBOutlet UILabel *_commentsLabel;
    __weak IBOutlet UILabel *_dateLabel;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"EEEE    dd MMM yyyy";
    });
}

- (void) layoutWithLog:(DayLogModel*)log {
 
    _dateLabel.text = [_formatter stringFromDate:log.date];
    _processLabel.text = [[DataManager sharedInstance] processNameForProcessID:log.processNo];
    _runLabel.text = [NSString stringWithFormat:@"%d", log.runId];
    _targetLabel.text = [NSString stringWithFormat:@"%d", log.target];
    _reworkLabel.text = [NSString stringWithFormat:@"%d", log.rework];
    _goodLabel.text = [NSString stringWithFormat:@"%d", log.good];
    _rejectLabel.text = [NSString stringWithFormat:@"%d", log.reject];
    _operatorLabel.text = log.person;
    _commentsLabel.text = log.comments;
}

@end
