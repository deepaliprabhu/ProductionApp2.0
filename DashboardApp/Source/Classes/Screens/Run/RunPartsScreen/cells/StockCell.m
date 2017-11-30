//
//  StockCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockCell.h"

static NSDateFormatter *_formatter = nil;

@implementation StockCell
{
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_totalLabel;
    __weak IBOutlet NSLayoutConstraint *_barHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_barTopConstraint;
    
    __weak IBOutlet UILabel *_masonLabel;
    __weak IBOutlet UILabel *_puneLabel;
    __weak IBOutlet UILabel *_recoLabel;
    __weak IBOutlet UILabel *_runLabel;
    
    __weak IBOutlet NSLayoutConstraint *_masonheightConstraint;
    __weak IBOutlet NSLayoutConstraint *_puneHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_recoHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_runHeightConstraint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"dd MMM yyyy";
    });
}

- (void) layoutWith:(NSDictionary*)data maxPos:(int)pos maxNeg:(int)neg {
 
    NSDate *d = data[@"date"];
    _dateLabel.text = [_formatter stringFromDate:d];
    
    float total = (float)(pos+neg)*1.1;
    int pune = [data[@"pune"] intValue];
    int mason = [data[@"mason"] intValue];
    int reco = [data[@"reco"] intValue];
    int run = [data[@"run"] intValue];
    
    float curPos = pune + mason;
    _totalLabel.text = [NSString stringWithFormat:@"%d", (int)curPos];
    float curNeg = run + reco;
    float current = curPos + curNeg;
    
    float h = (current*330)/total;
    _barHeightConstraint.constant = h;
    
    int edge = (int)(ceilf(((float)neg/total)*10));
    if (edge == 0)
        edge = 1;
    else if (edge == 10)
        edge = 9;
    float posOffset = 0;
    if (current != 0)
        posOffset = curPos/current * h;
    float top = 330-edge*33.0 - posOffset;
    _barTopConstraint.constant = top;
    
    if (current != 0)
        _masonheightConstraint.constant = (float)mason/current * h;
    else
        _masonheightConstraint.constant = 0;
    if (_masonheightConstraint.constant < 30)
        _masonLabel.text = @"";
    else
        _masonLabel.text = [NSString stringWithFormat:@"%d", mason];
    
    if (current != 0)
        _puneHeightConstraint.constant = (float)pune/current * h;
    else
        _puneHeightConstraint.constant = 0;
    if (_puneHeightConstraint.constant < 30)
        _puneLabel.text = @"";
    else
        _puneLabel.text = [NSString stringWithFormat:@"%d", pune];
    
    if (current != 0)
        _recoHeightConstraint.constant = (float)reco/current * h;
    else
        _recoHeightConstraint.constant = 0;
    if (_recoHeightConstraint.constant < 30)
        _recoLabel.text = @"";
    else
        _recoLabel.text = [NSString stringWithFormat:@"%d", reco];
    
    if (current != 0)
        _runHeightConstraint.constant = (float)run/current * h;
    else
        _runHeightConstraint.constant = 0;
    if (_runHeightConstraint.constant < 30)
        _runLabel.text = @"";
    else
        _runLabel.text = [NSString stringWithFormat:@"%d", run];
    
    [self layoutIfNeeded];
}

@end
