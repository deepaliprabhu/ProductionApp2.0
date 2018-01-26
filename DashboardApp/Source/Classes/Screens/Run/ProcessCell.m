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
}

- (void) layoutWith:(ProcessModel*)process {
    
    _titleLabel.text = process.processName;
    _processedLabel.text = [NSString stringWithFormat:@"%d", process.processed];
    _processNoLabel.text = process.processNo;
}

- (void) setSelected:(BOOL)selected {
    _shapeView.alpha = selected;
    _bgView.alpha = selected;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    _shapeView.alpha = selected;
    _bgView.alpha = selected;
}

@end
