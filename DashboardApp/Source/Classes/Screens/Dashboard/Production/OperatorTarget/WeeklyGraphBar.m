//
//  WeeklyGraphBar.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 07/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "WeeklyGraphBar.h"

@implementation WeeklyGraphBar {
    
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet NSLayoutConstraint *_processLabelBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *_statusHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_goalHeightConstraint;
}

+ (WeeklyGraphBar*) createView
{
    UINib *nib = [UINib nibWithNibName:@"WeeklyGraphBar" bundle:nil];
    WeeklyGraphBar *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) layoutWithText:(NSString*)text statusHeight:(float)s targetHeight:(float)t {
    
    _processLabel.text = text;
    _processLabelBottomConstraint.constant = MAX(s, t);
    _statusHeightConstraint.constant = s;
    _goalHeightConstraint.constant = t;
//    [self layoutIfNeeded];
}

@end
