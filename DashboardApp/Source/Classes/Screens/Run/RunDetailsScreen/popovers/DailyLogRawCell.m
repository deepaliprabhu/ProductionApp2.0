//
//  DailyLogRawCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 11/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DailyLogRawCell.h"
#import "Defines.h"

@implementation DailyLogRawCell {
    
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_stepLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_runFlowIdLabel;
    __weak IBOutlet UILabel *_ratingLabel;
    __weak IBOutlet UILabel *_qtyTargetLabel;
    __weak IBOutlet UILabel *_qtyReworkLabel;
    __weak IBOutlet UILabel *_qtyRejectLabel;
    __weak IBOutlet UILabel *_qtyGoodLabel;
    __weak IBOutlet UILabel *_processNoLabel;
    __weak IBOutlet UILabel *_operatorLabel;
    __weak IBOutlet UILabel *_idLabel;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_dateCompletedLabel;
    __weak IBOutlet UILabel *_dateAssignedLabel;
    __weak IBOutlet UILabel *_commentsLabel;
}

- (void) layoutWithLog:(DayLogModel*)model atIndex:(int)idx {
 
    _bgView.backgroundColor = idx%2 == 0 ? [UIColor whiteColor] : ccolor(240, 244, 247);
    
    _stepLabel.text = [model data][@"stepid"];
    _statusLabel.text = [model data][@"status"];
    _runFlowIdLabel.text = [model data][@"run_flow_id"];
    _ratingLabel.text = [model data][@"rating"];
    _qtyTargetLabel.text = [model data][@"qtyTarget"];
    _qtyReworkLabel.text = [model data][@"qtyRework"];
    _qtyRejectLabel.text = [model data][@"qtyReject"];
    _qtyGoodLabel.text = [model data][@"qtyGood"];
    _processNoLabel.text = [model data][@"processno"];
    _operatorLabel.text = [model data][@"operator"];
    _idLabel.text = [model data][@"id"];
    _dateLabel.text = [model data][@"datetime"];
    _dateCompletedLabel.text = [model data][@"dateCompleted"];
    _dateAssignedLabel.text = [model data][@"dateAssigned"];
    _commentsLabel.text = [model data][@"comments"];
}

@end
