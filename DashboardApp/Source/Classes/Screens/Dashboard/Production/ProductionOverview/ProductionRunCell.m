//
//  ProductionRunCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionRunCell.h"

@implementation ProductionRunCell {
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_processLabel;

    int _runId;
}

- (void) layoutWithData:(NSDictionary*)dict {
    
    _runId = [dict[@"run"] intValue];
    _runLabel.text = [NSString stringWithFormat:@"%d", _runId];
    _processLabel.text = dict[@"process"];
}

- (IBAction) viewButtonTapped {
    [_delegate showDetailsForRunId:_runId];
}

@end
