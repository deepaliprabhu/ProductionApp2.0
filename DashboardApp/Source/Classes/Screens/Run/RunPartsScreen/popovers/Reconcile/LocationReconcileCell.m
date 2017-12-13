//
//  LocationReconcileCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 13/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LocationReconcileCell.h"

@implementation LocationReconcileCell {
    
    __weak IBOutlet UILabel *_locationLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) layoutWithLocation:(NSString*)l {
    _locationLabel.text = l;
}

@end
