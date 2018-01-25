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
}

- (void) layoutWithProcess:(ProcessModel*)process {
    _processLabel.text = process.processName;
}

@end
