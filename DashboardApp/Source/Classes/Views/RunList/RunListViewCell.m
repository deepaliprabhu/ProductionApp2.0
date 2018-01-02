//
//  RunListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunListViewCell.h"

@implementation RunListViewCell

- (void)setCellData:(Run*)run_ {
    
    run = run_;
    
    if ([run getCategory] == 0) {
        _runNameLabel.text = [NSString stringWithFormat:@"[PCB] %d: %@",[run getRunId], [run getProductName]];
    }
    else {
        _runNameLabel.text = [NSString stringWithFormat:@"[ASSM] %d: %@",[run getRunId], [run getProductName]];
    }

    _quantityLabel.text = [NSString stringWithFormat:@"%d",[run getQuantity]];
    _statusLabel.text = [run getStatus];
    _weekLabel.text = [run getRunData][@"Shipping"];
    _imageView.image = [UIImage imageNamed: [run isLocked] ? @"lockRunIcon" : @"unlockRunIcon"];
}

- (Run*)getRun {
    return run;
}

- (IBAction) commentsButtonTapped {
    [_delegate showCommentsForRun:run];
}

@end
