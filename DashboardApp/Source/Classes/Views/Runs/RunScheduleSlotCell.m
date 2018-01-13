//
//  RunScheduleSlotCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunScheduleSlotCell.h"

@implementation RunScheduleSlotCell {
    __weak IBOutlet UIView *_slotView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) layoutWithBlink:(BOOL)blink {
    
    [_slotView.layer removeAllAnimations];
    if (blink) {
        [self animateBlink];
    }
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
    [_slotView.layer addAnimation:animation forKey:@"opacity"];
}

@end
