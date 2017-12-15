//
//  LockConfirmationCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LockConfirmationCell.h"

@implementation LockConfirmationCell {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_partType;
    __weak IBOutlet UILabel *_allocatedLabel;
    __weak IBOutlet UILabel *_priceLabel;
}

- (void) layoutWithPart:(PartModel*)p allocated:(int)all {
    
    _nameLabel.text = p.part;
    if (p.alternateParts.count == 0) {
        _partType.text = @"Alt.:";
        if (p.priceHistory.count > 0) {
            float altPrice = [p.priceHistory[0][@"PRICE"] floatValue];
            _priceLabel.text = [NSString stringWithFormat:@"%.4f$", altPrice];
        } else {
            _priceLabel.text = @"-$";
        }
    } else {
        _partType.text = @"Main:";
        _priceLabel.text = [NSString stringWithFormat:@"%.4f$", [p.pricePerUnit floatValue]];
    }
    
    _allocatedLabel.text = [NSString stringWithFormat:@"%d/%d", all, [p totalStock]];
}

@end
