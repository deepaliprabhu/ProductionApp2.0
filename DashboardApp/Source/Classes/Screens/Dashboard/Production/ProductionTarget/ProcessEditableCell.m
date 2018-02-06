//
//  ProcessEditableCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessEditableCell.h"
#import "DayLogModel.h"
#import "LayoutUtils.h"
#import "Defines.h"

static UIFont *_font = nil;

@implementation ProcessEditableCell {
    
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_operatorLabel;
    
    __weak IBOutlet NSLayoutConstraint *_targetButtonConstraint;
    __weak IBOutlet NSLayoutConstraint *_operatorButtonConstraint;
    __weak IBOutlet NSLayoutConstraint *_processTimeButtonConstraint;
    
    int _row;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _font = ccFont(@"Roboto-Light", 17);
    });
}

- (void) layoutWithData:(NSDictionary*)dict atRow:(int)row {
    
    _row = row;
    
    _statusLabel.text = dict[@"status"];
    
    DayLogModel *d = dict[@"dayModel"];
    NSString *goal = d.goal == 0 ? @"-" : [NSString stringWithFormat: @"%d", d.goal];
    _targetLabel.text = goal;
    float w = [LayoutUtils widthForText:goal withFont:_font];
    if (w>50)
        w=50;
    _targetButtonConstraint.constant = w/2 + 12;
    
    NSString *person = (d.person == nil || d.person.length == 0)? @"-" : d.person;
    _operatorLabel.text = person;
    w = [LayoutUtils widthForText:person withFont:_font];
    if (w>117)
        w=117;
    _operatorButtonConstraint.constant = w/2 + 12;
    
    ProcessModel * p = dict[@"process"];
    _processLabel.text = p.processName;
    
    int processingTime = [p.processingTime intValue];
    NSString *processTime = [self processTimeForSeconds:processingTime];
    NSString *totalTime = processingTime == 0 ? @"-" : [self totalTimeForSeconds:processingTime*d.goal];
    _timeLabel.text = [NSString stringWithFormat:@"%@/%@", processTime, totalTime];
    w = [LayoutUtils widthForText:_timeLabel.text withFont:_font];
    if (w>72)
        w=72;
    _processTimeButtonConstraint.constant = w/2 + 12;
    
    [self layoutIfNeeded];
}

- (NSString*) processTimeForSeconds:(int)time {
    
    if (time == 0)
        return @"-";
    else {
        
        if (time < 100) {
            return [NSString stringWithFormat:@"%ds", time];
        } else {
            int s = time%60;
            time = (time/60)*60;
            int h = time/3600;
            int m = (time%3600)/60;
            NSString *str = @"";
            if (s > 0)
                str = [NSString stringWithFormat:@"%ds", s];
            if (m > 0)
                str = [NSString stringWithFormat:@"%dm%@", m, str];
            if (h > 0)
                str = [NSString stringWithFormat:@"%dh%@", h, str];
            return str;
        }
    }
}

- (NSString*) totalTimeForSeconds:(int)time {
    
    if (time == 0)
        return @"-";
    else {
        
        time = (time/60)*60;
        int h = time/3600;
        int min = (time%3600)/60;
        if (h == 0) {
            return [NSString stringWithFormat:@"%dm", min];
        } else {
            if (min == 0)
                return [NSString stringWithFormat:@"%dh", h];
            else
                return [NSString stringWithFormat:@"%dh%dm", h, min];
        }
    }
}

#pragma mark - Actions

- (IBAction) targetButtonTapped {
    
    CGRect r = [self convertRect:_targetLabel.frame toView:self.superview.superview];
    [_delegate showTargetInputForRow:_row rect:r];
}

- (IBAction) operatorButtonTapped {
    
    CGRect r = [self convertRect:_operatorLabel.frame toView:self.superview.superview.superview];
    [_delegate showOperatorsForRow:_row rect:r];
}

- (IBAction) processTimeButtonTapped {
    [_delegate showProcessTimeInputForRow:_row];
}

@end
