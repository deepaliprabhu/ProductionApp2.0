//
//  RunTargetCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunTargetCell.h"
#import "Defines.h"

@implementation RunTargetCell {
    
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet NSLayoutConstraint *_holderViewLeadingConstraint;
    __weak IBOutlet UIView *_holderView;
    __weak IBOutlet UIView *_rightSeparator;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _holderView.layer.cornerRadius = 6;
    _holderView.layer.masksToBounds = true;
    _holderView.layer.borderColor = ccolor(153, 153, 153).CGColor;
    _holderView.layer.borderWidth = 1;
}

- (void) layoutWithRun:(int)run isSelected:(BOOL)selected isFirst:(BOOL)first isLast:(BOOL)last {
    
    _runLabel.text = [NSString stringWithFormat:@"%d", run];
    _bgView.alpha = selected;
    _runLabel.textColor = selected ? [UIColor whiteColor] : ccolor(102, 102, 102);
    
    _rightSeparator.alpha = !last;
    
    if (first) {
        _holderViewLeadingConstraint.constant = 0;
    } else if (last) {
        _holderViewLeadingConstraint.constant = -16;
    } else {
        _holderViewLeadingConstraint.constant = -8;
    }
    [self layoutIfNeeded];
}

@end
