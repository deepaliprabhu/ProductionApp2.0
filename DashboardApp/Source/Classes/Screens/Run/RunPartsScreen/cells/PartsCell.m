//
//  PartsCell.m
//  DashboardApp
//
//  Created by Viggo IT on 08/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartsCell.h"
#import "Defines.h"

@implementation PartsCell {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_stockLabel;
    __weak IBOutlet UILabel *_vendorLabel;
    __weak IBOutlet UILabel *_quantityLabel;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
}

- (void) layoutWithShort:(PartModel*)m {
    
    UIColor *c = nil;
    _nameLabel.text = m.part;
    
    if (m.poQty == nil) {
        [_spinner startAnimating];
        _vendorLabel.text = @"";
    } else {
        [_spinner stopAnimating];
        if (m.hasPO == true) {
            _vendorLabel.text = m.poQty;
            c = ccolor(119, 119, 119);
        } else {
            _vendorLabel.text = @"NO PO";
            c = ccolor(233, 46, 40);
        }
    }
    
    _quantityLabel.text = [NSString stringWithFormat:@"%d", m.shortQty];
    _stockLabel.text = [NSString stringWithFormat:@"%d", [m totalStock]];
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%@$", m.pricePerUnit];
    else
        _priceLabel.text = @"-$";
    
    [self layoutWithColor:c];
}

- (void) layoutWithColor:(UIColor*)c {
    
    _nameLabel.textColor = c;
    _priceLabel.textColor = c;
    _stockLabel.textColor = c;
    _vendorLabel.textColor = c;
    _quantityLabel.textColor = c;
}

- (void) layoutWithPart:(PartModel*)m {
    
    UIColor *c = ccolor(119, 119, 119);
    
    _nameLabel.text = m.part;
    if (m.vendor.length == 0)
        _vendorLabel.text = @"-";
    else
        _vendorLabel.text = m.vendor;
    
    if (m.qty.length == 0)
        _quantityLabel.text = @"-";
    else
        _quantityLabel.text = m.qty;
    
    _stockLabel.text = [NSString stringWithFormat:@"%d", [m totalStock]];
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%@$", m.pricePerUnit];
    else
        _priceLabel.text = @"-$";
    
    [self layoutWithColor:c];
}

@end
