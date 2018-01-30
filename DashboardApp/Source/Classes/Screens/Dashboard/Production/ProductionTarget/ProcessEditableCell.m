//
//  ProcessEditableCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessEditableCell.h"

@implementation ProcessEditableCell {
    
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_operatorLabel;
    
    __weak IBOutlet NSLayoutConstraint *_targetButtonConstraint;
    __weak IBOutlet NSLayoutConstraint *_operatorButtonConstraint;
    
    int _row;
}

- (void) layoutWithData:(NSDictionary*)dict atRow:(int)row {
    
    _row = row;
    
    _statusLabel.text = dict[@"status"];
    _targetLabel.text = dict[@"target"];
    _operatorLabel.text = dict[@"person"];
    _processLabel.text = dict[@"process"];
    _timeLabel.text = [self timeForSeconds:[dict[@"processingTime"] intValue]];
}

- (NSString*) timeForSeconds:(int)time {
    
    if (time == 0)
        return @"-";
    else {
        
        time = (time/60)*60;
        int h = time/3600;
        int min = (time%3600)/60;
        if (h == 0) {
            return [NSString stringWithFormat:@"%dm", min];
        } else {
            return [NSString stringWithFormat:@"%dh %dm", h, min];
        }
    }
}

#pragma mark - Actions

- (IBAction) targetButtonTapped {
    
    CGRect r = [self convertRect:_targetLabel.frame toView:self.superview.superview];
    [_delegate showTargetInputForRow:_row rect:r];
}

- (IBAction) operatorButtonTapped {
    
    CGRect r = [self convertRect:_operatorLabel.frame toView:self.superview.superview.superview];
    [_delegate showOperatorsForRow:_row rect:r];
}

@end
