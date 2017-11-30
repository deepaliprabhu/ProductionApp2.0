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

- (void) layoutWithMax:(int)max min:(int)min {
    
    float total = (float)(max+min)*1.1;
    int edge = (int)(ceilf(((float)min/total)*10));
    if (edge == 0)
        edge = 1;
    else if (edge == 10)
        edge = 9;
    
    UIView *view = [self viewWithTag:edge + 100];
    view.backgroundColor = [UIColor blackColor];
    
    UILabel *label = (UILabel*)[self viewWithTag:edge + 200];
    label.text = @"0";
    
    int offset = (int)(0.1*total);
    offset = offset - offset%10;
    for (int i=0; i<=10; i++) {
    
        UILabel *label = (UILabel*)[self viewWithTag:i + 200];
        if (i < edge) {
            label.text = [NSString stringWithFormat:@"-%d", (edge-i)*offset];
        } else if (i > edge) {
            label.text = [NSString stringWithFormat:@"%d", (i-edge)*offset];
        }
    }
}

@end
