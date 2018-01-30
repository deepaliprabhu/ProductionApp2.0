//
//  OperatorTargetCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 30/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetCell.h"
#import "DayLogModel.h"
#import "ProcessModel.h"
#import "Run.h"

@implementation OperatorTargetCell {
    
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_processLabel;
    
    int _row;
}

- (void) layoutWithData:(NSDictionary*)dict atRow:(int)row {
    
    _row = row;
    
    _statusLabel.text = dict[@"status"];
    
    DayLogModel *d = dict[@"dayModel"];
    NSString *goal = d.goal == 0 ? @"-" : [NSString stringWithFormat: @"%d", d.goal];
    _targetLabel.text = goal;
    
    ProcessModel * p = dict[@"process"];
    _processLabel.text = p.processName;
    
    Run *r = dict[@"run"];
    _runLabel.text = [NSString stringWithFormat:@"%d", [r getRunId]];
    
    [self layoutIfNeeded];
}

- (IBAction) logButtonTapped {
    [_delegate inputLogAt:_row];
}

@end
