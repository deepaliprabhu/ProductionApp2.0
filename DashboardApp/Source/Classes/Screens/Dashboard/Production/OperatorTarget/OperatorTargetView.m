//
//  OperatorTargetView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetView.h"

@implementation OperatorTargetView

+ (OperatorTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"OperatorTargetView" bundle:nil];
    OperatorTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [_delegate goBackFromOperatorView];
}

@end
