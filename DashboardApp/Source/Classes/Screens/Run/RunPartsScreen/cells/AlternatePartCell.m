//
//  AlternatePartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "AlternatePartCell.h"

@implementation AlternatePartCell
{
    __weak IBOutlet UILabel *_partNameLabel;
}

- (void) layoutWithPart:(NSString*)part
{
    _partNameLabel.text = [NSString stringWithFormat:@"(A) %@", part];
}

@end
