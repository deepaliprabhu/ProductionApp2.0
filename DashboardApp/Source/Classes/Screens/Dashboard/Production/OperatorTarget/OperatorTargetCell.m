//
//  OperatorTargetCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 30/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetCell.h"

@implementation OperatorTargetCell {
    
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_processLabel;
    
    int _row;
}

- (IBAction) logButtonTapped {
    [_delegate inputLogAt:_row];
}

@end
