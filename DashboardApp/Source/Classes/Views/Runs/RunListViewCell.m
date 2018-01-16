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
    IBOutlet UIView *_blinkView;
    IBOutlet UILabel *_commentsCountLabel;
    IBOutlet NSLayoutConstraint *_commentsCountLabelWidthConstraint;
    
    Run *_run;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    _commentsCountLabel.layer.masksToBounds = true;
    _commentsCountLabel.layer.cornerRadius = 7;
}

- (void) setCellData:(Run*)run showType:(BOOL)show showShipping:(BOOL)shipping blinking:(BOOL)blink {
    
    if ([run.last7DaysComments intValue] == 0) {
        _commentsCountLabel.alpha = 0;
    } else {
        _commentsCountLabel.alpha = 1;
        _commentsCountLabel.text = [run.last7DaysComments stringValue];
        if (_commentsCountLabel.text.length == 1) {
            _commentsCountLabelWidthConstraint.constant = 14;
        } else {
            _commentsCountLabelWidthConstraint.constant = 18;
        }
        [self layoutIfNeeded];
    }
    
    _run = run;
    
    [_blinkView.layer removeAllAnimations];
    if (blink && [_run isLocked]) {
        _blinkView.hidden = false;
        [self animateBlink];
    } else {
        _blinkView.hidden = true;
    }
    
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
    
    NSString *process = [run getRunData][@"Inprocess"];
    if (process.length == 0)
        process = @"-";
    NSString *ready = [run getRunData][@"Ready"];
    if (ready.length == 0)
        ready = @"-";
    _progressLabel.text = [NSString stringWithFormat:@"%@/%@", process, ready];
}

- (Run*) getRun {
    return _run;
}

- (IBAction) commentsButtonTapped {
    [_delegate showCommentsForRun:_run];
}

- (void) animateBlink
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:20000];
    [_blinkView.layer addAnimation:animation forKey:@"opacity"];
}

@end
