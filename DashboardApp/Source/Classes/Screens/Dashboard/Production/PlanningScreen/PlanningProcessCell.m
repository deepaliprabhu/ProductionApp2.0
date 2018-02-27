//
//  PlanningProcessCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PlanningProcessCell.h"

@implementation PlanningProcessCell {

    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_processNoLabel;
    __weak IBOutlet UILabel *_timeLabel;
    
    int _index;
}

- (void) layoutWithPlanning:(ProcessModel*)process atIndex:(int)index {
    
    _index = index;
    _titleLabel.text = process.processName;
    if (process.processingTime.length == 0)
        _timeLabel.text = @"-";
    else
        _timeLabel.text = process.processingTime;
    _processNoLabel.text = process.processNo;
}

- (IBAction) timeButtonTapped {
    [_delegate changeTimeForProcessAtIndex:_index];
}

@end
