//
//  RunListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunListViewCell.h"

@implementation RunListViewCell {
    
    IBOutlet UILabel *_runNameLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_weekLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_progressLabel;
    IBOutlet UIImageView *_imageView;
    
    Run *_run;
}

- (void) setCellData:(Run*)run showType:(BOOL)show showShipping:(BOOL)shipping {
    
    _run = run;
    
    if (show) {
        if ([run getCategory] == 0) {
            _runNameLabel.text = [NSString stringWithFormat:@"[PCB] %d: %@",[_run getRunId], [_run getProductName]];
        }
        else {
            _runNameLabel.text = [NSString stringWithFormat:@"[ASSM] %d: %@",[_run getRunId], [_run getProductName]];
        }
    } else {
        _runNameLabel.text = [NSString stringWithFormat:@"%d: %@",[_run getRunId], [_run getProductName]];
    }

    _quantityLabel.text = [NSString stringWithFormat:@"%d",[run getQuantity]];
    _statusLabel.text = [run getStatus];
    if (shipping == false) {
        _weekLabel.text = [run getRunData][@"Shipping"];
    } else {
        _weekLabel.text = @"";
    }
    _imageView.image = [UIImage imageNamed: [run isLocked] ? @"lockRunIcon" : @"unlockRunIcon"];
}

- (Run*) getRun {
    return _run;
}

- (IBAction) commentsButtonTapped {
    [_delegate showCommentsForRun:_run];
}

@end
