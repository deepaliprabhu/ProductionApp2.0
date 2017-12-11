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
    __weak IBOutlet UIView *_separatorView;
    __weak IBOutlet UIActivityIndicatorView *_priceSpinner;
    __weak IBOutlet UIActivityIndicatorView *_poSpinner;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *color = _separatorView.backgroundColor;
    [super setSelected:selected animated:animated];
    if (selected) {
        _separatorView.backgroundColor = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIColor *color = _separatorView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    if (highlighted){
        _separatorView.backgroundColor = color;
    }
}

- (void) layoutWithShort:(PartModel*)m {
    
    UIColor *c = ccolor(100, 100, 100);
    _nameLabel.text = m.part;
    
    _separatorView.alpha = (m.alternateParts.count > 0);
    
    if (m.purchases == nil)
    {
        _vendorLabel.text = @"";
        [_poSpinner startAnimating];
    }
    else
    {
        [_poSpinner stopAnimating];
        if (m.purchases.count == 0) {
            _vendorLabel.text = @"NO PO";
            c = ccolor(233, 46, 40);
        } else {
            int q = [m openPOQty];
            if (q > 0)
                _vendorLabel.text = [NSString stringWithFormat:@"%d", q];
            else
                _vendorLabel.text = @"-";
            c = ccolor(119, 119, 119);
        }
    }
    
    if (m.shortQty > ([m totalStock] + [m openPOQty]))
        _quantityLabel.textColor = ccolor(233, 46, 40);
    else
        _quantityLabel.textColor = ccolor(67, 194, 81);
    
    _quantityLabel.text = [NSString stringWithFormat:@"%d", m.shortQty];
    _stockLabel.text = [NSString stringWithFormat:@"%d", [m totalStock]];
    
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%@$", m.pricePerUnit];
    else
        _priceLabel.text = @"-$";
    
    _vendorLabel.textColor = c;
}

- (void) layoutWithPart:(PartModel*)m {
    
    _separatorView.alpha = (m.alternateParts.count > 0);
    _nameLabel.text = m.part;
    if (m.vendor.length == 0)
        _vendorLabel.text = @"-";
    else
        _vendorLabel.text = m.vendor;
    
    if (m.qty.length == 0)
        _quantityLabel.text = @"-";
    else
        _quantityLabel.text = m.qty;
    
    _quantityLabel.textColor = ccolor(119, 119, 119);
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%@$", m.pricePerUnit];
    else
        _priceLabel.text = @"-$";
    
    _vendorLabel.textColor = ccolor(119, 119, 119);
    _stockLabel.text = [NSString stringWithFormat:@"%d", [m totalStock]];
}

@end
