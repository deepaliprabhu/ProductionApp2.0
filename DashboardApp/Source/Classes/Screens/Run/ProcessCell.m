//
//  ProcessCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProcessCell.h"

@implementation ProcessCell {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_processNoLabel;
    __weak IBOutlet UILabel *_processedLabel;
    __weak IBOutlet UIImageView *_shapeView;
    __weak IBOutlet UIView *_bgView;
    
    BOOL _forPlanning;
}

- (void) layoutWithPlanning:(ProcessModel*)process {
    
    _forPlanning = true;
    _shapeView.alpha = 0;
    _bgView.alpha = 0;
    _titleLabel.text = process.processName;
    _processedLabel.text = process.processingTime;
    _processNoLabel.text = process.processNo;
}

- (void) layoutWith:(ProcessModel*)process {
    
    _titleLabel.text = process.processName;
    _processedLabel.text = [NSString stringWithFormat:@"%d", process.processed];
    _processNoLabel.text = process.processNo;
}

- (void) setSelected:(BOOL)selected {
    
    if (_forPlanning == false) {
        _shapeView.alpha = selected;
        _bgView.alpha = selected;
    } else {
        [super setSelected:selected];
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (_forPlanning == false) {
        _shapeView.alpha = selected;
        _bgView.alpha = selected;
    } else {
        [super setSelected:selected animated:animated];
    }
}

@end
