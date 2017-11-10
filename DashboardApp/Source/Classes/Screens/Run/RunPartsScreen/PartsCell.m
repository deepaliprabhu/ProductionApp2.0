//
//  PartsCell.m
//  DashboardApp
//
//  Created by Viggo IT on 08/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartsCell.h"

@implementation PartsCell {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_stockLabel;
    __weak IBOutlet UILabel *_vendorLabel;
    __weak IBOutlet UILabel *_quantityLabel;
}

- (void) layoutWith:(PartModel*)m {
    
    _nameLabel.text = m.part;
    _vendorLabel.text = m.vendor;
    _stockLabel.text = [NSString stringWithFormat:@"%d", [m totalStock]];
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%@$", m.pricePerUnit];
    else
        _priceLabel.text = @"-$";
}

@end
