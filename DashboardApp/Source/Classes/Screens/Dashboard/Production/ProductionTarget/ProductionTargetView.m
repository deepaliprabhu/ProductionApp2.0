//
//  ProductionTargetView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionTargetView.h"

@implementation ProductionTargetView

+ (ProductionTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"ProductionTargetView" bundle:nil];
    ProductionTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [_delegate goBackFromTargetView];
}

@end
