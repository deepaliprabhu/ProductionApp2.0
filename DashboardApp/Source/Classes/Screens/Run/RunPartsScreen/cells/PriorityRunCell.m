//
//  PriorityRunCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 16/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PriorityRunCell.h"
#import "Defines.h"

@implementation PriorityRunCell
{
    __unsafe_unretained IBOutlet UIView *_bgView;
    __unsafe_unretained IBOutlet UILabel *_runNameLabel;
    __unsafe_unretained IBOutlet UILabel *_orderLabel;
    __unsafe_unretained IBOutlet UILabel *_statusLabel;
    __unsafe_unretained IBOutlet UILabel *_containsLabel;
}

- (void) layoutWith:(Run*)run at:(int)index containsPart:(BOOL)c {

    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    _orderLabel.text = [NSString stringWithFormat:@"%d.", index+1];
    _statusLabel.text = [run getStatus];
    
    if (c == true) {
        _containsLabel.text = @"YES";
        _containsLabel.textColor = ccolor(67, 194, 81);
    } else {
        _containsLabel.text = @"NO";
        _containsLabel.textColor = ccolor(65, 65, 65);
    }
    
    if ([run getCategory] == 0) {
        _runNameLabel.text = [NSString stringWithFormat:@"[PCB] %d: %@",[run getRunId], [run getProductName]];
    }
    else {
        _runNameLabel.text = [NSString stringWithFormat:@"[ASSM] %d: %@",[run getRunId], [run getProductName]];
    }
}

@end
