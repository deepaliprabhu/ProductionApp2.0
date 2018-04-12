//
//  PackagingCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 11/04/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PackagingCell.h"

@implementation PackagingCell
{
    __weak IBOutlet UILabel *_orderIDLabel;
    __weak IBOutlet UILabel *_customerLabel;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet UILabel *_qtShipLabel;
    __weak IBOutlet UILabel *_shipToLabel;
    __weak IBOutlet UIButton *_shipToButton;
    
    int _index;
}

- (void) layoutWith:(PackagingModel*)model atIndex:(int)index {
    
    _index = index;
    
    _orderIDLabel.text = model.orderID;
    _customerLabel.text = model.customer;
    _countLabel.text = model.count;
    _qtShipLabel.text = model.qtShip;
    _shipToLabel.text = model.shipTo;
    
    if (model.shipTo.length == 0) {
        [_shipToButton setTitle:@"edit" forState:UIControlStateNormal];
    } else {
        [_shipToButton setTitle:@"___________" forState:UIControlStateNormal];
    }
}

- (IBAction) shipToButtonTapped {
    [_delegate presentShipToOptionsForOrderAtIndex:_index];
}

@end
