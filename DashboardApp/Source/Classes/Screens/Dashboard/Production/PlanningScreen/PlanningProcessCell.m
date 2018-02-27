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
    __weak IBOutlet UILabel *_processedLabel;
}

- (void) layoutWithPlanning:(ProcessModel*)process {
    
    _titleLabel.text = process.processName;
    _processedLabel.text = process.processingTime;
    _processNoLabel.text = process.processNo;
}
@end
