//
//  ProductionProcessCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionProcessCell.h"

@implementation ProductionProcessCell {
    
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_operatorLabel;
    
    int _runId;
}

- (void) layoutWithData:(NSDictionary*)dict {
    
    _runId = [dict[@"run"] intValue];
    _runLabel.text = [NSString stringWithFormat:@"%d", _runId];
    _processLabel.text = dict[@"process"];
    _statusLabel.text = dict[@"status"];
    _targetLabel.text = dict[@"target"];
    _operatorLabel.text = dict[@"person"];
}

- (IBAction) viewButtonTapped {
    [_delegate showDetailsForRunId:_runId];
}


@end
