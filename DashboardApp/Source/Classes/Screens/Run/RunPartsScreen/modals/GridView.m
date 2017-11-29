//
//  GridView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "GridView.h"

@implementation GridView

+ (GridView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"GridView" bundle:nil];
    GridView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

@end
