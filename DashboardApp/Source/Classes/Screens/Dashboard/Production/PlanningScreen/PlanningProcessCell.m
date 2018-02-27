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
    __weak IBOutlet UILabel *_leftLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UIView *_bgView;
    
    int _index;
}

- (void) layoutWithPlanning:(ProcessModel*)process leftQty:(int)qty target:(int)target atIndex:(int)index {
    
    _bgView.alpha = qty==0;
    
    _index = index;
    _titleLabel.text = process.processName;
    if (process.processingTime.length == 0)
        _timeLabel.text = @"-";
    else
        _timeLabel.text = process.processingTime;
    _processNoLabel.text = process.processNo;
    _leftLabel.text = [NSString stringWithFormat:@"%d", qty];
    _targetLabel.text = [NSString stringWithFormat:@"%d", target];
}

- (IBAction) timeButtonTapped {
    [_delegate changeTimeForProcessAtIndex:_index];
}

- (IBAction) targetButtonTapped {
    [_delegate changeTargetForProcessAtIndex:_index];
}

@end
