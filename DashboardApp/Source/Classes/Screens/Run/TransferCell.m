//
//  OrderCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 05/04/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "TransferCell.h"

@implementation TransferCell {
    __weak IBOutlet UILabel *_trackingNumberLabel;
    __weak IBOutlet UILabel *_toLabel;
    __weak IBOutlet UILabel *_sensorsCountLabel;
}

- (void) layoutWith:(TransferModel*)model {
    _toLabel.text = model.to;
    _trackingNumberLabel.text = model.trackingID.length == 0 ? @"-" : model.trackingID;
    _sensorsCountLabel.text = model.quantity;
}

@end
